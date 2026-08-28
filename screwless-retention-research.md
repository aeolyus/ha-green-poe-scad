# Screwless Home Assistant Green retention

Research date: 2026-08-26

## Recommendation

For the next prototype, use **light lower guide contact plus localized positive top-edge catches**, printed tray-down. Keep the current four-pad friction tray as the unchanged production baseline until the new Green and TP-Link clip coupons are physically tested.

The viewer prototype applies the same force-path idea to both devices:

- **Home Assistant Green:** two fixed left catches and two releasable right spring catches follow the modeled upper taper, then overlap the clear lid edge by 1.2 mm. Short lower guides locate the measured 109.5375 mm base, then flare outward around the official 112 mm cover envelope.
- **TP-Link:** the bevel-aware cradle opens at the lower bevel, grips only the widest side band, and now uses four mirrored rigid catches grown directly from continuous mini walls. There are no tongue-relief cuts or separate spring regions; both sides use the same ramp/nose geometry and 1.2 mm nominal top overlap.
- **Ventilated-sleeve alternative:** two rear-loading device-local tunnels use honeycomb floors and roofs plus perforated continuous side walls. They retain the front stops, leave the rear mouths open, and rely on close wall contact rather than clips, following the architecture of the supplied UCG-Fiber 3MF and the referenced USW-Lite enclosure.
- In the hybrid option, existing low front/rear stops take cable-pull loads, so the top catches mainly resist lift and tilt rather than carrying constant preload.
- The catches are short and broad instead of a thin X roof, and they leave the center of both devices open for airflow.
- The Green prototype reaches 42.55 mm, leaving about 0.45 mm inside the modeled 43 mm 1U envelope. That is enough for a visual prototype, but too close to call production-ready without a rack fit check.

Physical TP-Link measurements from the unit on hand use 1/32-inch ruler increments: 53.975 mm maximum width (2 1/8 in), a 47.625 mm flat top width (1 7/8 in), 23.8125 mm total height (15/16 in), a 3.96875 mm lower bevel rise (5/32 in), an 18.25625 mm straight side band (23/32 in), and therefore a 1.5875 mm upper bevel rise (1/16 in). The top is inset 3.175 mm per side. The measured 67.46875 mm length (2 21/32 in) is modeled as the flat top plateau, not the full housing: TP-Link publishes an 80.8 mm overall length, and the other two published dimensions agree with the physical measurements within 0.19 mm. This leaves 6.665625 mm of longitudinal upper bevel at each end. The horizontal lower-bevel inset remains unmeasured.

## Evidence from existing designs

- [MakerWorld 883556](https://makerworld.com/en/models/883556-home-assistant-green-wall-mount) uses a slide-in pocket/sleeve with open ports and airflow. It has 294 reported prints and 385 downloads. In a horizontal rack it would still need a positive end latch because gravity no longer retains the device.
- [MakerWorld 2297786](https://makerworld.com/en/models/2297786-wall-mount-din-rail-for-home-assistant-green) uses side rails, compliant S-shaped spring pieces, and end restraints and is shown holding the Green upside down. It proves compliant retention can work, but its glued multipart construction is less attractive for this rack.
- [MakerWorld 452481](https://makerworld.com/en/models/452481-wallmount-for-home-assistant-green), [Printables 691723](https://www.printables.com/model/691723-home-assistant-green-wall-mount), [Printables 680691](https://www.printables.com/model/680691-home-assistant-green-wall-mount), and [Thingiverse 6846821](https://www.thingiverse.com/thing:6846821) use the same broad C-channel family. Downloaded sections measure about 112 mm between side walls and about 104 mm between inward returns: roughly 4 mm of clear-lid overlap per side. That is a rear-slide sleeve dimension, not a suitable snap-over value.
- [Thingiverse 6770609](https://www.thingiverse.com/thing:6770609) uses two side grips and suggests rubber feet to improve retention.
- [Thingiverse 6846821](https://www.thingiverse.com/thing:6846821) uses rounded inward return rails over the clear top edge. The rounded return is stronger and less scuff-prone than a sharp hook.
- [Hive Tech rack mount](https://hivets.au/products/rack-mount-for-home-assistant-green-modular) uses a snug slide-in frame.
- [MakerWorld 590818](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398) uses an open X-braced cage over the clear lid plus separate removable rear retaining frames. It proves that positive top capture works in a rack orientation, but one commenter reported repeated breakage at thin diagonal-truss nodes. Its license is BY-NC, and the viewer option is an independent dimensional study rather than copied mesh geometry.
- [Etsy 4430188404](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount) is a one-piece open-top pocket with tapered side cheeks and shallow end stops. The listing and [Nexus3D assembly guide](https://nexus3d.co.uk/guides/assemble-10-inch-rack-mounts/) describe a deliberately tight fit, with no visible latch, gate, screw, or upper capture feature.

## Ranked alternatives

1. **Light guides + localized top-edge catches** — current engineering recommendation for a one-piece, top-loadable prototype. It adds positive lift resistance while keeping the floor, vents, and ports open.
2. **Direct-seat friction tray** — simplest and still the current production baseline, but sensitive to printer calibration, surface scuffing, removal cycles, and PETG creep.
3. **Rear-slide C-rails + rear latch/gate** — the most directly community-proven top-capture pattern, but it needs either a separate rear closure or a more complex one-piece latch.
4. **Four lower corner cups plus a captive rear gate** — tolerant of uncertain case geometry, but adds a moving part.
5. **Separate sliding sled/cage with a captive rear gate** — robust and replaceable, but costs more filament and parts.
6. **Rigid rails with TPU anti-rattle pads plus a hard latch** — tolerant and quiet; TPU must not be the only restraint.
7. **Captive TPU or hook-and-loop strap** — dependable but visually busier and consumes scarce vertical clearance.
8. **Full X-brace cage plus removable rear cap** — secure, but heavier and vulnerable at thin diagonal intersections.

Avoid 4 mm-class community return rails in a top-loading design: those dimensions assume the device slides in from an open end. Also avoid friction-only side springs, thin X lattices, magnets, and adhesive/Dual Lock. The Green can use shallow top catches only if their complete height remains below the real rack clearance and a coupon verifies release without whitening or scuffing.

The browser overlays are form and force-path studies, not finished printable mechanisms. Gate captivity, sled receivers, latch flexures, strap hinges/snaps, mating features, and final tolerances still require engineering and physical coupons. TPU pads are anti-rattle aids rather than standalone positive retention.

## Starting geometry for PETG prototypes

- Green lower guide: 0.20 mm/side nominal interference against the measured 109.5375 mm lower footprint, held for only 2.5 mm above the device seat before flaring around the 112 mm cover.
- Green upper clearance: 0.35 mm/side around the published cover envelope.
- Green catches: two per side, 18 mm long; 2.4 mm fixed arms on the left and 2.8 mm spring arms on the accessible right side.
- Green clip coupon: one 2.78125 mm-reach screening gauge with a production-height spring root, two rib-supported seating pads, and one smooth X/Z profile joining the root, taper follower, 1.4 mm bearing land, 0.8 mm shoulder, and 0.4 mm minimum leading tip. Under the current image-derived taper model, it overlaps the top face by 1.2 mm.
- Green catch underside: 0.30 mm above the modeled top and follows the assumed 2.4 mm upper taper before reaching its horizontal bearing land. Maximum prototype height is 42.55 mm.
- TP-Link lower bevel: 0.50 mm/side relief at the floor, transitioning to the 0.05 mm/side body-band fit over the measured 3.96875 mm vertical rise. The 0.50 mm horizontal relief remains provisional until the bottom face width is measured.
- TP-Link clip: four symmetric 14 mm-long rigid catches are fused directly into uninterrupted side walls. Both sides follow the measured 3.175 mm upper inset and use zero nominal top gap for a snug friction/preload fit, a 1.4 mm bearing land, 1.2 mm nominal top overlap, 0.8 mm shoulder, and 0.4 mm leading tip. The whole wall must supply the small installation deflection, so the coupon is required before a full print.
- TP-Link clip coupon: one full-width open-frame section using the exact mirrored production-study catches. Five-millimeter transverse seating bars and six-millimeter root rails prevent the coupon from twisting more easily than the complete tray.
- Ventilated sleeves: 1.2 mm honeycomb roofs, zero nominal roof gap, rear 6 mm/0.5 mm lead-ins, and point-up side apertures. The Green roof ends at Z=42.225 mm, leaving 0.775 mm inside the nominal 43 mm panel envelope; the TP-Link roof ends at Z=28.0125 mm. Both sleeves omit rear stops for axial loading.
- Print in PETG or ASA at 0.20 mm layers with 4–5 walls. Print the Green gauge tray-down with a 5 mm brim. Print the TP-Link gauge on its open Y/end face so its layers match the intended faceplate-down production orientation. The vented-sleeve concept should be printed faceplate-down, matching the supplied UCG-Fiber 3MF.

Design target: at least 25–30 N extraction resistance and 20 N lift/tilt resistance. The Green weighs about 340 g, or 3.34 N statically.

## Measurements needed before the full CAD revision

Official material does not publish the taper cross-section. Measure with calipers if possible:

- maximum width/depth at the dark lower base;
- maximum clear-cover width at the catch height;
- top-face width immediately inside the clear edge;
- height where the lower black base transitions to the clear cover;
- lower-base corner radius;
- flat support areas versus cooling fins;
- port-edge keep-out;
- actual installed clearance above the Green.

If calipers are unavailable, print a short stepped coupon rather than guessing.

For the selected direct-seat friction concept, heat is not the main uncertainty; the Green is a low-power device and the honeycomb remains open. The unresolved issue is mechanical: the public dimensions do not show whether fins, screw bosses, labels, or a perimeter foot are the first underside contact. A shallow underside/rib coupon should therefore verify that the enclosure sits flat and does not rock before generating the complete printable tray.

No complete official Green enclosure CAD was found. The closest device-part reference is the user-made [MakerWorld 1025019 replacement shell](https://makerworld.com/en/models/1025019-home-assistant-green-box), which includes STEP/STL under CC BY-NC-SA 4.0. It can help validate the translucent shell profile but does not model the black heatsink or lower seam required for a precise rail fit.

## Validation sequence

1. Print the combined `hybrid_clip_coupon`; it contains the selected taper-following Green spring gauge and the TP-Link matched-ramp gauge as separate, mechanically independent pieces. Both target 1.2 mm nominal overlap under the current enclosure assumptions.
2. For the Green gauge, tuck the fixed edge first and press the spring side down. For the TP-Link rigid coupon, tuck one side first and rock the opposite edge into place; stop if the wall whitens or requires excessive force.
3. Confirm that each selected catch visibly overlaps the top edge, holds when gently inverted, and releases without whitening or surface scuffing.
4. If either selected fit fails, generate only a nearby reach variant rather than reprinting another three-setting coupon. Once both pass, generate one complete hybrid tray and perform at least 50 install/remove cycles plus a warm cable-pull test before promoting it to the canonical print.

## Sources

- [Home Assistant Green specifications](https://www.home-assistant.io/green/)
- [Protolabs snap-fit design guidance](https://www.hubs.com/knowledge-base/how-design-snap-fit-joints-3d-printing/)
- [Xometry FDM design tips](https://xometry.pro/en/articles/fdm-design-tips/)
- [AON3D engineering fits](https://www.aon3d.com/applications/engineering-fits-how-to-design-for-3d-printed-assemblies/)
- [MakerWorld 590818 rack mount](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398)
- [Archived Etsy 4430188404 listing](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount)
- [Nexus3D product page](https://nexus3d.co.uk/product/home-assistant-green-10-rack-mount/)
