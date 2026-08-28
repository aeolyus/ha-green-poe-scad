# Screwless Home Assistant Green retention

Research date: 2026-08-26

## Recommendation

The best current screwless design is the **unified raised direct-friction tray with thin honeycomb**, printed faceplate-down. It stays below the Green, uses no small flexures or separate parts, keeps the top and rear open, and already has integral front/rear stops for cable-pull loads. Reprint its fit coupon because the old result used the superseded 109.5375 mm footprint.

The rounded vent-frame cage remains the preferred enclosed/aesthetic experiment. Its continuous frame provides broad top and bottom capture without small snap features. Without moving the device or LED opening, the Green roof was reduced to 0.8 mm and lowered into 0.4 mm nominal vertical preload. Its top is now Z=42.7625 mm, leaving 0.2375 mm below the 43 mm panel outline. The 0.5 mm rear roof lead-in starts with 0.1 mm clearance before tightening into the full sleeve. Treat it as coupon-gated until that preload is physically confirmed.

The viewer prototype applies the same force-path idea to both devices:

- **Home Assistant Green:** two fixed left catches and two releasable right spring catches follow the measured upper taper, then overlap the clear lid edge by 1.2 mm. Short lower guides locate the measured 111.125 mm base, allow for the official 112 mm maximum cover envelope, and converge to the measured 107.95 mm top plateau.
- **TP-Link:** the bevel-aware cradle opens at the lower bevel, grips only the widest side band, and now uses four mirrored rigid catches grown directly from continuous mini walls. There are no tongue-relief cuts or separate spring regions; both sides use the same ramp/nose geometry and 1.2 mm nominal top overlap.
- **Rounded vent-frame alternative:** two rear-loading device-local cages use honeycomb floors and roofs joined by substantial rounded side frames. Each device receives one long capsule vent per side. Broad lower rails, end blocks, and roof borders follow the structural language of the supplied UCG-Fiber 3MF, the referenced USW-Lite enclosure, and Mauker's Chromebox rack mount while retaining large airflow openings.
- In the hybrid option, existing low front/rear stops take cable-pull loads, so the top catches mainly resist lift and tilt rather than carrying constant preload.
- The catches are short and broad instead of a thin X roof, and they leave the center of both devices open for airflow.
- The revised Green hybrid prototype reaches 43.8875 mm: 0.5625 mm inside the nominal 44.45 mm 1U pitch, but 0.8875 mm above the 43 mm RackMate faceplate outline. This needs an adjacent-equipment clearance check before production.

Physical TP-Link measurements from the unit on hand use 1/32-inch ruler increments: 53.975 mm maximum width (2 1/8 in), a 47.625 mm flat plateau width (1 7/8 in), 23.8125 mm total height (15/16 in), and an 18.25625 mm straight side band (23/32 in). The enclosure is symmetric top-to-bottom, so the remaining height is divided into equal 2.778125 mm (7/64 in) bevel traversals. Both plateaus are inset 3.175 mm per side. The measured 67.46875 mm length (2 21/32 in) is modeled as the flat plateau length, not the full housing: TP-Link publishes an 80.8 mm overall length, and the other two published dimensions agree with the physical measurements within 0.19 mm. This leaves matching 6.665625 mm longitudinal bevels at each end of both plateaus.

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

1. **Unified raised direct-friction tray** — best overall screwless balance: lowest height, fewest parts, support-free printing, open airflow, and integral fore/aft stops. Its risks are printer-specific interference, scuffing, and long-term PETG relaxation.
2. **Factory screws** — best absolute security and tolerance robustness with no top-height penalty, but slower service and a hardware/overtightening risk.
3. **Low rear-slide C-rails plus captured dovetail gate** — best future positive screwless architecture, but it still needs lower-ledge measurements, port-aware integration, and a rail-clearance coupon.
4. **Slide shoes plus rear latch** — open and support-friendly, but dependent on an unmeasured lower ledge and a fatigue-prone flexure.
5. **Four lower corner cups plus a captive rear gate** — tolerant and well ventilated, but gives less direct uplift capture and adds a moving part.
6. **Rounded vent-frame rear-loading cages** — best aesthetics and broad capture with large vents. The thinner preloaded roof now stays below the 43 mm faceplate outline, but full-length fit remains sensitive to tolerance and creep.
7. **Light guides plus localized top-edge catches** — open and light with positive lift resistance, but currently over the faceplate outline and dependent on small flexing features plus exact taper assumptions.
8. **Separate sliding sled/cage with a captive rear gate** — robust and replaceable, but costs more filament, interfaces, and service steps.
9. **Rigid rails with TPU anti-rattle pads plus a hard latch** — tolerant and quiet; TPU must not be the only restraint.
10. **Captive TPU or hook-and-loop strap** — dependable but over-height, visually busy, and subject to material creep.
11. **Full X-brace cage plus removable rear cap** — secure, but over-height, heavier, more obstructive to top airflow, and vulnerable at thin diagonal intersections.

Avoid 4 mm-class community return rails in a top-loading design: those dimensions assume the device slides in from an open end. Also avoid friction-only side springs, thin X lattices, magnets, and adhesive/Dual Lock. The Green can use shallow top catches only if their complete height remains below the real rack clearance and a coupon verifies release without whitening or scuffing.

The browser overlays are form and force-path studies, not finished printable mechanisms. Gate captivity, sled receivers, latch flexures, strap hinges/snaps, mating features, and final tolerances still require engineering and physical coupons. TPU pads are anti-rattle aids rather than standalone positive retention.

### Rear dovetail-gate study

The MakerWorld 590818 photographs show separate open rear H-frames dropping vertically into paired channels after each device is inserted from the rear. The rails block straight rear withdrawal and blind bottoms stop downward travel; no separate screw or obvious snap is visible, so the original appears to rely on channel friction and gravity.

An independent stronger branch was prototyped without copying the licensed mesh: separate Green and TP-Link gates use a shared 60-degree dovetail standard, 2.8 mm rail depth, 2.6 mm neck, 5.8 mm head, 0.25 mm running clearance per flank, and a final 7 mm wedge zone tightening to 0.10 mm per flank. A 1.2 mm blind bottom stop, top lead-in, and rear pull ledge avoid thin spring tabs. The concept is mechanically sound, but rear receiver towers add roughly 6 mm outside each cage wall and need a bridge/cable collision check. If pursued, first print a rail coupon with 0.10, 0.15, and 0.20 mm final wedge clearances.

Do not add this gate to the direct-friction tray: that tray's integral front and rear stops already carry fore/aft cable loads, so the gate adds parts and connector-side complexity without fixing an unmet failure mode. A captured rear gate becomes useful only for a future low-profile rear-loading C-rail or cage whose main sleeve deliberately permits axial sliding.

## Starting geometry for PETG prototypes

- Green lower guide: 0.20 mm/side nominal interference against the measured 111.125 mm lower footprint, held for only 2.5 mm above the device seat before allowing for the 112 mm maximum cover.
- Green upper clearance: 0.35 mm/side around the published cover envelope.
- Green catches: two per side, 18 mm long; 2.4 mm fixed arms on the left and 2.8 mm spring arms on the accessible right side.
- Green clip coupon: one 3.575 mm-reach screening gauge with a production-height spring root, two rib-supported seating pads, and one smooth X/Z profile joining the root, taper follower, 1.4 mm bearing land, 0.8 mm shoulder, and 0.4 mm minimum leading tip. Under the measured 111.125-to-107.95 mm taper, it overlaps the top face by 1.2 mm.
- Green catch underside: 0.30 mm above the modeled top and follows the 2.4 mm upper taper before reaching its horizontal bearing land. Maximum prototype height is 43.8875 mm.
- TP-Link bevels: symmetric 2.778125 mm upper and lower vertical traversals. The sleeve follows the 3.175 mm inset at both plateaus and maintains the selected 0.05 mm/side interference through the matching bevel profile.
- TP-Link clip: four symmetric 14 mm-long rigid catches are fused directly into uninterrupted side walls. Both sides follow the measured 3.175 mm upper inset and use zero nominal top gap for a snug friction/preload fit, a 1.4 mm bearing land, 1.2 mm nominal top overlap, 0.8 mm shoulder, and 0.4 mm leading tip. The whole wall must supply the small installation deflection, so the coupon is required before a full print.
- TP-Link clip coupon: one full-width open-frame section using the exact mirrored production-study catches. Five-millimeter transverse seating bars and six-millimeter root rails prevent the coupon from twisting more easily than the complete tray.
- Rounded vent-frame sleeves: 0.8 mm honeycomb roofs with 5 mm borders, aligned raised 3 mm honeycomb floors, and rear 6 mm/0.5 mm lead-ins. Both device floors and the connecting bridge finish at Z=9.025 mm without separate riser columns. The Green side frames follow the measured 111.125 mm bottom and 107.95 mm top plateau through the upper taper; they use 2.4 mm frame thickness, 0.4 mm nominal vertical roof preload, one approximately 99.8 × 21 mm capsule opening, and 8 mm end blocks. The rear lead-in initially leaves 0.1 mm vertical clearance. The TP-Link uses one approximately 72.6 × 13 mm capsule opening with 7 mm end blocks and zero nominal roof gap. The Green roof ends at Z=42.7625 mm, leaving 0.2375 mm below the 43 mm panel outline; the TP-Link roof ends at Z=33.6375 mm. Both sleeves omit rear stops for axial loading.
- Rounded vent-frame coupon: an exact 18 mm crop from the rear of each complete cage, including floor, side frames, roof, bevel profile, and insertion lead-in. The revised Green coupon is approximately 116.6 × 36.9 × 18 mm and 8.2 g of PETG; the TP-Link coupon is approximately 59.8 × 27.6 × 18 mm and 5.9 g. The combined plate remains two separate manifold objects, approximately 184.4 × 36.9 × 18 mm and 14.1 g total.
- The cable-friendly rounded-frame overlay is approximately 63.4 g of PETG by mesh volume after replacing the low floors and Green riser pads with the unified raised decks. This is the two-device sleeve overlay, not the complete faceplate/mount mass.
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

1. Print the combined `vent_frame_coupon.3mf`; it contains mechanically independent, exact 18 mm rear crops of the Green and TP-Link rounded cages and is already oriented for the intended faceplate-down layer direction.
2. Slide each device into its matching band only as far as needed to engage the full normal-clearance section beyond the short rear lead-in. Stop if insertion requires excessive force or the frame whitens.
3. Confirm that each device sits flat without rocking, remains snug during a gentle upside-down test, and withdraws without surface scuffing or permanent spreading.
4. If either cage is too loose or tight, adjust only that device's interference and regenerate the same short coupon. Once both pass, generate one complete rounded-cage mount and perform at least 50 insert/remove cycles plus a warm cable-pull test before promoting it to the canonical print.
5. Keep `hybrid_clip_coupon.3mf` as the fallback experiment if the continuous cage proves too sensitive or difficult to service.

## Sources

- [Home Assistant Green specifications](https://www.home-assistant.io/green/)
- [Protolabs snap-fit design guidance](https://www.hubs.com/knowledge-base/how-design-snap-fit-joints-3d-printing/)
- [Xometry FDM design tips](https://xometry.pro/en/articles/fdm-design-tips/)
- [AON3D engineering fits](https://www.aon3d.com/applications/engineering-fits-how-to-design-for-3d-printed-assemblies/)
- [MakerWorld 590818 rack mount](https://makerworld.com/en/models/590818-home-assistant-green-poe-splitter-10-rack-mount#profileId-512398)
- [Mauker ASUS Chromebox 3 rack mount](https://makerworld.com/en/models/2526812-asus-chromebox-3-cn65-10-inch-rack-mount) — visual reference for thick rounded capsule-vent frames; no source geometry reused
- [Archived Etsy 4430188404 listing](https://web.archive.org/web/20260207053959/https://www.etsy.com/listing/4430188404/home-assistant-green-10-rack-mount)
- [Nexus3D product page](https://nexus3d.co.uk/product/home-assistant-green-10-rack-mount/)
