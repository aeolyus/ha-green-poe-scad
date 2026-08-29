"use strict";

import { validateBinaryStl } from "./mesh-codec.js";

const SOURCE_VERSION = "8cd97bef614ddf775c0e4db6aa8fe2716e761926a401dda6fe50e1ef8d747aee";
const GENERATOR_CACHE_VERSION = "2";
const CACHE_DATABASE = "ha-green-rack-customizer-v1";
const CACHE_STORE = "artifacts";

const DEFAULTS = Object.freeze({
  spacing: "cable_friendly",
  customSetback: 60,
  ethernetEntry: "rear",
  frontPosition: "right",
  trayStyle: "friction_raised",
  greenClearance: 0.5,
  greenInterference: 0.1,
  splitterClearance: 0.4,
  splitterInterference: 0.05,
  faceLogo: false,
  ledShutter: false,
  part: "one_piece",
  showGreen: true,
  showSplitter: true,
  showCables: true,
  showLeds: true,
  autoRotate: false,
});

const LABELS = {
  spacing: {
    compact: "Compact · 35 mm",
    balanced: "Balanced · 1.75 in clear",
    cable_friendly: "Cable-friendly · 60 mm",
    custom: "Custom",
  },
  frontPosition: {
    right: "Center gap",
    far_right: "HA right",
    left: "Left",
  },
  trayStyle: {
    friction_raised: "Friction fit · unified raised deck",
    friction_pads: "Friction fit · four pads",
    friction_full: "Friction fit · full honeycomb",
    friction_skeletal: "Friction fit · open frame",
    standard: "Factory-screw tray",
  },
  part: {
    one_piece: "One-piece mount",
    x2d_plate: "X2D split plate",
    core: "Split core only",
  },
};

const form = document.querySelector("#customizer-form");
const frontPositionSection = document.querySelector("#front-position");
const customSetbackControl = document.querySelector("#custom-setback-control");
const customSpacingToggle = document.querySelector("#custom-spacing-toggle");
const summaryList = document.querySelector("#summary-list");
const warnings = document.querySelector("#warnings");
const commandOutput = document.querySelector("#command-output");
const viewerLink = document.querySelector("#viewer-link");
const fullViewerLink = document.querySelector("#full-viewer-link");
const liveViewer = document.querySelector("#live-viewer");
const generateButton = document.querySelector("#generate-mesh");
const cancelButton = document.querySelector("#cancel-generation");
const generationStatus = document.querySelector("#generation-status");
const generationProgress = document.querySelector("#generation-progress");
const generationMessage = document.querySelector("#generation-message");
const generationDetail = document.querySelector("#generation-detail");
const meshDownloads = document.querySelector("#mesh-downloads");
const stlDownload = document.querySelector("#download-stl");
const threeMfDownload = document.querySelector("#download-3mf");
let customSpacingEnabled = false;
let meshWorker = null;
let generationRequestId = 0;
let generatedUrls = [];
let generatedSignature = "";

function openArtifactCache() {
  if (!("indexedDB" in window)) return Promise.resolve(null);
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(CACHE_DATABASE, 1);
    request.onupgradeneeded = () => request.result.createObjectStore(CACHE_STORE);
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function cachedArtifact(key) {
  try {
    const database = await openArtifactCache();
    if (!database) return null;
    return await new Promise((resolve, reject) => {
      const transaction = database.transaction(CACHE_STORE, "readonly");
      const request = transaction.objectStore(CACHE_STORE).get(key);
      request.onsuccess = () => resolve(request.result || null);
      request.onerror = () => reject(request.error);
    });
  } catch {
    return null;
  }
}

async function cacheArtifact(key, artifact) {
  try {
    const database = await openArtifactCache();
    if (!database) return;
    await new Promise((resolve, reject) => {
      const transaction = database.transaction(CACHE_STORE, "readwrite");
      transaction.objectStore(CACHE_STORE).put(artifact, key);
      transaction.oncomplete = resolve;
      transaction.onerror = () => reject(transaction.error);
    });
  } catch {
    // Cache failure must never block a valid generated download.
  }
}

function selected(name) {
  return form.querySelector(`[name="${name}"]:checked`)?.value;
}

function numberValue(id, fallback) {
  const input = document.querySelector(`#${id}`);
  const value = Number(input.value);
  return Number.isFinite(value) ? value : fallback;
}

function getConfig() {
  const spacing = customSpacingEnabled ? "custom" : selected("spacing");
  return {
    schemaVersion: 1,
    project: "home-assistant-green-rack",
    geometry: {
      part: selected("part"),
      splitterModel: "tplink",
      spacing,
      splitterSetbackMm: spacing === "custom" ? numberValue("custom-setback", 60) : null,
      ethernetEntry: selected("ethernetEntry"),
      frontKeystoneSide: selected("frontPosition"),
      greenTrayStyle: selected("trayStyle"),
      ledShutterEnabled: document.querySelector("#led-shutter").checked,
      ledWindowInsertEnabled: false,
      faceLogoEnabled: document.querySelector("#face-logo").checked,
      greenClearanceMmPerSide: numberValue("green-clearance", 0.5),
      greenFrictionInterferenceMmPerSide: numberValue("green-interference", 0.1),
      splitterClearanceMmPerSide: numberValue("splitter-clearance", 0.4),
      splitterFrictionInterferenceMmPerSide: numberValue("splitter-interference", 0.05),
    },
    viewer: {
      protection: "open",
      showGreen: document.querySelector("#show-green").checked,
      showSplitter: document.querySelector("#show-splitter").checked,
      showCables: document.querySelector("#show-cables").checked,
      simulateLeds: document.querySelector("#show-leds").checked,
      autoRotate: document.querySelector("#auto-rotate").checked,
    },
  };
}

function effectiveSetback(config) {
  if (config.geometry.spacing === "custom") return config.geometry.splitterSetbackMm;
  if (config.geometry.spacing === "compact") return 35;
  if (config.geometry.spacing === "balanced") return 47.5;
  if (config.geometry.ethernetEntry === "front" && config.geometry.frontKeystoneSide === "left") return 89;
  return 60;
}

function scadParameters(config) {
  const g = config.geometry;
  const params = {
    part: g.part,
    splitter_model: g.splitterModel,
    front_ethernet_enabled: g.ethernetEntry === "front",
    front_keystone_side: g.frontKeystoneSide,
    green_tray_style: g.greenTrayStyle,
    led_shutter_enabled: g.ledShutterEnabled,
    led_window_insert_enabled: g.ledWindowInsertEnabled,
    face_logo_enabled: g.faceLogoEnabled,
    green_clearance: g.greenClearanceMmPerSide,
    friction_interference: g.greenFrictionInterferenceMmPerSide,
    splitter_clearance: g.splitterClearanceMmPerSide,
    splitter_friction_interference: g.splitterFrictionInterferenceMmPerSide,
  };

  if (g.spacing === "compact") params.splitter_y_override = 35;
  if (g.spacing === "balanced") params.splitter_y_override = 47.5;
  if (g.spacing === "custom") params.splitter_y_override = g.splitterSetbackMm;
  return params;
}

function scadLiteral(value) {
  if (typeof value === "string") return `"${value.replaceAll("\\", "\\\\").replaceAll('"', '\\"')}"`;
  if (typeof value === "boolean") return value ? "true" : "false";
  return String(value);
}

function outputStem(config) {
  const g = config.geometry;
  const entry = g.ethernetEntry === "rear" ? "rear" : `front_${g.frontKeystoneSide}`;
  const spacing = g.spacing === "custom" ? `${effectiveSetback(config)}mm` : g.spacing;
  const windowMode = g.ledShutterEnabled ? "shutter" : "open_window";
  const face = g.faceLogoEnabled ? "logo" : "plain_face";
  return `${g.part}_${entry}_${spacing}_${g.greenTrayStyle}_${windowMode}_${face}`.replaceAll(".", "p");
}

function buildCommand(config) {
  const definitions = Object.entries(scadParameters(config))
    .map(([key, value]) => `  -D '${key}=${scadLiteral(value)}' \\`);
  return [
    `openscad -o exports/${outputStem(config)}.stl \\`,
    ...definitions,
    "  ha_green_rack.scad",
  ].join("\n");
}

function openscadPreset(config) {
  return {
    fileFormatVersion: "1",
    parameterSets: {
      "HA Green selected configuration": scadParameters(config),
    },
  };
}

function viewerHash(config, embedded = false) {
  const g = config.geometry;
  const v = config.viewer;
  const frontMap = { right: "center", far_right: "ha_right", left: "left" };
  const supportMap = { friction_raised: "raised", friction_pads: "pads", friction_full: "full", friction_skeletal: "skeletal", standard: "raised" };
  const spacing = ["compact", "balanced", "cable_friendly"].includes(g.spacing) ? g.spacing : "cable_friendly";
  const params = new URLSearchParams({
    splitter: "tplink",
    spacing,
    entry: g.ethernetEntry,
    front: frontMap[g.frontKeystoneSide],
    retention: g.greenTrayStyle === "standard" ? "factory_screws" : "friction_sleeve",
    support: supportMap[g.greenTrayStyle],
    protection: "open",
    green: v.showGreen ? "1" : "0",
    poe: v.showSplitter ? "1" : "0",
    cables: v.showCables ? "1" : "0",
    logo: g.faceLogoEnabled ? "1" : "0",
    shutter: g.ledShutterEnabled ? "1" : "0",
    open: "0",
    leds: v.simulateLeds ? "1" : "0",
    mechanism: "0",
    highlight: "0",
    airframe_highlight: "0",
    rotate: v.autoRotate ? "1" : "0",
  });
  return `../viewer/interactive_viewer.html${embedded ? "?embed=1" : ""}#${params}`;
}

function configHash(config) {
  const g = config.geometry;
  const v = config.viewer;
  return new URLSearchParams({
    v: "1",
    part: g.part,
    spacing: g.spacing,
    setback: String(effectiveSetback(config)),
    entry: g.ethernetEntry,
    front: g.frontKeystoneSide,
    tray: g.greenTrayStyle,
    green_clearance: String(g.greenClearanceMmPerSide),
    green_interference: String(g.greenFrictionInterferenceMmPerSide),
    splitter_clearance: String(g.splitterClearanceMmPerSide),
    splitter_interference: String(g.splitterFrictionInterferenceMmPerSide),
    logo: g.faceLogoEnabled ? "1" : "0",
    shutter: g.ledShutterEnabled ? "1" : "0",
    green: v.showGreen ? "1" : "0",
    poe: v.showSplitter ? "1" : "0",
    cables: v.showCables ? "1" : "0",
    leds: v.simulateLeds ? "1" : "0",
    rotate: v.autoRotate ? "1" : "0",
  }).toString();
}

function configFromHash() {
  const raw = decodeURIComponent(location.hash.slice(1));
  if (!raw) return null;
  if (!raw.includes("=")) {
    const padding = "=".repeat((4 - raw.length % 4) % 4);
    return JSON.parse(atob(raw + padding));
  }

  const params = new URLSearchParams(raw);
  const number = (name, fallback) => {
    const value = Number(params.get(name));
    return Number.isFinite(value) ? value : fallback;
  };
  const enabled = (name, fallback) => {
    const value = params.get(name);
    return value === null ? fallback : value === "1";
  };
  const spacing = params.get("spacing") || DEFAULTS.spacing;
  return {
    geometry: {
      part: params.get("part") || DEFAULTS.part,
      spacing,
      splitterSetbackMm: spacing === "custom"
        ? number("setback", DEFAULTS.customSetback)
        : null,
      ethernetEntry: params.get("entry") || DEFAULTS.ethernetEntry,
      frontKeystoneSide: params.get("front") || DEFAULTS.frontPosition,
      greenTrayStyle: params.get("tray") || DEFAULTS.trayStyle,
      greenClearanceMmPerSide: number("green_clearance", DEFAULTS.greenClearance),
      greenFrictionInterferenceMmPerSide: number("green_interference", DEFAULTS.greenInterference),
      splitterClearanceMmPerSide: number("splitter_clearance", DEFAULTS.splitterClearance),
      splitterFrictionInterferenceMmPerSide: number("splitter_interference", DEFAULTS.splitterInterference),
      faceLogoEnabled: enabled("logo", DEFAULTS.faceLogo),
      ledShutterEnabled: enabled("shutter", DEFAULTS.ledShutter),
    },
    viewer: {
      showGreen: enabled("green", DEFAULTS.showGreen),
      showSplitter: enabled("poe", DEFAULTS.showSplitter),
      showCables: enabled("cables", DEFAULTS.showCables),
      simulateLeds: enabled("leds", DEFAULTS.showLeds),
      autoRotate: enabled("rotate", DEFAULTS.autoRotate),
    },
  };
}

function validate(config) {
  const messages = [];
  const g = config.geometry;
  const setback = effectiveSetback(config);
  if (g.part === "one_piece") messages.push("The one-piece face is 254 mm wide. On an X2D, center it carefully and use no brim; choose the split plate if the slicer rejects the 1 mm side margins.");
  if (g.ethernetEntry === "front" && g.frontKeystoneSide === "far_right" && g.part !== "one_piece") messages.push("The HA-right keystone occupies the detachable ear joint, so this combination must use the one-piece output.");
  if (g.spacing === "compact") messages.push("Compact spacing violates the modeled straight-cable bend targets and is a comparison, not a recommended production choice.");
  if (g.spacing === "balanced") messages.push("Balanced provides 44.5 mm / 1.75 in from the panel's inside face to the splitter and has been physically checked with the current flexible cable.");
  if (g.spacing === "custom") messages.push("Custom setback values have not been collision-validated by this page.");
  if (g.ethernetEntry === "front" && g.frontKeystoneSide === "left" && setback < 89) messages.push("The left front keystone needs an 89 mm splitter setback for the validated cable path.");
  if (g.greenTrayStyle.startsWith("friction")) messages.push("Print the Green and TP-Link friction coupons before committing to the full plate.");
  return messages;
}

function updateChoiceAvailability(config) {
  const isFront = config.geometry.ethernetEntry === "front";
  frontPositionSection.hidden = !isFront;
  const farRight = form.querySelector('[name="frontPosition"][value="far_right"]');
  const nonOnePiece = config.geometry.part !== "one_piece";
  farRight.closest("label").classList.toggle("invalid-choice", isFront && nonOnePiece);
}

function updateSummary() {
  let config = getConfig();
  updateChoiceAvailability(config);

  if (config.geometry.ethernetEntry === "front" && config.geometry.frontKeystoneSide === "far_right" && config.geometry.part !== "one_piece") {
    form.querySelector('[name="part"][value="one_piece"]').checked = true;
    config = getConfig();
  }

  const g = config.geometry;
  const entryLabel = g.ethernetEntry === "rear" ? "Rear" : `Front · ${LABELS.frontPosition[g.frontKeystoneSide]}`;
  const windowLabel = g.ledShutterEnabled ? "Captive shutter" : "Open LED aperture";
  const faceLabel = g.faceLogoEnabled ? "Logo recess + inlay" : "Plain / no logo";
  summaryList.innerHTML = [
    ["Output", LABELS.part[g.part]],
    ["Ethernet", entryLabel],
    ["Splitter setback", `${effectiveSetback(config)} mm`],
    ["Green retention", LABELS.trayStyle[g.greenTrayStyle]],
    ["LED window", windowLabel],
    ["Face", faceLabel],
    ["Protection", "Open tray"],
  ].map(([term, value]) => `<dt>${term}</dt><dd>${value}</dd>`).join("");

  warnings.innerHTML = validate(config).map(message => `<div class="warning">${message}</div>`).join("");
  commandOutput.value = buildCommand(config);
  viewerLink.href = viewerHash(config);
  fullViewerLink.href = viewerHash(config);
  const embeddedViewerUrl = viewerHash(config, true);
  if (liveViewer.getAttribute("src") !== embeddedViewerUrl)
    liveViewer.setAttribute("src", embeddedViewerUrl);
  const signature = JSON.stringify(scadParameters(config));
  if (generatedSignature && generatedSignature !== signature) clearGeneratedDownloads();
  history.replaceState(null, "", `#${configHash(config)}`);
}

function setRadio(name, value) {
  const input = form.querySelector(`[name="${name}"][value="${value}"]`);
  if (input) input.checked = true;
}

function applyConfig(config) {
  const g = config?.geometry || {};
  const v = config?.viewer || {};
  setRadio("spacing", ["compact", "balanced", "cable_friendly"].includes(g.spacing) ? g.spacing : DEFAULTS.spacing);
  customSpacingEnabled = g.spacing === "custom";
  customSetbackControl.hidden = !customSpacingEnabled;
  customSpacingToggle.textContent = customSpacingEnabled ? "Use a named spacing" : "Use a custom setback";
  document.querySelector("#custom-setback").value = g.splitterSetbackMm ?? DEFAULTS.customSetback;
  setRadio("ethernetEntry", g.ethernetEntry ?? DEFAULTS.ethernetEntry);
  setRadio("frontPosition", g.frontKeystoneSide ?? DEFAULTS.frontPosition);
  setRadio("trayStyle", g.greenTrayStyle ?? DEFAULTS.trayStyle);
  setRadio("part", g.part ?? DEFAULTS.part);
  document.querySelector("#green-clearance").value = g.greenClearanceMmPerSide ?? DEFAULTS.greenClearance;
  document.querySelector("#green-interference").value = g.greenFrictionInterferenceMmPerSide ?? DEFAULTS.greenInterference;
  document.querySelector("#splitter-clearance").value = g.splitterClearanceMmPerSide ?? DEFAULTS.splitterClearance;
  document.querySelector("#splitter-interference").value = g.splitterFrictionInterferenceMmPerSide ?? DEFAULTS.splitterInterference;
  document.querySelector("#face-logo").checked = g.faceLogoEnabled ?? DEFAULTS.faceLogo;
  document.querySelector("#led-shutter").checked = g.ledShutterEnabled ?? DEFAULTS.ledShutter;
  document.querySelector("#show-green").checked = v.showGreen ?? DEFAULTS.showGreen;
  document.querySelector("#show-splitter").checked = v.showSplitter ?? DEFAULTS.showSplitter;
  document.querySelector("#show-cables").checked = v.showCables ?? DEFAULTS.showCables;
  document.querySelector("#show-leds").checked = v.simulateLeds ?? DEFAULTS.showLeds;
  document.querySelector("#auto-rotate").checked = v.autoRotate ?? DEFAULTS.autoRotate;
  updateSummary();
}

function resetDefaults() {
  applyConfig({
    geometry: {
      part: DEFAULTS.part,
      spacing: DEFAULTS.spacing,
      splitterSetbackMm: null,
      ethernetEntry: DEFAULTS.ethernetEntry,
      frontKeystoneSide: DEFAULTS.frontPosition,
      greenTrayStyle: DEFAULTS.trayStyle,
      greenClearanceMmPerSide: DEFAULTS.greenClearance,
      greenFrictionInterferenceMmPerSide: DEFAULTS.greenInterference,
      splitterClearanceMmPerSide: DEFAULTS.splitterClearance,
      splitterFrictionInterferenceMmPerSide: DEFAULTS.splitterInterference,
      faceLogoEnabled: DEFAULTS.faceLogo,
      ledShutterEnabled: DEFAULTS.ledShutter,
    },
    viewer: {
      showGreen: DEFAULTS.showGreen,
      showSplitter: DEFAULTS.showSplitter,
      showCables: DEFAULTS.showCables,
      simulateLeds: DEFAULTS.showLeds,
      autoRotate: DEFAULTS.autoRotate,
    },
  });
}

function downloadJson(filename, data) {
  const blob = new Blob([`${JSON.stringify(data, null, 2)}\n`], { type: "application/json" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = filename;
  link.click();
  setTimeout(() => URL.revokeObjectURL(link.href), 0);
}

function clearGeneratedDownloads() {
  for (const url of generatedUrls) URL.revokeObjectURL(url);
  generatedUrls = [];
  generatedSignature = "";
  meshDownloads.hidden = true;
  stlDownload.removeAttribute("href");
  threeMfDownload.removeAttribute("href");
}

function setGenerationStatus(state, progress, message, detail) {
  generationStatus.dataset.state = state;
  generationProgress.value = progress;
  generationMessage.textContent = message;
  generationDetail.textContent = detail;
}

function expectedGeometry(config) {
  const part = config.geometry.part;
  const mountDepth = Math.max(120, effectiveSetback(config) + 83.7);
  return {
    maxBounds: [[0, 0, 0], [254, 300, 43]],
    extent: [part === "one_piece" ? 254 : 220, part === "x2d_plate" ? null : mountDepth, 43],
    extentTolerance: 0.08,
    maxTriangles: 250000,
    componentCount: part === "x2d_plate" ? 3 : 1,
  };
}

function finishGeneration(data, config) {
  clearGeneratedDownloads();
  const stem = outputStem(config);
  const stlUrl = URL.createObjectURL(new Blob([data.stl], { type: "model/stl" }));
  const threeMfUrl = URL.createObjectURL(new Blob([data.threeMf], { type: "model/3mf" }));
  generatedUrls = [stlUrl, threeMfUrl];
  generatedSignature = JSON.stringify(scadParameters(config));
  stlDownload.href = stlUrl;
  stlDownload.download = `${stem}.stl`;
  threeMfDownload.href = threeMfUrl;
  threeMfDownload.download = `${stem}.3mf`;
  meshDownloads.hidden = false;
  const report = data.report;
  setGenerationStatus(
    "complete",
    5,
    "Validated downloads ready",
    `${data.backend} · ${(data.elapsedMs / 1000).toFixed(1)} s · ${report.triangleCount.toLocaleString()} triangles · ${report.componentCount} component${report.componentCount === 1 ? "" : "s"} · ${(report.volumeMm3 / 1000).toFixed(1)} cm³`,
  );
}

function cancelGeneration(message = "Generation cancelled") {
  if (meshWorker) meshWorker.terminate();
  meshWorker = null;
  generationRequestId += 1;
  generateButton.disabled = false;
  cancelButton.disabled = true;
  setGenerationStatus("idle", 0, message, "No geometry was changed or uploaded.");
}

async function startGeneration() {
  if (location.protocol === "file:") {
    setGenerationStatus(
      "error",
      0,
      "A static web server is required",
      "From the project folder run: python3 -m http.server 8000 — then open http://localhost:8000/customizer/",
    );
    return;
  }

  cancelGeneration("Preparing generator");
  clearGeneratedDownloads();
  const config = getConfig();
  const requestId = ++generationRequestId;
  const cacheKey = `${SOURCE_VERSION}:${GENERATOR_CACHE_VERSION}:${JSON.stringify(scadParameters(config))}`;
  generateButton.disabled = true;
  cancelButton.disabled = false;
  setGenerationStatus("running", 1, "Checking the local cache…", "Previously validated builds can be reused instantly.");
  const cached = await cachedArtifact(cacheKey);
  if (requestId !== generationRequestId) return;
  if (cached) {
    try {
      validateBinaryStl(new Uint8Array(cached.stl), expectedGeometry(config));
      generateButton.disabled = false;
      cancelButton.disabled = true;
      finishGeneration({ ...cached, backend: `${cached.backend} cache`, elapsedMs: 0 }, config);
      return;
    } catch {
      // Ignore stale or malformed cached output and regenerate it below.
    }
  }
  meshWorker = new Worker("mesh-worker.js", { type: "module" });
  setGenerationStatus("running", 1, "Starting OpenSCAD…", "The first run loads and initializes the 14 MB engine.");

  meshWorker.addEventListener("message", event => {
    if (event.data?.requestId && event.data.requestId !== requestId) return;
    if (event.data?.type === "progress") {
      const stages = { runtime: 1, source: 2, compile: 3, fallback: 3, validate: 4, package: 5 };
      setGenerationStatus(
        "running",
        stages[event.data.stage] || 1,
        event.data.message,
        event.data.backend ? `Backend: ${event.data.backend}` : "Everything remains local to this browser.",
      );
    } else if (event.data?.type === "complete") {
      meshWorker.terminate();
      meshWorker = null;
      generateButton.disabled = false;
      cancelButton.disabled = true;
      cacheArtifact(cacheKey, {
        backend: event.data.backend,
        stl: event.data.stl,
        threeMf: event.data.threeMf,
        report: event.data.report,
      });
      finishGeneration(event.data, config);
    } else if (event.data?.type === "error") {
      meshWorker.terminate();
      meshWorker = null;
      generateButton.disabled = false;
      cancelButton.disabled = true;
      setGenerationStatus("error", 0, "Generation failed", event.data.message);
    }
  });
  meshWorker.addEventListener("error", event => {
    if (meshWorker) meshWorker.terminate();
    meshWorker = null;
    generateButton.disabled = false;
    cancelButton.disabled = true;
    setGenerationStatus("error", 0, "Generator worker failed", event.message || "Unknown worker error");
  });
  meshWorker.postMessage({
    type: "generate",
    requestId,
    parameters: scadParameters(config),
    config,
    outputStem: outputStem(config),
    expected: expectedGeometry(config),
    sourceUrl: new URL("../ha_green_rack.scad", location.href).href,
    logoUrl: new URL("../assets/home-assistant-logo.svg", location.href).href,
  });
}

form.addEventListener("input", updateSummary);
form.addEventListener("change", updateSummary);
customSpacingToggle.addEventListener("click", () => {
  customSpacingEnabled = !customSpacingEnabled;
  customSetbackControl.hidden = !customSpacingEnabled;
  customSpacingToggle.textContent = customSpacingEnabled ? "Use a named spacing" : "Use a custom setback";
  updateSummary();
});
document.querySelector("#download-config").addEventListener("click", () => {
  const config = getConfig();
  downloadJson(`${outputStem(config)}.config.json`, config);
});
document.querySelector("#download-openscad").addEventListener("click", () => {
  const config = getConfig();
  downloadJson(`${outputStem(config)}.openscad-parameters.json`, openscadPreset(config));
});
document.querySelector("#copy-command").addEventListener("click", async event => {
  try {
    await navigator.clipboard.writeText(commandOutput.value);
    event.currentTarget.textContent = "Copied";
    setTimeout(() => { event.currentTarget.textContent = "Copy build command"; }, 1400);
  } catch {
    commandOutput.select();
  }
});
document.querySelector("#reset-defaults").addEventListener("click", resetDefaults);
generateButton.addEventListener("click", startGeneration);
cancelButton.addEventListener("click", () => cancelGeneration());

try {
  const config = configFromHash();
  if (config) applyConfig(config);
  else resetDefaults();
} catch {
  resetDefaults();
}
