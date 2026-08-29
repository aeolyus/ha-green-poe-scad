# Home Assistant Green + TP-Link PoE Splitter — 10-inch 1U mount

GitHub Pages site: <https://aeolyus.github.io/ha-green-poe-scad/>

Designed for:

- DeskPi/GeeekPi RackMate T2 12U, 10-inch rack
- Home Assistant Green (official 112 × 112 × 32 mm nominal envelope; physical unit measured 111.13 mm across the bottom, 107.95 mm across the top plateau, and 33.34 mm tall)
- TP-Link TL-PD30G-M2 2.5G PoE+ splitter (80.8 mm published overall length; the revised physical measurements are a 67.47 × 48.42 mm top plateau, 53.98 mm maximum width, 24.61 mm total height, and an 18.26 mm straight side band)
- Bambu Lab X2D

The physically validated release candidate is **rear cable entry, 60 mm cable-friendly splitter setback, rounded vent-frame friction cages, a plain front with no logo, an open LED viewing aperture with no shutter or lens, and no surrounding chassis or dovetail gate**. Use the explicitly named `*_vent_frame_no_dovetail` files for this version. The older unqualified `core`, `one_piece`, and `x2d_plate` exports retain the direct-friction-tray baseline for comparison.

Smooth continuous tray walls target a light 0.10 mm-per-side friction fit around the physically measured 111.13 mm lower footprint, then follow the measured inward taper beginning 6.35 mm above the bottom and ending at the 107.95 mm top plateau. Low front/rear stops resist sliding without localized ribs, tabs, or clips. The original 3 mm ventilated honeycomb is translated upward so its top is the normal 9.025 mm device seating plane; the open space below replaces the former four riser columns without filling the tray solid. Annular lands preserve the optional factory screw-hole locations. The Green floor, TP-Link floor, and connecting bridge all share this height, and everything remains fused into the mount. Two hollow 8 mm-high box beams now replace the earlier one-sided L-flanges between the cages. A constant hollow center spine carries the TP-Link load back to the faceplate without permanent triangular print supports. A matching 12 mm-wide upper tie joins the center of the splitter cage roof to the faceplate, creating a deep frame that resists sag and twist while remaining below the 1U outline and clear of the modeled cable paths. Any desired support beneath the splitter cage can instead be generated and removed by the slicer.

All device ports face the rear. The TP-Link splitter sits straight on the left with its POWER+DATA IN port toward the rack rear. Its cradle follows the enclosure's symmetric 2.78 mm top and bottom bevel traversals, maintains a conservative 0.05 mm-per-side fit through the profile, and uses four low corner stops that leave both connector centers open. Its LAN/DC outputs face the front internally, and both short jumpers route through the open lane between the two trays before reaching the Green's rear ports.

The front is solid, word-free, logo-free, and has no decorative vents. Its outside corners and exposed tray edges are rounded. Cooling remains open where it matters: the Green's top is unobstructed, the raised 15 mm-pitch Green honeycomb supports it directly, and the narrower splitter shelf uses a 10 mm-pitch honeycomb inside its friction walls. The exposed triangular tray braces remain removed.

The 15 mm Green pattern is in the same visual scale as the linked UCG-Fiber rack mount and slightly finer than the larger cells visible on the linked USW-Lite-8 PoE enclosure. The TP-Link uses smaller cells because its clear shelf width is only about 42 mm; repeating the 15 mm grid there would leave too few load-sharing junctions.

The interactive viewer retains the front-Ethernet, alternate support, logo, shutter, other retention, and ventilated-enclosure studies for comparison. They are not the selected production edition. The ventilated 1U chassis remains viewer-only and is off by default.

## LED window

The production face uses a clean open aperture so the Green's LEDs remain directly visible. It has no lens, actuator slot, rear shutter pocket, retainer, or moving blade. The 8 mm-high aperture is centered on the physically measured illuminated band: 3.175 mm (4/32 in) above the Green's bottom and 19.05 mm (3/4 in) below its top. Its horizontal center now follows the measured 111.125 mm enclosure body rather than the older clearance envelope. The earlier translucent insert and captive shutter remain optional comparison parts.

The former captive-shutter mechanism remains only as a clearly named optional comparison export and as a viewer toggle. Likewise, the optional logo study is not cut into the canonical plain face.

## Cable routing and length check

The interactive preview includes three non-printing cable mockups:

- Incoming PoE patch lead from the rack rear to TP-Link POWER+DATA IN
- Internal Ethernet jumper from TP-Link LAN OUT to the Green
- DC jumper from TP-Link DC OUT to the Green

The production splitter setback is not determined by the incoming PoE lead. Its LAN/DC outputs face the front, so the open space in front of the body gives ordinary straight molded plugs room to exit and turn into the center lane. Moving the splitter forward makes the mount shallower, but it lengthens both internal jumpers and tightens their bend radius.

The updated mockups use a conservative 25 mm external straight-RJ45 boot envelope, Ubiquiti's published 21 mm minimum bend radius for its current patch cable, a 22 mm straight DC plug envelope, and rounded cable turns. These are precomputed static clearance routes—not an interactive physics simulation—and are planning envelopes rather than exact geometry for every cable Richard owns.

The webpage compares three side-by-side rear-entry TP-Link placements, one centered-stacked TP-Link study, three front-Ethernet editions, and one SICSOLINK cable-routing mockup:

- **Compact, 35 mm setback:** 32 mm / 1.26 in from the panel's inside face to the splitter, leaving about 7 mm / 0.28 in after the modeled 25 mm boot; the collision-aware orange mockups require approximately 3.7 mm Ethernet and 7.6 mm DC bend radii, so this remains a visual comparison
- **Balanced, 47.5 mm setback:** 44.5 mm / 1.75 in of inside clearance, leaving about 19.5 mm / 0.77 in after the modeled boot; Richard's actual flexible cable was comfortable at this spacing, although the conservative generic Ethernet mockup remains orange because it targets a larger 21 mm bend radius
- **Cable-friendly, 60 mm setback:** current printable layout; 57 mm / 2.24 in of inside clearance leaves about 32 mm / 1.26 in after the modeled boot, and separate cable lanes preserve the full 21 mm Ethernet and 10 mm DC bend radii
- **Centered stacked:** viewer-only study with the Green centered on the panel and the TP-Link rotated 90° directly behind it; both sit on the 9.025 mm unified deck, the printed depth is 202.4 mm / 7.97 in, and the side-facing LAN port permits a full-radius R21 turn to the Green
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

Status: both rounded-cage device fits are physically validated as snug. The final no-dovetail one-piece and split-plate exports are closed two-manifold meshes; the complete print still needs the normal first-article rack, cable, and removal checks. `assembly.stl` remains a multi-body reference file rather than a print target. The optional dovetail gate remains coupon-gated and is not included in the release candidate.

## Interactive preview

Open `viewer/interactive_viewer.html` through the included static-site layout and choose the splitter, side-by-side or centered-stacked arrangement, rear/front Ethernet entry, applicable spacing or front-jack position, retention, and optional protection. Those decisions map to eight modeled layouts: Compact, Balanced, Cable-friendly, Centered stacked, Front–center gap, Front–HA right, Front–left, and the angled SICSOLINK cable example. Centered stacked and SICSOLINK are viewer-only studies. You can rotate, zoom, or jump between front, rear, top, perspective, retention-detail, and LED-window views. The hosted copy loads sibling GLBs to keep the initial HTML near 1 MB; `scripts/build.sh html` can regenerate an embedded single-file offline copy. Both forms record selections in the URL hash so a configuration can be bookmarked or shared.

The default view matches the production choice: TP-Link, rear Ethernet, Cable-friendly spacing, tray friction retention with **Unified raised deck**, open trays with no chassis, no logo, no shutter hardware, visible simulated LEDs, and auto-rotation off. The comparison controls can still show the alternate supports, logo, captive shutter, front-entry layouts, other retention studies, and ventilated chassis. Those toggles do not change which files are canonical.

The **Retention** controls compare the selected integrated friction tray with the earlier M3-screw baseline and other studies. **Hybrid top clips · Green + PoE** keeps the Green's fixed/releasable catch arrangement, while the TP-Link now uses four mirrored rigid catches grown directly from continuous mini walls with no relief cuts or spring tongues. **Rounded vent-frame cages · Green + PoE** is the current aesthetic prototype preference: a rear-loading design inspired by the UCG-Fiber, USW-Lite, and Mauker Chromebox enclosure patterns, with honeycomb floors and 1.6 mm roofs meeting thick rounded side frames around one long capsule vent beside each device. The front stops remain and the rear stays open for insertion and cabling. Both cages keep one snug profile from front to rear, with square rear seams so their roofs, floors, and walls finish flush. Physical coupons now validate a snug fit for both devices: the Green uses 0.30 mm side and 0.10 mm roof clearance, while the TP-Link uses its proven 0.10 mm side and 0.05 mm roof clearance. The Green roof finishes at 44.0625 mm—0.3875 mm below the exact 44.45 mm panel top. **Vent-frame cages + padless dovetail gates** adds separately printed optional rear H-gates while retaining the same friction-fit cages as the primary retention. Their straight vertical tracks are buried inside locally thickened rear sidewall ends, and each H-frame seats in a matching shallow pocket so its rear face finishes flush with the cage. One smooth beveled lower beam replaces the former individual pads and sits 0.05 mm behind the device's solid lower rear face. A thin 0.8 mm stepped cap covers the gate pocket and beam-travel opening from above, leaving only a 0.02 mm separation so the roof reads as continuous while the gate remains a separate printable part. The central connector field remains open. The final 7 mm of rail travel wedges to a nominal line fit so the gate does not lift freely. Disconnect rear cables before sliding a gate. The gates need approximately 38 mm above the Green and 25 mm above the TP-Link during installation/removal, so service them before mounting another rack unit immediately above. The complete dovetail-ready one-piece mount and a separate two-gate plate are exported, but the gate sliding fit remains coupon-gated and physically unvalidated. The rounded cage dimensions themselves are already physically validated.

The support selector switches among four complete, mutually exclusive friction-tray meshes without reloading the GLB. **Unified raised deck** is selected: it lifts the original thin 3 mm honeycomb directly to the seating plane and leaves the volume below open. **Four pads** retains the earlier low floor and four raised lands; **Full honeycomb** fills the complete lattice and perimeter up to the seating plane; **Open frame** replaces the floor with a perimeter, two transverse load paths, a center spine, and four lands. Every version includes the same fused friction walls and low stops, with the rear center open for ports and cable service.

The comparison models do not replace tolerance coupons, material-specific clearance tuning, or a physical pull/rattle test. The unified raised-deck geometry is printable but still needs that physical validation because this is a new design.

The **Optional protection** control compares the default open tray with a ventilated full-width 1U chassis. The chassis adds a removable perforated top-and-side cover plus a low guide frame, enclosing the complete assembly while keeping the rear open for cables. With the exact 44.45 mm panel height, its 0.8 mm roof underside retains 1.0875 mm nominal clearance over the measured Green. It remains viewer-only until the enclosure assembly and cable access are physically validated. The chassis control is disabled for the above-device captive-strap, X-cage, and ventilated-sleeve concepts because those mechanisms consume the same roof space. It is off in existing links unless `protection=airframe` is selected.

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

The cable models use straight—not right-angle—RJ45 and DC plugs. Orange internal cables identify bend-radius violations; normal blue/black cables meet the modeled envelope. When visible, the window simulates the Green's steady white power light, irregular green activity, and a two-flash yellow heartbeat; timing is illustrative rather than a diagnostic code. Gold three-dimensional rulers use 10 mm ticks, and a compact viewport overlay labels the exact 254 mm panel width, exact 44.45 mm / 1.750 in panel height, layout-specific printed depth, and panel-to-splitter clearance in both millimeters and inches. The viewer depicts the one-piece faceplate, so it has no detachable-ear joining bosses. Each of the eight layouts has two GLBs—shutter comparison and open-window/no-shutter—for 16 primary comparison models. Every applicable GLB contains the standard tray, all four mutually exclusive friction-tray meshes, the other retention overlays, and its layout-specific optional airframe at the same normal Green/LED coordinates, so switching retention, support style, or protection does not reload or reposition the model. The side-by-side TP-Link layouts include the dovetail prototype; the incompatible centered-stacked and SICSOLINK layouts disable it. The no-shutter GLBs omit the insert and shutter meshes entirely, leaving the bare aperture. `viewer/home-assistant-green-rack-preview.glb` is the cable-friendly open-window alias; `viewer/home-assistant-green-rack-preview-no_shutter.glb` is retained for compatibility, and `viewer/home-assistant-green-rack-preview-with_shutter.glb` is explicit.

The colored Home Assistant Green, TP-Link splitter, connector faces, and cables in these preview files are dimensional mockups only and are not part of the printable plate.

The viewer is a hand-built HTML page using Google's open-source `<model-viewer>` web component (which uses Three.js internally). Python and `trimesh` assemble the colored GLBs from OpenSCAD exports. The local offline build can embed those GLBs directly; `scripts/prepare_static_site.py` rewrites them to relative URLs for faster GitHub Pages loading.

## Parts

- `one_piece_rear_cable_friendly_vent_frame_no_dovetail.stl` / `.3mf` — selected complete print: one integrated 254 mm-wide mount, already faceplate-down, with the physically validated rounded Green and TP-Link cages and no dovetail hardware
- `one_piece_rear_cable_friendly_vent_frame_dovetail_ready.stl` / `.3mf` — one-piece 254 mm-wide mount with the same friction cages plus integrated rear dovetail receivers; the devices remain friction-retained when no gates are installed
- `dovetail_gates_optional_plate.stl` / `.3mf` — optional second print containing the Green and TP-Link rear gates, both already resting on their broad rear faces
- `x2d_plate_rear_cable_friendly_vent_frame_no_dovetail.stl` / `.3mf` — safer split alternative containing the vent-frame core and both detachable ears as three faceplate-down objects
- `core.stl` — canonical split-core mount: rear entry, unified raised friction deck, plain face, and open LED aperture
- `one_piece.stl` / `.3mf` — the same canonical mount as one 254 mm-wide part, without detachable ears or rear joining bosses
- `x2d_plate.stl` / `.3mf` — canonical split core and both ears nested for the X2D dual-nozzle area
- `left_ear.stl` / `right_ear.stl` — detachable rack ears for `core.stl`
- `led_insert_optional.stl` and `led_fixed_window_kit_optional.stl` / `.3mf` — optional self-retaining translucent insert comparison
- `friction_fit_coupon.stl` / `.3mf` — regenerated smooth-wall channels at 0.25, 0.30, and 0.35 mm interference per side around the newly measured 111.125 mm bottom. The earlier near-perfect result used the superseded 109.5375 mm estimate and is no longer valid; test these in order and use the first one that holds without scuffing.
- `green_hybrid_clip_coupon.stl` / `.3mf` — one compact full-height Green spring-catch gauge. Its smooth single-piece profile follows the measured taper into a 1.4 mm bearing land with 1.2 mm nominal top overlap, a 0.8 mm shoulder, and a 0.4 mm leading tip. With the revised physical height it reaches 43.89 mm, leaving about 0.56 mm below the exact 44.45 mm panel top; add a 5 mm slicer brim.
- `splitter_fit_coupon.stl` / `.3mf` — three short open-ended smooth-wall test channels at 0.00, 0.05, and 0.10 mm interference per side for the TP-Link body; use the least aggressive level that holds before committing to its full-length friction cradle
- `splitter_hybrid_clip_coupon.stl` / `.3mf` — one compact open-frame TP-Link section with four-way-symmetric rigid ramps grown directly from continuous side walls, 1.4 mm bearing lands, 1.2 mm nominal top overlap, zero nominal top gap, 0.8 mm shoulders, and 0.4 mm leading tips; use it to confirm that the complete wall can flex enough for installation before printing the rack
- `hybrid_clip_coupon.stl` / `.3mf` — the single print containing both compact top-clip gauges, about 9.7 g of PETG total; regenerate or re-download it whenever the clip geometry changes
- `green_vent_frame_coupon.stl` / `.3mf` and `splitter_vent_frame_coupon.stl` / `.3mf` — separate 5 mm-deep solid rear perimeter bands from the exact rounded Green and TP-Link cages. The Green coupon keeps its accepted height and now has 0.30 mm clearance on each side; the TP-Link keeps its prior side fit and lowers only the flexible roof by 0.05 mm. At this depth the crop ends before the floor, roof, or side-wall honeycomb openings begin, and both parts are already oriented with their insertion faces on the build plate.
- `vent_frame_coupon.stl` / `.3mf` — the recommended low-material rounded-cage fit test containing both production-derived solid bands as separate objects; approximately 184.3 × 38.04 × 5 mm and 7.4 g of PETG by mesh volume
- `dovetail_rail_coupon.stl` / `.3mf` — a six-piece rail-and-H-gate clearance test for the viewer-only dovetail retention branch. One, two, and three marker holes identify 0.00, 0.05, and 0.10 mm final-wedge clearances; validate sliding, seated grip, and deliberate removal before considering a complete gated mount.
- `assembly.stl` — reference assembly only; print the separate parts above
- `fit_test.stl` / `.3mf` — general device-clearance check

Clearly named optional exports:

- `*_legacy_screw_tray.*` and `green_spacer*_legacy_screw_tray.*` — prior four-screw Green tray fallback
- `core_with_logo.*`, `one_piece_with_logo.*`, `x2d_plate_with_logo.*`, `logo_inlay_optional.stl`, and `one_piece_logo_inlay_optional.stl` — optional branded-face study; the inlay only fits a matching `_with_logo` mount
- `core_with_shutter.*`, `one_piece_with_shutter.*`, `x2d_plate_with_shutter.*`, and `led_shutter_*_optional.*` — optional captive-shutter study
- `*_front_ethernet_right.*`, `*_front_ethernet_left.*`, and `one_piece_front_ethernet_far_right.*` — optional front-entry comparisons, all otherwise inheriting the unified-raised-deck/plain-face/open-aperture defaults
- `keystone_fit_test.stl` / `.3mf` — front-keystone latch coupon
- The HA-right front-entry comparison is one-piece-only because its keystone occupies the detachable right-ear joint zone

Viewer and render artifacts:

- `renders/assembly_preview.png` — layout preview with translucent device mockups
- `viewer/home-assistant-green-rack-compact.glb` — 35 mm setback comparison mockup
- `viewer/home-assistant-green-rack-balanced.glb` — 47.5 mm setback comparison mockup
- `viewer/home-assistant-green-rack-cable_friendly-no_shutter.glb` — GLB used by the production-default viewer state
- `viewer/home-assistant-green-rack-stacked_center.glb` — viewer-only centered Green with a transverse TP-Link directly behind it
- `viewer/home-assistant-green-rack-front_ethernet_right.glb`, `viewer/home-assistant-green-rack-front_ethernet_far_right.glb`, and `viewer/home-assistant-green-rack-front_ethernet_left.glb` — center-gap, HA-right, and left front-keystone mockups with their internal cabling
- Every viewer layout has both a shutter comparison GLB and a paired `-no_shutter.glb` bare-aperture GLB with no lens mesh
- `viewer/home-assistant-green-rack-front_ethernet.glb` and its no-shutter counterpart are compatibility aliases of the center-gap GLBs
- `viewer/home-assistant-green-rack-sics_angled.glb` — viewer-only angled SICSOLINK mockup showing its captive cable routing
- `viewer/viewer_green_tray_friction_raised.stl`, `viewer/viewer_green_tray_friction_pads.stl`, `viewer/viewer_green_tray_friction_full.stl`, and `viewer/viewer_green_tray_friction_skeletal.stl` — mutually exclusive complete friction-tray meshes for Unified raised deck, Four pads, Full honeycomb, and Open frame support; each includes the fused walls and stops
- `viewer/viewer_retention_hybrid_clips.stl` — viewer-only combined prototype containing the complete four-pad Green top-clip tray plus TP-Link replacement side walls with four mirrored rigid catches
- `viewer/viewer_retention_ventilated_sleeves.stl` — layout-specific rear-loading sleeve study with aligned raised honeycomb floors and thick rounded side frames around large capsule vents; no riser columns, springs, or relief slots
- `viewer/variants/*/viewer_enclosure_airframe.stl` — viewer-only ventilated 1U chassis study; it is not part of the printable production files

The selected one-piece vent-frame file is 254 × 44.45 × 143.7 mm in its supplied faceplate-down orientation and is approximately 123 g by PETG mesh volume. It nominally fits the X2D's 256 mm main-nozzle area with only 1 mm per side; center it carefully and do not use a brim. The X2D profile gives nozzle 1 the full X=0–256 mm area and nozzle 2 the X=20.5–256 mm area. Therefore the complete part does not need to fit inside the 235.5 mm overlap when nozzle 2 is used only for localized support interfaces: the PoE/bridge region sits at approximately X=28–88 mm on a centered plate and remains reachable by both nozzles. Keep the PETG model on nozzle 1 and any PLA support interface on nozzle 2. The safer split vent-frame plate is 220 × 94.45 × 143.7 mm, contains three objects, and is approximately 133 g because of the ear-joining bosses. The printed mount and modeled cable exits stay within the RackMate T2's approximately 240 mm internal depth.

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
- Print `core.stl` faceplate-down: rotate it so the broad front face lies on the build plate. The raised decks then grow edge-on from the panel instead of beginning 6.025 mm above the bed.
- The selected `one_piece_rear_cable_friendly_vent_frame_no_dovetail` files are already faceplate-down. Center the part and do not add a brim. Use nozzle 1 for the PETG model; localized PLA support-interface paths around the PoE/bridge region may use nozzle 2 because they remain inside its X=20.5–256 mm reach. Use the matching split plate if Bambu Studio rejects the 1 mm side margins or if you prefer more placement tolerance.
- The same orientation applies to optional comparison mounts and the HA-right one-piece file
- Ear and LED-insert STLs are already exported face-side down; enable support for the ear tongues

The supplied 3MF is geometry-only, not a pre-sliced Bambu project. In Bambu Studio, split it into objects and use normal/snug build-plate-only support on the ears rather than broad tree supports. A brim is normally unnecessary; a wide brim may join the nested pieces.

The production LED window is intentionally left open, so there is no lens, shutter blade, or retainer to print or assemble. The optional translucent insert can still be generated for comparison if dust protection is preferred later.

For the current friction baseline, print `friction_fit_coupon.stl` and `splitter_fit_coupon.stl`. If top clips are preferred, print only `hybrid_clip_coupon.stl` or `.3mf`; it places the selected Green and TP-Link gauges together without joining their roots. Use PETG or ASA, 0.20 mm layers, and 4–5 walls. Print the Green gauge tray-down with a 5 mm brim; orient the TP-Link gauge on its open Y/end face so its layers match the intended faceplate-down production print. The TP-Link coupon intentionally has no spring slots: tuck one edge under its rigid catches, then rock the opposite edge into place and confirm the continuous walls flex without whitening or cracking.

The rounded vent-frame coupons have now passed physically for both devices. Print the complete no-dovetail mount using the same printer, material, wall count, and dimensional-compensation settings as those successful coupons. The completed mount still needs a first-article pull/rattle check because its full-length cages are stiffer than the 5 mm gauges.

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
openscad -o exports/green_hybrid_clip_coupon.stl -D 'part="green_hybrid_clip_coupon"' ha_green_rack.scad
openscad -o exports/splitter_fit_coupon.stl -D 'part="splitter_fit_coupon"' ha_green_rack.scad
openscad -o exports/splitter_hybrid_clip_coupon.stl -D 'part="splitter_hybrid_clip_coupon"' ha_green_rack.scad
openscad -o exports/hybrid_clip_coupon.stl -D 'part="hybrid_clip_coupon"' ha_green_rack.scad
openscad -o exports/green_vent_frame_coupon.stl -D 'part="green_vent_frame_coupon"' ha_green_rack.scad
openscad -o exports/splitter_vent_frame_coupon.stl -D 'part="splitter_vent_frame_coupon"' ha_green_rack.scad
openscad -o exports/vent_frame_coupon.stl -D 'part="vent_frame_coupon"' ha_green_rack.scad
openscad -o exports/dovetail_rail_coupon.stl -D 'part="dovetail_rail_coupon"' ha_green_rack.scad

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
edge, or inconsistent winding automatically retries with CGAL. The large
printable 3MF variants explicitly use CGAL because the current Manifold 3MF
export can retain zero-area triangle fragments; PNG and small accessory exports
keep OpenSCAD's normal rendering behavior. Outputs are replaced atomically.
Build logs show the selected backend, elapsed time, and fallback reason. Set
`OPENSCAD_BIN` to use a different OpenSCAD executable; older builds without
backend selection run through their normal CGAL path.

For faster iteration, use the incremental wrapper after at least one full build:

```sh
# HTML/JavaScript or option-copy changes only; no OpenSCAD, NumPy, or trimesh.
bash scripts/build.sh html

# Repack existing STL geometry into GLBs and refresh the HTML.
bash scripts/build.sh glb

# Rebuild one layout's viewer geometry, both shutter states, GLBs, and HTML.
bash scripts/build.sh viewer cable_friendly
bash scripts/build.sh viewer stacked_center

# Rebuild every layout after changing per-layout geometry such as the optional airframe or TP-Link hybrid clips.
bash scripts/build.sh viewer

# Rebuild a retention concept, then refresh the affected viewer GLBs.
# Hybrid clips are rebuilt separately for every splitter setback.
bash scripts/build.sh retention slide_latch

# Rebuild canonical production files plus clearly named comparisons.
bash scripts/build.sh full
```

`viewer` and `glb` accept multiple variant names; omit them to rebuild every comparison layout. `glb` repacks both shutter states for each selected layout. `retention friction_sleeve` rebuilds all four shared friction support styles plus the centered-layout copies and compatibility alias. Layout-specific retention meshes keep the side-by-side and centered-stacked geometry aligned independently. OpenSCAD viewer jobs run four at a time by default, adjustable with `VIEWER_BUILD_JOBS`. Partial outputs are written to temporary files and moved into place only after a successful build.

`scripts/dovetail_slide_collision.scad` is the regression fixture for the removable rear gate. Export it with `part="__validation_only__"`, `test_device="green"` or `"splitter"`, and a `slide_lift` value. An empty top-level result means the gate clears the cage at that insertion height; `test_target="ports"` checks the same sweep against the modeled connector envelopes.

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
- [TP-Link TL-POE10R official specifications](https://www.omadanetworks.com/us/business-networking/omada-accessory-poe-adapter/tl-poe10r/) — the enclosure is nominally the same 80.8/81 × 54 × 24 mm size as the TL-PD30G-M2; the substantive differences are Ethernet speed, PoE class, and output power
- [Simple Icons: Home Assistant](https://simpleicons.org/?q=homeassistant) — SVG geometry used for the badge; Home Assistant is a trademark of Nabu Casa

This model is an independent parametric design. The references above were used to cross-check device envelopes, rack slots, cooling access, and printer fit.
