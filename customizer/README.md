# Static browser customizer

This prototype generates validated STL and 3MF files entirely in the browser.
No geometry or configuration is uploaded to a server.

## Run it

Browser mesh generation requires HTTP(S) because it uses an ES-module Web
Worker. From the project root:

```sh
python3 -m http.server 8000
```

Then open <http://localhost:8000/customizer/>.

Opening `index.html` directly still supports configuration, URL sharing,
viewer handoff, JSON export, and OpenSCAD preset export, but browsers block the
mesh worker under `file://`.

## Implemented

- Guided Layout → Retention → Print design → Output choices
- Current production selection as the reset/default state
- Compatibility and physical-fit warnings
- Shareable configuration in the URL hash
- Configuration JSON and OpenSCAD parameter-set downloads
- Copyable desktop OpenSCAD command
- Embedded live 3D preview that follows the form, plus an optional full-viewer link
- Lazy-loaded OpenSCAD WebAssembly generation in a cancellable worker
- Fast Manifold attempt followed by a fresh CGAL fallback when validation fails
- Binary STL validation: finite vertices, distinct triangle vertices, closed
  edge incidence, consistent winding, positive component volume, component
  count, and configuration-aware bounds
- Deterministic geometry-only 3MF packaging with embedded configuration metadata

The first generation loads a 13.9 MB vendored runtime and may use roughly
230 MB of browser memory. The selected one-piece model currently falls back to
CGAL and takes roughly 35–50 seconds on this machine; small coupons often finish
with Manifold in under a second.

## Safety boundaries

The browser validates mesh topology and dimensions but cannot prove physical
fit, cable clearance, material shrinkage, or printer calibration. For the
top-clip option, print `exports/hybrid_clip_coupon.3mf`; it combines the selected
Green and TP-Link gauges in one low-material plate. Custom setback values and
comparison layouts remain test-fit choices.

## Runtime provenance

The local prototype vendors `openscad-wasm@0.0.4`, licensed GPL-2.0. See
`vendor/README.md` and `vendor/COPYING.openscad-wasm`. Its npm artifact lacks a
precise corresponding-source pointer, so self-build the official
`openscad/openscad-wasm` repository at a pinned commit before public hosting.

See `BROWSER_GENERATION.md` for completed architecture and remaining hardening.
