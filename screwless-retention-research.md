# Screwless Home Assistant Green retention

Research date: 2026-08-26

## Recommendation

Use a rear-loaded, segmented slide cradle that captures the dark lower-base perimeter ledge, with two fixed front stops and a separately printed, replaceable rear release latch. Keep the existing four-screw design as the best-documented baseline until a physical print verifies this mount and a fit coupon validates the lower ledge.

This approach is preferable because it:

- positively resists lift and cable-pull forces instead of relying on friction;
- leaves the translucent polycarbonate cover, top vents, and finned underside unobstructed;
- fits the approximately 1.98 mm of remaining 1U clearance above the Green, where top hooks would not;
- lets the Green slide out for service after pressing a rear release;
- permits the latch to be reprinted independently if it fatigues.

## Evidence from existing designs

- [MakerWorld 883556](https://makerworld.com/en/models/883556-home-assistant-green-wall-mount) uses a slide-in pocket/sleeve with open ports and airflow. It has 294 reported prints and 385 downloads. In a horizontal rack it would still need a positive end latch because gravity no longer retains the device.
- [MakerWorld 2297786](https://makerworld.com/en/models/2297786-wall-mount-din-rail-for-home-assistant-green) uses side rails, compliant S-shaped spring pieces, and end restraints and is shown holding the Green upside down. It proves compliant retention can work, but its glued multipart construction is less attractive for this rack.
- [MakerWorld 452481](https://makerworld.com/en/models/452481-wallmount-for-home-assistant-green) is an open-air surrounding cage with substantial community use.
- [Thingiverse 6770609](https://www.thingiverse.com/thing:6770609) uses two side grips and suggests rubber feet to improve retention.
- [Thingiverse 6846821](https://www.thingiverse.com/thing:6846821) uses a tight ventilated cradle with tie-wrap backup slots.
- [Hive Tech rack mount](https://hivets.au/products/rack-mount-for-home-assistant-green-modular) uses a snug slide-in frame.
- [MakerWorld 590818](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398) uses an open X-braced cage for both the Green and a TL-POE10R, followed by separate removable rear retaining frames. It provides positive capture, but one commenter reported repeated breakage at thin diagonal-truss nodes. Its license is BY-NC, and the viewer option is an independent dimensional sketch rather than copied mesh geometry.
- [Etsy 4430188404](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount) is a one-piece open-top pocket with tapered side cheeks and shallow end stops. The listing and [Nexus3D assembly guide](https://nexus3d.co.uk/guides/assemble-10-inch-rack-mounts/) describe a deliberately tight fit, with no visible latch, gate, screw, or upper capture feature.

## Ranked alternatives

1. **Segmented lower-ledge rails plus rear spring latch** — best security, airflow, serviceability, and filament use.
2. **Four lower corner cups plus a captive sliding or quarter-turn rear gate** — more tolerant of uncertain case geometry, but less direct uplift capture and one extra moving part.
3. **Separate sliding sled/cage with a captive rear gate** — very robust and replaceable, but costs more filament and parts.
4. **Rigid rails with small TPU anti-rattle pads plus a hard rear stop** — tolerant and quiet; TPU must not be the only restraint.
5. **Captive TPU or hook-and-loop strap** — mechanically dependable but visually busier, crosses the top, and consumes scarce vertical clearance.
6. **Zip ties through existing backup slots** — reliable fallback, but unattractive and potentially obstructive.
7. **Full X-brace cage plus removable rear cap** — positive capture without Green screws, but heavier, less open, and dependent on a loose gate; thin truss intersections need generous radii and width.
8. **Direct-seat friction tray** — simplest one-piece option: localized side ribs and shallow end stops are fused into the existing tray, and the Green sits directly on the 3 mm honeycomb tray without the 6.025 mm screw spacers. This is the most sensitive option to printer calibration, underside flatness, surface scuffing, removal cycles, and PETG creep.

Avoid top hooks, friction-only side springs, magnets, and adhesive/Dual Lock. Top clearance is too small; PETG friction preload will creep; the heatsink is aluminum; and adhesive can leave residue or interfere with cooling.

The browser overlays are form and force-path studies, not finished printable mechanisms. Gate captivity, sled receivers, latch flexures, strap hinges/snaps, mating features, and final tolerances still require engineering and physical coupons. TPU pads are anti-rattle aids rather than standalone positive retention.

## Starting geometry for a PETG prototype

- Hard-rail side clearance: 0.4, 0.55, and 0.7 mm coupon variants.
- Rail segments: 16–20 mm long, 2.4–3.0 mm wall, 6–8 mm high.
- Lower-ledged capture overlap: approximately 0.8–1.0 mm, only after measuring the actual ledge.
- Vertical running clearance: 0.3–0.4 mm.
- Lead-in chamfer: 0.6–0.8 mm.
- Fixed front stops: 8–12 mm wide at both corners.
- Rear latch arms: 26–30 mm long, 1.8–2.0 mm thick, 8–10 mm tall.
- Latch flex: 1.2–1.5 mm; hook depth about 1.0 mm; root fillet at least 1.5 mm.
- Moving clearance: 0.5–0.6 mm; installed back-clearance: 0.15–0.25 mm so the latch is relaxed when locked.
- Print flexures flat/in the XY plane with 4–5 walls and elephant-foot compensation.

Design target: at least 25–30 N extraction resistance and 20 N lift/tilt resistance. The Green weighs about 340 g, or 3.34 N statically.

## Measurements needed before the full CAD revision

Official material does not publish the lower-base retention geometry. Measure with calipers:

- maximum width/depth at the dark lower base;
- ledge projection or undercut on each side;
- ledge thickness and height above the bottom;
- lower-base corner radius;
- flat support areas versus cooling fins;
- port-edge keep-out;
- actual installed clearance above the Green.

If calipers are unavailable, print a short stepped coupon rather than guessing.

For the selected direct-seat friction concept, heat is not the main uncertainty; the Green is a low-power device and the honeycomb remains open. The unresolved issue is mechanical: the public dimensions do not show whether fins, screw bosses, labels, or a perimeter foot are the first underside contact. A shallow underside/rib coupon should therefore verify that the enclosure sits flat and does not rock before generating the complete printable tray.

No complete official Green enclosure CAD was found. The closest device-part reference is the user-made [MakerWorld 1025019 replacement shell](https://makerworld.com/en/models/1025019-home-assistant-green-box), which includes STEP/STL under CC BY-NC-SA 4.0. It can help validate the translucent shell profile but does not model the black heatsink or lower seam required for a precise rail fit.

## Validation sequence

1. Print three 25–30 mm rail coupons with 0.4/0.55/0.7 mm clearance.
2. Print a latch comb with 1.6/1.8/2.0 mm beams and 0.8/1.0 mm hooks.
3. Print a 35–40 mm combined rail-and-latch section.
4. Require insertion below 10 N, deliberate release below 15 N, unassisted extraction above 25 N, 50 cycles without whitening/cracks, and a warm 10–20 N load test.

## Sources

- [Home Assistant Green specifications](https://www.home-assistant.io/green/)
- [Protolabs snap-fit design guidance](https://www.hubs.com/knowledge-base/how-design-snap-fit-joints-3d-printing/)
- [Xometry FDM design tips](https://xometry.pro/en/articles/fdm-design-tips/)
- [AON3D engineering fits](https://www.aon3d.com/applications/engineering-fits-how-to-design-for-3d-printed-assemblies/)
- [MakerWorld 590818 rack mount](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398)
- [Archived Etsy 4430188404 listing](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount)
- [Nexus3D product page](https://nexus3d.co.uk/product/home-assistant-green-10-rack-mount/)
