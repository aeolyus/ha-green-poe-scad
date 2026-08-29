import assert from "node:assert/strict";
import { makeThreeMf, validateBinaryStl } from "./mesh-codec.js";

function tetrahedron(offset = [0, 0, 0], scale = 1, inward = false) {
  const points = [[0, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1]]
    .map(point => point.map((value, axis) => offset[axis] + value * scale));
  const outwardFaces = [[0, 2, 1], [0, 1, 3], [0, 3, 2], [1, 2, 3]];
  const faces = inward
    ? outwardFaces.map(([a, b, c]) => [a, c, b])
    : outwardFaces;
  const bytes = new Uint8Array(84 + faces.length * 50);
  const view = new DataView(bytes.buffer);
  view.setUint32(80, faces.length, true);
  faces.forEach((face, triangle) => {
    const offset = 84 + triangle * 50 + 12;
    face.forEach((vertex, corner) => points[vertex].forEach((value, axis) => {
      view.setFloat32(offset + corner * 12 + axis * 4, value, true);
    }));
  });
  return bytes;
}

function combine(...meshes) {
  const triangleCount = meshes.reduce(
    (sum, mesh) => sum + new DataView(mesh.buffer).getUint32(80, true),
    0,
  );
  const bytes = new Uint8Array(84 + triangleCount * 50);
  const view = new DataView(bytes.buffer);
  view.setUint32(80, triangleCount, true);
  let offset = 84;
  for (const mesh of meshes) {
    bytes.set(mesh.slice(84), offset);
    offset += mesh.length - 84;
  }
  return bytes;
}

const bytes = tetrahedron();
const mesh = validateBinaryStl(bytes, { extent: [1, 1, 1], componentCount: 1 });
assert.equal(mesh.triangleCount, 4);
assert.equal(mesh.componentCount, 1);
assert.ok(Math.abs(mesh.volumeMm3 - 1 / 6) < 1e-7);

const threeMf = makeThreeMf(mesh, {
  name: "tetrahedron",
  description: "codec test",
  config: { test: true },
});
assert.equal(new DataView(threeMf.buffer).getUint32(0, true), 0x04034b50);

const broken = bytes.slice();
new DataView(broken.buffer).setUint32(80, 5, true);
assert.throws(() => validateBinaryStl(broken), /length/);
assert.throws(
  () => validateBinaryStl(bytes, { componentCount: 2 }),
  /component count/,
);

const hollow = combine(
  tetrahedron([0, 0, 0], 4),
  tetrahedron([0.5, 0.5, 0.5], 0.5, true),
);
const hollowMesh = validateBinaryStl(hollow, { componentCount: 2 });
assert.ok(hollowMesh.volumeMm3 > 0);
assert.throws(
  () => validateBinaryStl(combine(bytes, tetrahedron([2, 2, 2], 1, true))),
  /detached inward-wound component/,
);

console.log("mesh-codec tests pass");
