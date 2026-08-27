# Browser STL/3MF generation plan

## Goal

Turn the current zero-build static form into a static-hosted configurator that can generate a checked STL or 3MF without sending the design or settings to a server.

## Recommended architecture

1. **Configuration UI**
   - Keep this form as the only source of user input.
   - Validate every value against an allowlist and tight numeric bounds.
   - Serialize a versioned configuration and stable hash for sharing and caching.

2. **Geometry worker**
   - Run OpenSCAD compiled to WebAssembly inside a Web Worker so rendering cannot freeze the UI.
   - Mount a pinned copy of `ha_green_rack.scad` in the worker's virtual filesystem.
   - Pass the generated parameter-set JSON to OpenSCAD rather than constructing source code from user text.
   - Start with the small controlled choice set in this prototype. Do not expose arbitrary SCAD expressions.

3. **Validation worker**
   - Parse the STL before enabling download.
   - Require finite coordinates, nonzero triangles, expected bounding-box limits, and closed two-manifold edges.
   - Report the checks in plain language next to the download button.
   - Consider a pinned Manifold WASM build for validation/repair, but reject unexpected repairs instead of silently changing geometry.

4. **Artifact packaging**
   - Offer binary STL immediately after validation.
   - Package 3MF client-side as a standards-compliant ZIP container with model units, object names, and configuration metadata.
   - Keep slicer profiles out of the first release; a geometry-only 3MF is more portable and less likely to imply printer settings were validated.

5. **Caching and responsiveness**
   - Cache successful artifacts in IndexedDB by `source-version + normalized-parameters + output-format`.
   - Debounce edits, but compile only after an explicit Generate action.
   - Show separate queued, compiling, validating, and ready states with elapsed time and a cancel button.
   - Keep the existing prebuilt GLB viewer for instant feedback while the exact mesh compiles.

## Static hosting constraints

- Bundle and pin all JavaScript/WASM assets; avoid runtime CDN dependencies.
- A single-threaded WASM build works on ordinary static hosting. A faster threaded build may require `Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy` response headers, which some static hosts cannot configure.
- The OpenSCAD WASM distribution is large. Lazy-load it only after Generate is pressed and show the download size before fetching.
- Review the exact WASM package's license and source-distribution obligations before publishing. Do not assume an npm package's licensing is compatible merely because the original SCAD project is MIT.

## Delivery status

### Phase 1 — complete

- Guided choices
- URL/config sharing
- OpenSCAD preset and CLI export
- Existing viewer handoff

### Phase 2 — prototype complete

- Vendored OpenSCAD WASM worker
- Progress/cancel behavior
- Binary STL download
- Geometry validation and cache

The worker, validation, STL download, and source-versioned IndexedDB cache are
implemented. Changing the pinned source hash invalidates old cached artifacts.

### Phase 3 — 3MF complete; reusable schemas pending

- Dependency-free deterministic geometry-only 3MF writer
- Device/rack schema separated from this specific model
- Imported community device profiles with provenance and dimensional confidence
- Optional deploy-time pre-generation of popular configurations

## Acceptance checks before public use

- Every UI state maps to an explicit, versioned parameter set.
- Default browser output is byte-stable for the same source/runtime/parameters.
- Browser output matches the desktop production export within a documented mesh tolerance.
- Invalid and incompatible combinations cannot start a build.
- Generated STL passes closed-manifold and bounds checks.
- Generated 3MF opens in Bambu Studio, PrusaSlicer, and OrcaSlicer.
- Cancellation releases worker memory, and repeated builds do not grow memory without bound.
