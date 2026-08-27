"use strict";

import { createOpenSCAD } from "./vendor/openscad.js";
import { makeThreeMf, validateBinaryStl } from "./mesh-codec.js";

function report(stage, message, detail = {}) {
  self.postMessage({ type: "progress", stage, message, ...detail });
}

function safeUnlink(fs, path) {
  try { fs.unlink(path); } catch { /* File may not exist yet. */ }
}

function defineArgs(parameters) {
  return Object.entries(parameters).flatMap(([name, value]) => {
    let literal;
    if (typeof value === "string") literal = `"${value.replaceAll("\\", "\\\\").replaceAll('"', '\\"')}"`;
    else if (typeof value === "boolean") literal = value ? "true" : "false";
    else literal = String(value);
    return ["-D", `${name}=${literal}`];
  });
}

async function loadSource(sourceUrl, logoUrl) {
  report("source", "Loading the pinned rack-mount source…");
  const [sourceResponse, logoResponse] = await Promise.all([fetch(sourceUrl), fetch(logoUrl)]);
  if (!sourceResponse.ok) throw new Error(`Could not load OpenSCAD source (${sourceResponse.status})`);
  if (!logoResponse.ok) throw new Error(`Could not load logo asset (${logoResponse.status})`);
  return { source: await sourceResponse.text(), logo: await logoResponse.text() };
}

async function createRuntime(files) {
  report("runtime", "Initializing the 14 MB OpenSCAD engine…");
  const log = [];
  const api = await createOpenSCAD({
    print: line => log.push(line),
    printErr: line => log.push(line),
  });
  const fs = api.getInstance().FS;
  try { fs.mkdir("/assets"); } catch { /* Already initialized. */ }
  fs.writeFile("/ha_green_rack.scad", files.source);
  fs.writeFile("/assets/home-assistant-logo.svg", files.logo);
  return { instance: api.getInstance(), log };
}

function render(instance, parameters, backend) {
  const output = `/output-${backend.toLowerCase()}.stl`;
  safeUnlink(instance.FS, output);
  const args = [
    "/ha_green_rack.scad",
    "--backend", backend,
    "--export-format", "binstl",
    ...defineArgs(parameters),
    "-o", output,
  ];
  const status = instance.callMain(args);
  if (status !== 0) throw new Error(`OpenSCAD ${backend} export exited with status ${status}`);
  const bytes = instance.FS.readFile(output, { encoding: "binary" });
  safeUnlink(instance.FS, output);
  return new Uint8Array(bytes);
}

async function generate(message) {
  const started = performance.now();
  const files = await loadSource(message.sourceUrl, message.logoUrl);
  let runtime = await createRuntime(files);

  let bytes;
  let mesh;
  let backend = "Manifold";
  report("compile", "Compiling with the fast Manifold backend…", { backend });
  try {
    bytes = render(runtime.instance, message.parameters, backend);
    report("validate", "Checking topology and dimensions…", { backend });
    mesh = validateBinaryStl(bytes, message.expected);
  } catch (fastError) {
    backend = "CGAL";
    report("fallback", `Fast mesh rejected (${fastError.message}); retrying with CGAL…`, { backend });
    // An Emscripten command-line instance cannot be trusted after callMain()
    // exits, so fallback uses a fresh module rather than reusing Manifold.
    runtime = await createRuntime(files);
    bytes = render(runtime.instance, message.parameters, backend);
    mesh = validateBinaryStl(bytes, message.expected);
  }

  report("package", "Packaging deterministic STL and 3MF downloads…", { backend });
  const threeMf = makeThreeMf(mesh, {
    name: message.outputStem,
    description: "Generated locally by the HA Green rack-mount static customizer.",
    config: message.config,
  });
  const elapsedMs = Math.round(performance.now() - started);
  const stl = bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength);
  self.postMessage({
    type: "complete",
    requestId: message.requestId,
    backend,
    elapsedMs,
    stl,
    threeMf: threeMf.buffer,
    report: {
      triangleCount: mesh.triangleCount,
      componentCount: mesh.componentCount,
      bounds: mesh.bounds,
      extent: mesh.extent,
      volumeMm3: mesh.volumeMm3,
      logTail: runtime.log.slice(-12),
    },
  }, [stl, threeMf.buffer]);
}

self.addEventListener("message", event => {
  if (event.data?.type !== "generate") return;
  generate(event.data).catch(error => {
    self.postMessage({
      type: "error",
      requestId: event.data.requestId,
      message: error instanceof Error ? error.message : String(error),
    });
  });
});
