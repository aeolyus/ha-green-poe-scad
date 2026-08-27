# Home Assistant Green + TP-Link PoE Splitter — 10-inch 1U mount

GitHub Pages site: <https://aeolyus.github.io/ha-green-poe-scad/>

Designed for:

- DeskPi/GeeekPi RackMate T2 12U, 10-inch rack
- Home Assistant Green (official 112 × 112 × 32 mm envelope; measured tray-contact footprint 109.54 × 109.54 mm)
- TP-Link TL-PD30G-M2 2.5G PoE+ splitter (80.8 × 54 × 24 mm body)
- Bambu Lab X2D

The canonical printable edition is the final selected design: **rear cable entry, 60 mm cable-friendly splitter setback, an integrated Green friction tray with four raised support pads, a plain front with no logo, an open LED viewing aperture with no shutter or lens, visible LEDs, and no surrounding chassis**. The unqualified `core`, `one_piece`, and `x2d_plate` exports all use that combination.

Smooth continuous tray walls target a light 0.10 mm-per-side friction fit around the physically measured 109.54 mm lower footprint. A 3 mm lead-in chamfer opens to 0.50 mm-per-side clearance for insertion, and low front/rear stops resist sliding without localized ribs, tabs, or clips. Four broad lands centered on the factory mounting locations carry the Green at the normal 9.025 mm device height while the original 3 mm ventilated honeycomb floor remains low and open. The support and walls are fused into the mount; there is no separate sleeve or Green mounting hardware.

All device ports face the rear. The TP-Link splitter sits straight on the left with its POWER+DATA IN port toward the rack rear. Its cradle uses continuous side walls with a conservative 0.05 mm-per-side interference, a 3 mm lead-in chamfer, and four low corner stops that leave both connector centers open. Its LAN/DC outputs face the front internally, and both short jumpers route through the open lane between the two trays before reaching the Green's rear ports.

The front is solid, word-free, logo-free, and has no decorative vents. Its outside corners and exposed tray edges are rounded. Cooling remains open where it matters: the Green's top is unobstructed, the low 15 mm-pitch Green honeycomb ties the tray together below the four pads, and the narrower splitter shelf uses a 10 mm-pitch honeycomb inside its friction walls. The exposed triangular tray braces remain removed.

The 15 mm Green pattern is in the same visual scale as the linked UCG-Fiber rack mount and slightly finer than the larger cells visible on the linked USW-Lite-8 PoE enclosure. The TP-Link uses smaller cells because its clear shelf width is only about 42 mm; repeating the 15 mm grid there would leave too few load-sharing junctions.

The interactive viewer retains the front-Ethernet, alternate support, logo, shutter, other retention, and ventilated-enclosure studies for comparison. They are not the selected production edition. The ventilated 1U chassis remains viewer-only and is off by default.

## LED window

The production face uses a clean open aperture so the Green's LEDs remain directly visible. It has no lens, actuator slot, rear shutter pocket, retainer, or moving blade. The earlier translucent insert and captive shutter remain optional comparison parts.

The former captive-shutter mechanism remains only as a clearly named optional comparison export and as a viewer toggle. Likewise, the optional logo study is not cut into the canonical plain face.

## Cable routing and length check

The interactive preview includes three non-printing cable mockups:

- Incoming PoE patch lead from the rack rear to TP-Link POWER+DATA IN
- Internal Ethernet jumper from TP-Link LAN OUT to the Green
- DC jumper from TP-Link DC OUT to the Green

The production splitter setback is not determined by the incoming PoE lead. Its LAN/DC outputs face the front, so the open space in front of the body gives ordinary straight molded plugs room to exit and turn into the center lane. Moving the splitter forward makes the mount shallower, but it lengthens both internal jumpers and tightens their bend radius.

The updated mockups use a conservative 25 mm external straight-RJ45 boot envelope, Ubiquiti's published 21 mm minimum bend radius for its current patch cable, a 22 mm straight DC plug envelope, and rounded cable turns. These are precomputed static clearance routes—not an interactive physics simulation—and are planning envelopes rather than exact geometry for every cable Richard owns.

The webpage compares three rear-entry TP-Link placements, three front-Ethernet editions, and one SICSOLINK cable-routing mockup:

- **Compact, 35 mm setback:** the collision-aware orange mockups avoid passing through the panel, but require approximately 3.7 mm Ethernet and 7.6 mm DC bend radii; visual comparison only
- **Balanced, 47.5 mm setback:** DC clears at its full 10 mm radius; the orange Ethernet route clears only by tightening to about 16.2 mm instead of the 21 mm target, so it remains a slim-cable test fit
- **Cable-friendly, 60 mm setback:** current printable layout; separate cable lanes avoid the panel, devices, and each other while preserving the full 21 mm Ethernet and 10 mm DC bend radii
- **Front Ethernet — center gap, 60 mm setback:** the jack sits between the plain left face area and LED window while three layered cable paths preserve the modeled bend radii without increasing printed depth
- **Front Ethernet — HA right, 60 mm setback:** the jack sits physically to the right of the Green, while a full-radius PoE route loops behind the devices; this is a one-piece-only edition because the keystone occupies the detachable right-ear joint zone
- **Front Ethernet — left, 89 mm setback:** alternate jack in the left face area; the splitter moves 29 mm rearward so the straight PoE jumper can rise over it safely
- **SICSOLINK rear-angle:** viewer-only comparison using the existing splitter's seller-stated 180 mm captive leads; the visible routes consume about 165–170 mm and leave roughly 10–15 mm tolerance

The collision-aware internal Ethernet routes are approximately 370 mm across the three TP-Link positions before service slack. A 0.3 m / 1 ft lead is too short once ordinary straight plugs and real bends are included. Use a 0.5 m / roughly 20-inch patch lead. Ubiquiti's current line offers 0.4 m rather than 0.5 m; that leaves little service slack, while a 1 m lead can be looped at the cable-management points.

The corresponding straight-DC routes are approximately 250–275 mm before service slack. A 10-inch lead is too tight for the shallower comparisons; 12 inches / 300 mm is the safe general target and is the likely range of the bundled TP-Link jumper based on the unboxing, though TP-Link does not publish its length. A right-angle DC cable is not required because the RJ45 remains the limiting connector.

For the incoming PoE lead from an adjacent patch-panel coupler, start with a 1 ft cable. Use 0.5 m if the patch panel is more than roughly one rack unit away or if you want a service loop; that run depends on the actual rack-unit spacing and is not assigned an exact length by the viewer.

Each optional front-entry edition needs one additional internal Ethernet jumper from the rear of its feed-through keystone to TP-Link POWER+DATA IN. The modeled tip-to-tip lengths and practical cable choices are:

| Front jack location | Keystone → TP-Link route | Practical cable | Other internal leads |
| --- | ---: | --- | --- |
| Center gap | about 331 mm | 0.4 m minimum; 0.5 m preferred | TP-Link LAN → Green is about 356 mm, so use 0.5 m. DC is about 286 mm; 300 mm is possible but tight, and 350 mm is safer. |
| HA right | about 349 mm with the full 21 mm RJ45 bend | 0.4 m minimum; 0.5 m preferred | Uses the cable-friendly 60 mm splitter-to-Green lanes: use 0.5 m Ethernet and approximately 300–350 mm DC. |
| Left | about 266 mm | 0.4 m minimum; 0.5 m preferred | Use 0.5 m Ethernet and approximately 300 mm DC so ordinary straight plugs retain service slack. |

The center-gap cable envelope reaches about 213.6 mm rack depth; the left reaches about 218.3 mm, both within the T2's nominal 240 mm envelope. The HA-right route also remains within that envelope but deliberately makes a broad rear loop instead of forcing a tight turn. All three editions need a standard Cat6/6A female-to-female keystone coupler. Print `keystone_fit_test.stl` first because latch and body dimensions vary slightly between vendors.

For this rack, rear entry is the selected production layout: it keeps the front visually clean, uses one fewer coupler and internal cable, and gives simpler service access from the patch-panel side. Front entry remains useful as a comparison if you expect frequent troubleshooting or want to repatch without reaching behind the rack.

TP-Link lists a power cord in the box, and an independent unboxing clearly shows a male-to-male barrel jumper. TP-Link does not publish its exact length, barrel dimensions, or polarity. Try that supplied straight lead first. Before connecting the Green, set the selector to 12 V and verify both fit and center-positive polarity with a meter. If a replacement is needed, use a verified 12-inch straight-through lead whose Green end is 5.5 × 2.1 mm and whose current rating is at least 2 A.

Status: the generated geometry is manifold and dimensionally checked, but the final friction fit has not yet been physically test-printed. `assembly.stl` is a multi-body reference file rather than a print target. Print `friction_fit_coupon.stl` and `splitter_fit_coupon.stl` before committing to the full plate.

## Interactive preview

Open `viewer/interactive_viewer.html` in a web browser and choose the splitter, rear/front Ethernet entry, applicable spacing or front-jack position, retention, and optional protection. Those decisions map to the seven modeled layouts: Compact, Balanced, Cable-friendly, Front–center gap, Front–HA right, Front–left, and the angled SICSOLINK cable example. SICSOLINK is an advanced viewer-only study; choosing it disables the TP-Link-only controls without erasing their dormant selections. You can rotate, zoom, or jump between front, rear, top, perspective, retention-detail, and LED-window views. The page is fully self-contained, works offline, and records its selections in the URL hash so a configuration can be bookmarked or shared.

The default view matches the production choice: TP-Link, rear Ethernet, Cable-friendly spacing, raised-tray friction retention with **Four pads**, open trays with no chassis, no logo, no shutter hardware, visible simulated LEDs, and auto-rotation off. The comparison controls can still show the alternate supports, logo, captive shutter, front-entry layouts, other retention studies, and ventilated chassis. Those toggles do not change which files are canonical.

The **Green retention** controls compare the selected integrated friction tray with the earlier M3-screw baseline and six other screwless studies. The Four pads friction tray is the production geometry; the remaining retention choices are retained for inspection and historical comparison. Home Assistant publishes the enclosure envelope but not detailed lower-heatsink geometry, so print `friction_fit_coupon` and verify the real unit before committing to the full plate.

The support selector switches among three complete, mutually exclusive friction-tray meshes without reloading the GLB. **Four pads** is the selected production geometry: the low 3 mm honeycomb floor remains ventilated while four broad lands carry the Green. **Full honeycomb** raises the complete lattice and perimeter to the seating plane; **Open frame** replaces the floor with a perimeter, two transverse load paths, a center spine, and the same four lands. Every version includes the same fused friction walls and low stops, with the rear center open for ports and cable service.

The comparison models do not replace tolerance coupons, material-specific clearance tuning, or a physical pull/rattle test. The final Four pads geometry is printable but still needs that physical validation because this is a new design.

The **Optional protection** control compares the default open tray with a ventilated full-width 1U chassis. The chassis adds a removable perforated top-and-side cover plus a low guide frame, enclosing the complete assembly while keeping the rear open for cables. It costs more material and print time than the open tray and has only 0.975 mm nominal clearance above the Green, so it remains a fit-sensitive viewer study. The chassis control is disabled for the above-device captive-strap and X-cage concepts because those mechanisms consume the same 1U roof clearance. It is off in existing links unless `protection=airframe` is selected.

### Static browser customizer

`customizer/index.html` provides a guided static-site configurator with the
interactive 3D model embedded beside the controls. When served
over HTTP(S), it lazily loads a vendored OpenSCAD WebAssembly worker, generates
the selected geometry locally, validates the binary STL, and offers both STL
and deterministic geometry-only 3MF downloads. From this directory, run
`python3 -m http.server 8000`, then open
`http://localhost:8000/customizer/`. Configuration and preset export still
work when the HTML file is opened directly, but browsers block module workers
under `file://`. Review `customizer/vendor/README.md` before public distribution
of the experimental GPL-2.0 runtime.

The cable models use straight—not right-angle—RJ45 and DC plugs. Orange internal cables identify bend-radius violations; normal blue/black cables meet the modeled envelope. When visible, the window simulates the Green's steady white power light, irregular green activity, and a two-flash yellow heartbeat; timing is illustrative rather than a diagnostic code. Gold three-dimensional rulers use 10 mm ticks, and the page reports the exact 254 mm width, 43 mm height, and layout-specific printed depth. The viewer depicts the one-piece faceplate, so it has no detachable-ear joining bosses. Each of the seven layouts has two GLBs—shutter comparison and open-window/no-shutter—for 14 primary comparison models. Every GLB contains the standard tray, all three mutually exclusive raised-friction tray meshes, the other retention overlays, and its layout-specific optional airframe at the same normal Green/LED coordinates, so switching retention, support style, or protection does not reload or reposition the model. The no-shutter GLBs omit the insert and shutter meshes entirely, leaving the bare aperture. `viewer/home-assistant-green-rack-preview.glb` is the cable-friendly open-window alias; `viewer/home-assistant-green-rack-preview-no_shutter.glb` is retained for compatibility, and `viewer/home-assistant-green-rack-preview-with_shutter.glb` is explicit.

The colored Home Assistant Green, TP-Link splitter, connector faces, and cables in these preview files are dimensional mockups only and are not part of the printable plate.

The viewer is a hand-built HTML page using Google's open-source `<model-viewer>` web component (which uses Three.js internally). The colored GLB was assembled from the OpenSCAD exports with Python and `trimesh`, then embedded directly in the HTML so no web server or internet connection is required.

## Parts

- `core.stl` — canonical split-core mount: rear entry, Four pads friction tray, plain face, and open LED aperture
- `one_piece.stl` / `.3mf` — the same canonical mount as one 254 mm-wide part, without detachable ears or rear joining bosses
- `x2d_plate.stl` / `.3mf` — canonical split core and both ears nested for the X2D dual-nozzle area
- `left_ear.stl` / `right_ear.stl` — detachable rack ears for `core.stl`
- `led_insert_optional.stl` and `led_fixed_window_kit_optional.stl` / `.3mf` — optional self-retaining translucent insert comparison
- `friction_fit_coupon.stl` / `.3mf` — follow-up smooth-wall channels at 0.25, 0.30, and 0.35 mm interference per side. The original three-hole 0.20 mm/side coupon was a near-perfect clearance fit but did not grip, so test these in order and use the first one that holds without scuffing.
- `splitter_fit_coupon.stl` / `.3mf` — three short open-ended smooth-wall test channels at 0.00, 0.05, and 0.10 mm interference per side for the TP-Link body; use the least aggressive level that holds before committing to its full-length friction cradle
- `assembly.stl` — reference assembly only; print the separate parts above
- `fit_test.stl` / `.3mf` — general device-clearance check

Clearly named optional exports:

- `*_legacy_screw_tray.*` and `green_spacer*_legacy_screw_tray.*` — prior four-screw Green tray fallback
- `core_with_logo.*`, `one_piece_with_logo.*`, `x2d_plate_with_logo.*`, `logo_inlay_optional.stl`, and `one_piece_logo_inlay_optional.stl` — optional branded-face study; the inlay only fits a matching `_with_logo` mount
- `core_with_shutter.*`, `one_piece_with_shutter.*`, `x2d_plate_with_shutter.*`, and `led_shutter_*_optional.*` — optional captive-shutter study
- `*_front_ethernet_right.*`, `*_front_ethernet_left.*`, and `one_piece_front_ethernet_far_right.*` — optional front-entry comparisons, all otherwise inheriting the final Four pads/plain-face/open-aperture defaults
- `keystone_fit_test.stl` / `.3mf` — front-keystone latch coupon
- The HA-right front-entry comparison is one-piece-only because its keystone occupies the detachable right-ear joint zone

Viewer and render artifacts:

- `renders/assembly_preview.png` — layout preview with translucent device mockups
- `viewer/home-assistant-green-rack-compact.glb` — 35 mm setback comparison mockup
- `viewer/home-assistant-green-rack-balanced.glb` — 47.5 mm setback comparison mockup
- `viewer/home-assistant-green-rack-cable_friendly-no_shutter.glb` — GLB used by the production-default viewer state
- `viewer/home-assistant-green-rack-front_ethernet_right.glb`, `viewer/home-assistant-green-rack-front_ethernet_far_right.glb`, and `viewer/home-assistant-green-rack-front_ethernet_left.glb` — center-gap, HA-right, and left front-keystone mockups with their internal cabling
- Every viewer layout has both a shutter comparison GLB and a paired `-no_shutter.glb` bare-aperture GLB with no lens mesh
- `viewer/home-assistant-green-rack-front_ethernet.glb` and its no-shutter counterpart are compatibility aliases of the center-gap GLBs
- `viewer/home-assistant-green-rack-sics_angled.glb` — viewer-only angled SICSOLINK mockup showing its captive cable routing
- `viewer/viewer_green_tray_friction_full.stl`, `viewer/viewer_green_tray_friction_pads.stl`, and `viewer/viewer_green_tray_friction_skeletal.stl` — mutually exclusive complete friction-tray meshes for Full honeycomb, Four pads, and Open frame support; each includes the fused walls and stops
- `viewer/variants/*/viewer_enclosure_airframe.stl` — viewer-only ventilated 1U chassis study; it is not part of the printable production files

The canonical core is approximately 220 × 144 mm. The one-piece faceplate is 254 mm wide and nominally fits the X2D's 256 mm main-nozzle area with only 1 mm per side; center it carefully and do not use a brim. It does not fit the 235.5 mm dual-nozzle overlap area, so `x2d_plate` remains the lower-risk fallback. The printed tray and modeled cable exits stay within the RackMate T2's approximately 240 mm internal depth.

## Hardware

- 4 × M3 × 8 mm screws for attaching the ears to the center section (preferred; M3 × 10 mm can work but leaves less front skin)
- 4 × #10-32 × 5/16 rack screws supplied with the RackMate T2
- Optional small zip ties for the short internal DC/LAN cable-management slots only; there are no Green-device zip-tie slots
- Any front-entry edition: 1 × Cat6/6A female-to-female keystone coupler and 1 × 0.5 m internal Ethernet patch cable

The Green needs no mounting screws in the selected friction tray; leave its factory bottom screws untouched. The M3 × 8 screws enter from the rear and only join the optional printed ears to the printed center. They self-tap into 2.6 mm pilot holes, so do not overtighten. They and the rear joining bosses are absent from `one_piece.stl`. The T2's pre-threaded rack rails officially use #10-32 screws, not M6 cage-nut hardware.

## Suggested print settings

- Material: white PETG (preferred) or ASA
- Layer height: 0.20 mm
- Walls: 4
- Top/bottom shells: 5
- Infill: 25–30% gyroid
- Supports: none for the core; use build-plate-only support beneath the two rear tongues on each ear
- Print `core.stl` tray-side down
- Print `one_piece.stl` tray-side down with the main nozzle only, centered and without a brim; use the split plate if Bambu Studio rejects the 1 mm side margins
- The same orientation applies to optional comparison mounts and the HA-right one-piece file
- Ear and LED-insert STLs are already exported face-side down; enable support for the ear tongues

The supplied 3MF is geometry-only, not a pre-sliced Bambu project. In Bambu Studio, split it into objects and use normal/snug build-plate-only support on the ears rather than broad tree supports. A brim is normally unnecessary; a wide brim may join the nested pieces.

The production LED window is intentionally left open, so there is no lens, shutter blade, or retainer to print or assemble. The optional translucent insert can still be generated for comparison if dust protection is preferred later.

Print `friction_fit_coupon.stl` first. Its one-, two-, and three-hole channels are now 0.25, 0.30, and 0.35 mm interference per side; use the first one that holds the actual Green without scuffing it. The enclosure narrows toward the top, so the physically measured 109.54 mm bottom footprint remains the controlling tray dimension. Then print `splitter_fit_coupon.stl` and select the least aggressive channel that securely holds the TP-Link body. Printer calibration, material, and long-term PETG relaxation all affect these fits.

## Electrical safety

Home Assistant Green requires 12 V DC, 1 A, center-positive through a 5.5 × 2.1 mm barrel connector. The TP-Link provides selectable 12/9/5 V at up to 2 A and must be set to 12 V before any cable is connected. TP-Link does not publish the included cord's barrel dimensions or polarity, so verify center-positive output before connecting it to the Green; reverse polarity or the wrong selector setting can damage the Green.

## Purchase list and observed price

- [TP-Link TL-PD30G-M2](https://www.amazon.com/dp/B0F4CR925P) — $19.99 observed on 2026-08-25; includes the power cord
- Existing 0.5 m / roughly 20-inch UniFi or Monoprice patch cable for TP-Link LAN OUT → Green; 1 ft is too short with ordinary straight plugs
- Existing 1 ft patch cable for an adjacent PoE patch-panel coupler → TP-Link POWER+DATA IN; use 0.5 m for a larger RU separation or service loop
- 4 × M3 × 8 mm screws for the printed ears, if not already on hand

For the recommended rear-entry edition, no extra keystone coupler is required when the existing patch panel already has PoE-capable feed-through couplers. With existing patch cables and RackMate screws, the new electrical hardware total is $19.99 plus tax. Any optional front-entry edition adds the price of one female-to-female keystone and a 0.5 m internal jumper. A separate PoE injector is not needed when the source is already a standards-compliant PoE/PoE+ switch port.

## Source and export

The parametric source is `ha_green_rack.scad`. Example exports:

```sh
# Canonical production geometry inherits the source defaults.
openscad -o exports/core.stl -D 'part="core"' ha_green_rack.scad
openscad -o exports/one_piece.stl -D 'part="one_piece"' ha_green_rack.scad
openscad -o exports/x2d_plate.stl -D 'part="x2d_plate"' ha_green_rack.scad
openscad -o exports/led_insert_optional.stl -D 'part="led_insert"' -D 'led_window_insert_enabled=true' ha_green_rack.scad
openscad -o exports/friction_fit_coupon.stl -D 'part="friction_fit_coupon"' ha_green_rack.scad
openscad -o exports/splitter_fit_coupon.stl -D 'part="splitter_fit_coupon"' ha_green_rack.scad

# Clearly named optional comparisons.
openscad -o exports/one_piece_legacy_screw_tray.stl -D 'part="one_piece"' -D 'green_tray_style="standard"' ha_green_rack.scad
openscad -o exports/one_piece_with_logo.stl -D 'part="one_piece"' -D 'face_logo_enabled=true' ha_green_rack.scad
openscad -o exports/one_piece_logo_inlay_optional.stl -D 'part="one_piece_logo_inlay"' -D 'face_logo_enabled=true' ha_green_rack.scad
openscad -o exports/one_piece_with_shutter.stl -D 'part="one_piece"' -D 'led_shutter_enabled=true' ha_green_rack.scad
openscad -o exports/led_shutter_kit_optional.stl -D 'part="led_shutter_kit"' -D 'led_shutter_enabled=true' ha_green_rack.scad

# Optional front-entry comparison; all unspecified choices remain production defaults.
openscad -o exports/one_piece_front_ethernet_right.stl -D 'part="one_piece"' -D 'front_ethernet_enabled=true' -D 'front_keystone_side="right"' -D 'splitter_y_override=60' ha_green_rack.scad
openscad -o exports/one_piece_front_ethernet_far_right.stl -D 'part="one_piece"' -D 'front_ethernet_enabled=true' -D 'front_keystone_side="far_right"' -D 'splitter_y_override=60' ha_green_rack.scad
openscad -o exports/keystone_fit_test.stl -D 'part="keystone_fit_test"' ha_green_rack.scad
```

To regenerate the canonical production files, named comparison exports, PNGs, GLBs, and embedded offline viewer in one pass, run `bash scripts/build.sh full` in an environment containing OpenSCAD, Python, NumPy, and trimesh. One Nix invocation is:

```sh
nix shell --impure --expr 'with import <nixpkgs> {}; buildEnv { name = "ha-rack-build"; paths = [ openscad-unstable (python3.withPackages (ps: [ps.trimesh ps.numpy])) ]; }' -c env OPENSCAD_BIN=openscad-unstable bash scripts/build.sh full
```

STL builds try OpenSCAD's Manifold backend first and validate the binary STL
before replacing an existing artifact. A failed export, open edge, over-shared
edge, or inconsistent winding automatically retries with CGAL. 3MF and PNG
exports keep OpenSCAD's normal rendering behavior and are also replaced
atomically. Build logs show the selected backend, elapsed time, and fallback
reason. Set `OPENSCAD_BIN` to use a different OpenSCAD executable; older builds
without backend selection run through their normal CGAL path.

For faster iteration, use the incremental wrapper after at least one full build:

```sh
# HTML/JavaScript or option-copy changes only; no OpenSCAD, NumPy, or trimesh.
bash scripts/build.sh html

# Repack existing STL geometry into GLBs and refresh the HTML.
bash scripts/build.sh glb

# Rebuild one layout's viewer geometry, both shutter states, GLBs, and HTML.
bash scripts/build.sh viewer cable_friendly

# Rebuild every layout after changing shared per-layout viewer geometry such as the optional airframe.
bash scripts/build.sh viewer

# Rebuild one shared retention concept, then refresh all viewer GLBs.
bash scripts/build.sh retention slide_latch

# Rebuild canonical production files plus clearly named comparisons.
bash scripts/build.sh full
```

`viewer` and `glb` accept multiple variant names; omit them to rebuild every comparison layout. `glb` repacks both shutter states for each selected layout. `retention friction_sleeve` rebuilds all three shared friction support styles plus the Full honeycomb compatibility mesh, then refreshes the viewer GLBs. OpenSCAD viewer jobs run four at a time by default, adjustable with `VIEWER_BUILD_JOBS`. Partial outputs are written to temporary files and moved into place only after a successful build.

## Licensing and attribution

Original project code and independently modeled geometry are offered under MIT. The self-contained viewer embeds upstream components under their own licenses: Google `model-viewer` (Apache-2.0), Three.js (MIT), and Lit (BSD-3-Clause).

The M3 hole pattern and spacer dimensions were independently reimplemented from published measurements in [mikkelgj's editable Printables reference](https://www.printables.com/model/1752618-home-assistant-green-10-1u-rackmount-with-keystone), which is offered under CC BY-SA; no mesh or source body is bundled here. The X-cage comparison is an independent photo-based study inspired by [Andsten's MakerWorld 590818 model](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398), listed as `BY-NC`; no original mesh is copied. The friction-sleeve comparison was reconstructed from public product images and descriptions for [Etsy 4430188404](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount); no seller CAD or mesh was available or redistributed.

## Dimensional references and alternatives

- [Screwless-retention research and coupon plan](screwless-retention-research.md)
- [Home Assistant Green datasheet](https://github.com/NabuCasa/support/raw/refs/heads/main/static/docs/green/Green_v2.0_Datasheet.pdf)
- [Bambu Lab X2D specifications](https://bambulab.com/en/x2d/specs)
- [Ubiquiti UniFi Patch Cable specifications](https://store.ui.com/us/en/category/accessories-cables-dacs/collections/accessories-pro-patch-cables/products/uacc-cable-patch) — source for the modeled 21 mm minimum bend radius; the 25 mm boot projection remains a conservative planning assumption
- [Official DeskPi RackMate printable models and mechanical drawings](https://github.com/DeskPi-Team/3DPrint-Models)
- [Home Assistant Green 10-inch 1U mount with editable STEP/Fusion source](https://www.printables.com/model/1752618-home-assistant-green-10-1u-rackmount-with-keystone) — a good proven-looking alternative, but it does not include this PoE splitter cradle
- [MakerWorld 10-inch Home Assistant Green mount](https://makerworld.com/en/models/1974297-10-inch-rack-mount-for-home-assistant-green#profileId-2123231) — visual reference requested for the icon badge
- [TP-Link TL-PD30G-M2 official specifications](https://www.tp-link.com/us/business-networking/soho-accessory/tl-pd30g-m2/)
- [Simple Icons: Home Assistant](https://simpleicons.org/?q=homeassistant) — SVG geometry used for the badge; Home Assistant is a trademark of Nabu Casa

This model is an independent parametric design. The references above were used to cross-check device envelopes, rack slots, cooling access, and printer fit.
