# Publish with GitHub Pages

This repository is already arranged as a static site. No build service,
database, or server-side application is required.

1. Upload the contents of this folder to the `main` branch of
   `aeolyus/ha-green-poe-scad`.
2. In GitHub, open **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Select **main**, **/(root)**, and click **Save**.
5. After GitHub finishes deploying, open:
   <https://aeolyus.github.io/ha-green-poe-scad/>

The root page redirects to the combined customizer and live 3D viewer. All
paths are relative, so the project works under GitHub Pages' repository
subdirectory. Browser STL/3MF generation also runs entirely client-side.

After copying a fresh project build into the repository, run:

```bash
python3 scripts/prepare_static_site.py .
```

This replaces the offline viewer's embedded GLB data with relative file URLs
and regenerates `SITE_MANIFEST.json`, keeping the hosted HTML small while
preserving the standalone viewer in the source project.

## Before making the repository public

The project source is MIT licensed. The vendored OpenSCAD WebAssembly runtime
is GPL-2.0; its license and provenance notes are in `customizer/vendor/`.
Confirm the corresponding-source obligations described there before treating
the browser generator as a public distribution. The viewer and pre-generated
downloads do not require the WASM runtime.
