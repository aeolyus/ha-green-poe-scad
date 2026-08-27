# Vendored OpenSCAD WebAssembly runtime

`openscad.js` is `openscad-wasm@0.0.4` with one documented local optimization:
the compiled `WebAssembly.Module` promise is cached so a CGAL fallback can
instantiate a fresh OpenSCAD process without compiling the same 10.3 MB module
again. The geometry engine itself is unchanged.

- Package: <https://www.npmjs.com/package/openscad-wasm/v/0.0.4>
- Upstream source project: <https://github.com/openscad/openscad-wasm>
- Package integrity: `sha512-ChYe3cgL4JBstRVrR6XnhvF/4E9EsFR1kmGks7eTIT2awSMYVkoeYmFLt80h4V4J/DPIJw106MhIiIv6V9XpLA==`
- Original npm file SHA-256: `129a861c3acc1070ea88d8806fa3c1f286fc5a6cb96d9252fd6e4f27a88079ab`
- Locally patched file SHA-256: `ca715237605359222edf061c07e3cd5d85d1734fa96325101d8d587c1ad007bf`
- License declared by the package: GPL-2.0

The package embeds its WebAssembly payload directly in the JavaScript file.
`COPYING.openscad-wasm` contains the upstream GPLv2 license text. Before any
public distribution, confirm the corresponding-source and combined-work
licensing obligations for the exact npm artifact.
