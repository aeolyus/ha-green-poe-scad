"use strict";

const textEncoder = new TextEncoder();

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function finite(value, label) {
  assert(Number.isFinite(value), `${label} is not finite`);
  return value;
}

function floatBits(view, offset) {
  const value = view.getFloat32(offset, true);
  finite(value, "STL coordinate");
  // Treat -0 and +0 as the same vertex.
  return Object.is(value, -0) ? 0 : view.getUint32(offset, true);
}

function unionFind(size) {
  const parent = Uint32Array.from({ length: size }, (_, index) => index);
  const rank = new Uint8Array(size);
  const find = value => {
    let root = value;
    while (parent[root] !== root) root = parent[root];
    while (parent[value] !== value) {
      const next = parent[value];
      parent[value] = root;
      value = next;
    }
    return root;
  };
  const join = (left, right) => {
    left = find(left);
    right = find(right);
    if (left === right) return;
    if (rank[left] < rank[right]) [left, right] = [right, left];
    parent[right] = left;
    if (rank[left] === rank[right]) rank[left] += 1;
  };
  return { find, join };
}

export function validateBinaryStl(input, expected = {}) {
  const bytes = input instanceof Uint8Array ? input : new Uint8Array(input);
  assert(bytes.byteLength >= 84, "STL is shorter than its binary header");
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const triangleCount = view.getUint32(80, true);
  assert(triangleCount >= 4 && triangleCount <= (expected.maxTriangles || 250000),
    `Unexpected triangle count: ${triangleCount}`);
  assert(bytes.byteLength === 84 + triangleCount * 50,
    "STL length does not match its binary triangle count");

  const vertexIds = new Map();
  const vertexValues = [];
  const triangleIds = new Uint32Array(triangleCount * 3);
  const edges = new Map();
  const components = unionFind(triangleCount);
  const bounds = [[Infinity, Infinity, Infinity], [-Infinity, -Infinity, -Infinity]];

  const vertexId = offset => {
    const bits = [floatBits(view, offset), floatBits(view, offset + 4), floatBits(view, offset + 8)];
    const key = bits.join(":");
    const existing = vertexIds.get(key);
    if (existing !== undefined) return existing;
    const values = bits.map((_, axis) => view.getFloat32(offset + axis * 4, true) || 0);
    for (let axis = 0; axis < 3; axis += 1) {
      bounds[0][axis] = Math.min(bounds[0][axis], values[axis]);
      bounds[1][axis] = Math.max(bounds[1][axis], values[axis]);
    }
    const id = vertexValues.length / 3;
    vertexIds.set(key, id);
    vertexValues.push(...values);
    return id;
  };

  const addEdge = (from, to, triangle) => {
    const low = Math.min(from, to);
    const high = Math.max(from, to);
    const key = `${low}:${high}`;
    const direction = from === low ? 1 : -1;
    const edge = edges.get(key);
    if (!edge) edges.set(key, { count: 1, direction, triangle });
    else {
      edge.count += 1;
      edge.direction += direction;
      components.join(edge.triangle, triangle);
    }
  };

  for (let triangle = 0; triangle < triangleCount; triangle += 1) {
    const base = 84 + triangle * 50;
    for (let axis = 0; axis < 3; axis += 1) finite(view.getFloat32(base + axis * 4, true), "STL normal");
    const ids = [vertexId(base + 12), vertexId(base + 24), vertexId(base + 36)];
    assert(new Set(ids).size === 3, `Triangle ${triangle} repeats a vertex`);
    triangleIds.set(ids, triangle * 3);
    // CGAL sometimes triangulates a straight boundary with a collinear
    // three-vertex facet. Preserve those harmless subdivisions when all
    // vertices are distinct; edge incidence and component-volume checks
    // below still reject open, over-shared, or zero-volume output.
    addEdge(ids[0], ids[1], triangle);
    addEdge(ids[1], ids[2], triangle);
    addEdge(ids[2], ids[0], triangle);
  }

  for (const [key, edge] of edges) {
    assert(edge.count === 2, `Non-manifold edge ${key} is used ${edge.count} times`);
    assert(edge.direction === 0, `Edge ${key} has inconsistent winding`);
  }

  const extent = bounds[1].map((value, axis) => value - bounds[0][axis]);
  if (expected.maxBounds) {
    for (let axis = 0; axis < 3; axis += 1) {
      assert(bounds[0][axis] >= expected.maxBounds[0][axis] - 0.05, "Mesh exceeds its minimum safety bound");
      assert(bounds[1][axis] <= expected.maxBounds[1][axis] + 0.05, "Mesh exceeds its maximum safety bound");
    }
  }
  if (expected.extent) {
    for (let axis = 0; axis < 3; axis += 1) {
      if (expected.extent[axis] == null) continue;
      assert(Math.abs(extent[axis] - expected.extent[axis]) <= (expected.extentTolerance || 0.08),
        `Unexpected mesh extent on axis ${axis}: ${extent[axis].toFixed(3)} mm`);
    }
  }

  const sums = new Map();
  for (let triangle = 0; triangle < triangleCount; triangle += 1) {
    const ids = triangleIds.slice(triangle * 3, triangle * 3 + 3);
    const a = vertexValues.slice(ids[0] * 3, ids[0] * 3 + 3);
    const b = vertexValues.slice(ids[1] * 3, ids[1] * 3 + 3);
    const c = vertexValues.slice(ids[2] * 3, ids[2] * 3 + 3);
    const value = (
      a[0] * (b[1] * c[2] - b[2] * c[1])
      - a[1] * (b[0] * c[2] - b[2] * c[0])
      + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) / 6;
    const root = components.find(triangle);
    const state = sums.get(root) || { sum: 0, correction: 0 };
    const corrected = value - state.correction;
    const next = state.sum + corrected;
    state.correction = (next - state.sum) - corrected;
    state.sum = next;
    sums.set(root, state);
  }
  for (const state of sums.values()) assert(state.sum > 1e-6, "Mesh contains a zero-volume or inward-wound component");
  if (expected.componentCount != null) {
    assert(
      sums.size === expected.componentCount,
      `Unexpected component count: ${sums.size}`,
    );
  }

  return {
    bytes,
    vertices: new Float32Array(vertexValues),
    triangles: triangleIds,
    triangleCount,
    componentCount: sums.size,
    bounds,
    extent,
    volumeMm3: [...sums.values()].reduce((sum, state) => sum + state.sum, 0),
  };
}

function xmlEscape(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

function crc32(bytes) {
  let crc = 0xffffffff;
  for (const byte of bytes) {
    crc ^= byte;
    for (let bit = 0; bit < 8; bit += 1) crc = (crc >>> 1) ^ (0xedb88320 & -(crc & 1));
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function storedZip(entries) {
  const records = [];
  let localSize = 0;
  for (const entry of entries) {
    const name = textEncoder.encode(entry.name);
    const data = entry.data instanceof Uint8Array ? entry.data : textEncoder.encode(entry.data);
    assert(name.length < 65536 && data.length < 0xffffffff, "ZIP entry is too large");
    const record = { name, data, crc: crc32(data), offset: localSize };
    localSize += 30 + name.length + data.length;
    records.push(record);
  }
  const centralSize = records.reduce((sum, entry) => sum + 46 + entry.name.length, 0);
  const output = new Uint8Array(localSize + centralSize + 22);
  const view = new DataView(output.buffer);
  let offset = 0;
  for (const entry of records) {
    view.setUint32(offset, 0x04034b50, true);
    view.setUint16(offset + 4, 20, true);
    view.setUint16(offset + 6, 0x0800, true);
    view.setUint16(offset + 8, 0, true);
    view.setUint16(offset + 10, 0, true);
    view.setUint16(offset + 12, 0x0021, true);
    view.setUint32(offset + 14, entry.crc, true);
    view.setUint32(offset + 18, entry.data.length, true);
    view.setUint32(offset + 22, entry.data.length, true);
    view.setUint16(offset + 26, entry.name.length, true);
    output.set(entry.name, offset + 30);
    output.set(entry.data, offset + 30 + entry.name.length);
    offset += 30 + entry.name.length + entry.data.length;
  }
  const centralOffset = offset;
  for (const entry of records) {
    view.setUint32(offset, 0x02014b50, true);
    view.setUint16(offset + 4, 20, true);
    view.setUint16(offset + 6, 20, true);
    view.setUint16(offset + 8, 0x0800, true);
    view.setUint16(offset + 10, 0, true);
    view.setUint16(offset + 12, 0, true);
    view.setUint16(offset + 14, 0x0021, true);
    view.setUint32(offset + 16, entry.crc, true);
    view.setUint32(offset + 20, entry.data.length, true);
    view.setUint32(offset + 24, entry.data.length, true);
    view.setUint16(offset + 28, entry.name.length, true);
    view.setUint32(offset + 42, entry.offset, true);
    output.set(entry.name, offset + 46);
    offset += 46 + entry.name.length;
  }
  view.setUint32(offset, 0x06054b50, true);
  view.setUint16(offset + 8, records.length, true);
  view.setUint16(offset + 10, records.length, true);
  view.setUint32(offset + 12, centralSize, true);
  view.setUint32(offset + 16, centralOffset, true);
  return output;
}

export function makeThreeMf(mesh, { name, description, config }) {
  const vertices = [];
  for (let index = 0; index < mesh.vertices.length; index += 3) {
    vertices.push(`<vertex x="${Math.fround(mesh.vertices[index])}" y="${Math.fround(mesh.vertices[index + 1])}" z="${Math.fround(mesh.vertices[index + 2])}"/>`);
  }
  const triangles = [];
  for (let index = 0; index < mesh.triangles.length; index += 3) {
    triangles.push(`<triangle v1="${mesh.triangles[index]}" v2="${mesh.triangles[index + 1]}" v3="${mesh.triangles[index + 2]}"/>`);
  }
  const model = `<?xml version="1.0" encoding="UTF-8"?>\n<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:hag="urn:home-assistant-green-rack:config"><metadata name="Title">${xmlEscape(name)}</metadata><metadata name="Description">${xmlEscape(description)}</metadata><metadata name="hag:config" preserve="1">${xmlEscape(JSON.stringify(config))}</metadata><resources><object id="1" name="${xmlEscape(name)}" type="model"><mesh><vertices>${vertices.join("")}</vertices><triangles>${triangles.join("")}</triangles></mesh></object></resources><build><item objectid="1"/></build></model>`;
  return storedZip([
    { name: "[Content_Types].xml", data: `<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/></Types>` },
    { name: "_rels/.rels", data: `<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>` },
    { name: "3D/3dmodel.model", data: model },
  ]);
}
