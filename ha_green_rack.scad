/*
  Home Assistant Green + TP-Link TL-PD30G-M2
  10-inch / 1U rack mount for DeskPi RackMate T2

  Copyright (c) 2026 Richard Huang
  SPDX-License-Identifier: MIT

  Coordinate system:
    X = rack width
    Y = front-to-back depth
    Z = vertical

  Export by overriding `part`, for example:
    openscad -o exports/core.stl -D 'part="core"' ha_green_rack.scad
*/

$fn = 48;

// [assembly_preview, assembly, one_piece, one_piece_logo_inlay, x2d_plate, core, logo_inlay, left_ear, right_ear, led_insert, led_shutter, led_shutter_retainer, led_shutter_kit, led_fixed_window_kit, green_spacer, green_spacers_4x, fit_test, friction_fit_coupon, green_hybrid_clip_coupon, splitter_fit_coupon, splitter_hybrid_clip_coupon, hybrid_clip_coupon, green_vent_frame_coupon, splitter_vent_frame_coupon, vent_frame_coupon, dovetail_rail_coupon, green_dovetail_gate, splitter_dovetail_gate, keystone_fit_test, viewer_mount, viewer_mount_without_green_tray, viewer_splitter_floor, viewer_splitter_side_walls, viewer_splitter_end_stops, viewer_green_tray_standard, viewer_green_tray_friction, viewer_green_tray_friction_raised, viewer_green_tray_friction_full, viewer_green_tray_friction_pads, viewer_green_tray_friction_skeletal, viewer_insert, viewer_shutter_open, viewer_shutter_closed, viewer_shutter_retainer, viewer_logo, viewer_green, viewer_splitter, viewer_ports, viewer_green_ports, viewer_splitter_ports, viewer_keystone_ports, viewer_data_cables, viewer_internal_data_cable, viewer_input_data_cable, viewer_dc_cable, viewer_fasteners, viewer_retention_factory_screws, viewer_retention_slide_latch, viewer_retention_corner_gate, viewer_retention_sled_gate, viewer_retention_padded_rails, viewer_retention_captive_strap, viewer_retention_x_cage, viewer_retention_hybrid_clips, viewer_retention_ventilated_sleeves, viewer_retention_dovetail_gates, viewer_retention_friction_sleeve, viewer_enclosure_airframe, viewer_rulers, viewer_led_power, viewer_led_activity, viewer_led_health]
part = "assembly_preview";

// Production geometry uses the TP-Link. Viewer-only builds may override this
// with "sics" to show the user's existing captive-lead splitter.
splitter_model = "tplink";

// Viewer-only arrangement switch. The production files retain the selected
// cable-friendly side-by-side layout; "stacked_center" centers the Green and
// rotates the TP-Link across the rack directly behind it.
device_layout = "side_by_side";  // [side_by_side, stacked_center]
stacked_center_layout = device_layout == "stacked_center";

// Cable-friendly production layout: rear PoE/Ethernet entry with the TP-Link
// set back 60 mm from the face. Front-entry editions and other setbacks remain
// available as explicit build overrides.
front_ethernet_enabled = false;
front_keystone_side = "right";  // [left, right, far_right]

// Green support carried by the printable mount. The production default is a
// thin honeycomb deck raised directly to the device seating plane, eliminating
// separate riser columns. Legacy and comparison trays remain selectable.
green_tray_style = "friction_raised";  // [friction_raised, friction_pads, standard, friction_full, friction_skeletal]

// Physical front-window choice. When false, the face has no actuator slot,
// moving blade, or rear cartridge.
led_shutter_enabled = false;

// Leave the production LED window as a bare opening. Set true to add the
// optional self-retaining translucent insert without enabling the shutter.
led_window_insert_enabled = false;

// The production face is intentionally uninterrupted outside the LED
// window: no recessed logo, inlay pocket, or cosmetic seam. Set true only for
// an explicitly branded alternate export.
face_logo_enabled = false;

// Optional static-render aid. Browser GLBs carry all concepts and switch them
// interactively; leave this blank for normal production exports.
viewer_retention_preview = "";

// Device-fit tuning. Print fit_test.stl before the complete mount.
green_clearance = 0.50;       // clearance per side, mm
splitter_clearance = 0.40;    // clearance per side, mm

// Rack geometry
rack_width = 254.0;
rack_height = 44.45;          // exact IEC 60297 1U panel height
rack_unit_pitch = 44.45;      // nominal vertical allowance for 1U
rack_hole_spacing = 236.525;  // official RackMate T2 rail-hole pitch
rack_hole_x = (rack_width - rack_hole_spacing) / 2;
rack_hole_z = [6.35, 38.10];     // Mauker/EIA-style 1.25 in vertical pitch
rack_slot_w = 13.0;
rack_slot_h = 7.0;

// Split construction for the X2D bed
ear_width = 17.0;
core_width = rack_width - 2 * ear_width;
face_thickness = 3.0;
base_thickness = 3.0;

// Home Assistant publishes a 112 x 112 x 32 mm nominal envelope. Richard's
// physical enclosure measures 4 3/8 in (111.125 mm) across the bottom,
// 4 1/4 in (107.95 mm) across the top plateau after the inward taper, and
// 1 5/16 in (33.3375 mm) tall. The taper begins 1/4 in (6.35 mm) above
// the bottom. Treat both plan axes as square until a separate depth
// measurement says otherwise. Keep the published 112 mm value only as a
// documented conservative envelope; active fit geometry follows measurements.
// Centered placement preserves the previous LED window and screw pattern.
green_w = 111.125;
green_d = 111.125;
green_h = 33.3375;
green_top_w = 107.95;
green_top_d = 107.95;
green_published_envelope = 112.0;
green_cover_w = green_w;
green_cover_d = green_d;
green_lower_base_h = 5.0;
green_cover_relief_h = 2.0;
green_cover_side_clearance = 0.20;
green_cover_top_inset = (green_cover_w - green_top_w) / 2;
green_taper_start_h = 6.35;
green_cover_upper_bevel_h = green_h - green_taper_start_h;
green_inner_w = green_w + 2 * green_clearance;
green_inner_d = green_d + 2 * green_clearance;
green_mount_pitch_x = 102.65;
green_mount_pitch_y = 102.00;
green_mount_hole_d = 3.70;
green_spacer_od = 6.30;
green_spacer_bore = 3.35;
green_standoff_default = 6.025;
green_standoff_override = undef;
green_standoff = is_undef(green_standoff_override)
    ? green_standoff_default : green_standoff_override;
green_spacer_tip_h = 1.475;
green_spacer_h = green_standoff + green_spacer_tip_h;
// The normal layout moves the Green right to leave a full-depth splitter bay.
// The viewer-only stacked study centers it on the complete 254 mm panel.
green_x = stacked_center_layout
    ? core_width / 2 - green_w / 2
    : 88.0 + (112.0 - green_w) / 2;
green_y = 4.5 + (112.0 - green_d) / 2;
green_mount_x = [green_x + (green_w - green_mount_pitch_x) / 2,
                 green_x + (green_w + green_mount_pitch_x) / 2];
green_mount_y = [green_y + (green_d - green_mount_pitch_y) / 2,
                 green_y + (green_d + green_mount_pitch_y) / 2];
green_device_z = base_thickness + green_standoff;
unified_deck_raise = green_standoff;
unified_deck_z0 = green_device_z - base_thickness;

// TP-Link TL-PD30G-M2. TP-Link publishes 80.8 x 54 x 24 mm overall.
// The user's physical unit measured 2 1/8 in wide, 15/16 in high, with a
// 2 21/32 in-long flat top plateau. X is device width; Y is full device
// length. LAN/DC outputs face the rack front, while POWER+DATA IN faces rear.
splitter_w = 53.975;                 // measured 2 1/8 in; official 54 mm
splitter_d = 80.8;
splitter_h = 23.8125;                // measured 15/16 in; official 24 mm
splitter_top_flat_w = 47.625;         // measured 1 7/8 in
splitter_top_flat_d = 67.46875;      // measured 2 21/32 in
splitter_inner_w = splitter_w + 2 * splitter_clearance;
splitter_inner_d = splitter_d + 2 * splitter_clearance;
splitter_vertical_clearance = 0.50;
// Continuous-wall close fit for the production TP-Link cradle. A full
// 80.8 mm contact length multiplies insertion force, so start conservatively.
splitter_friction_interference = 0.05;  // inward movement per side, mm
splitter_friction_lead_relief = 0.50;   // opening gained per side at top, mm
splitter_friction_grip_h = 8.0;         // contact above tray floor, mm
splitter_friction_lead_h = 3.0;         // insertion chamfer height, mm
// The enclosure is vertically symmetric: equal lower/upper bevel traversals
// around the measured 23/32 in straight side band. Preserving the measured
// 15/16 in overall height makes each bevel 7/64 in (2.778125 mm).
splitter_flat_side_h = 18.25625;
splitter_bevel_h = (splitter_h - splitter_flat_side_h) / 2;
splitter_lower_bevel_h = splitter_bevel_h;
splitter_upper_bevel_h = splitter_bevel_h;
splitter_side_bevel_inset = (splitter_w - splitter_top_flat_w) / 2;
splitter_lower_bevel_inset = splitter_side_bevel_inset;
splitter_upper_bevel_inset = splitter_side_bevel_inset;
splitter_upper_end_bevel_inset =
    (splitter_d - splitter_top_flat_d) / 2;
splitter_lan_local_x = 15.7;
splitter_dc_local_x = 37.3;
splitter_input_local_x = 31.9;
splitter_x = 13.0;
stacked_splitter_output_x = core_width / 2 + splitter_d / 2;
// Production default is the cable-friendly 60 mm setback. Viewer builds can
// override this to compare closer layouts without changing printable exports.
splitter_y_override = undef;
front_left_splitter_y = 89.0;
stacked_splitter_y = green_y + green_d + 25.0 + 21.0
                     - splitter_lan_local_x;
splitter_y = !is_undef(splitter_y_override)
    ? splitter_y_override
    : (stacked_center_layout
        ? stacked_splitter_y
        : front_ethernet_enabled && front_keystone_side == "left"
        ? front_left_splitter_y : 60.0);

// Approximate port centers used only for viewer cable mockups.
splitter_lan_x = splitter_x + splitter_lan_local_x;
splitter_dc_x = splitter_x + splitter_dc_local_x;
splitter_device_z = unified_deck_raise + base_thickness;
splitter_port_z = splitter_device_z + splitter_h / 2;
splitter_input_x = splitter_x + splitter_input_local_x;
splitter_input_y = splitter_y + splitter_d;

green_power_x = green_x + 11.0;
green_ethernet_x = green_x + 98.0;
green_port_y = green_y + green_d;
green_port_z = green_device_z + 12.0;

// Preview-only straight-connector planning envelopes. The RJ45 values model
// an ordinary molded straight plug and the published 21 mm minimum bend radius
// of Ubiquiti's current UACC-Cable-Patch. TP-Link does not publish the included
// DC jumper geometry, so its values are intentionally conservative.
ethernet_plug_depth = 25.0;
ethernet_bend_radius = 21.0;
ethernet_cable_diameter = 5.0;
dc_plug_depth = 22.0;
dc_bend_radius = 10.0;
dc_cable_diameter = 3.2;
// Preview cable lanes deliberately separate the two jumpers in X and Z so
// they neither overlap one another nor pass through the device trays.
ethernet_cable_lane_x = 78.0;
dc_cable_lane_x = 72.5;
ethernet_route_z = green_port_z;
dc_route_z = splitter_port_z;
ethernet_cross_y = 163.0;
dc_cross_y = 164.5;
cable_surface_clearance = 0.80;

// Front bend radii are collision-clamped against the rear face of the 3 mm
// panel. Compact/Balanced therefore render without intersections while still
// exposing their too-tight bend radii; Cable-friendly retains the full 21 mm.
ethernet_front_bend_radius = min(
    ethernet_bend_radius,
    splitter_y - ethernet_plug_depth - face_thickness
        - ethernet_cable_diameter / 2 - cable_surface_clearance);
dc_front_bend_radius = min(
    dc_bend_radius,
    splitter_y - dc_plug_depth - face_thickness
        - dc_cable_diameter / 2 - cable_surface_clearance);

wall_thickness = 2.5;
outer_corner_r = 3.0;
tray_corner_r = 4.0;
small_end_r = 1.2;
epsilon = 0.02;

// Physical printed depth for the active splitter placement. The Green sets a
// 119.8 mm floor; the splitter sets the deeper Balanced/Cable-friendly values.
mount_depth = stacked_center_layout
    ? max(119.8,
          splitter_y + splitter_w + splitter_clearance + wall_thickness)
    : max(119.8,
          splitter_y + splitter_d + splitter_clearance + wall_thickness);

// SICSOLINK SL-FLQ-POE48K viewer-only geometry. The 40-degree mirrored
// placement preserves the earlier cable-safe layout: captive outputs sit near
// the Green's rear ports and the PoE input aims diagonally toward rack rear.
sics_w = 21.0;
sics_d = 80.0;
sics_h = 28.0;
sics_angle = 40.0;
sics_output_x = 80.0;
sics_output_y = 130.0;
sics_input_x = sics_output_x - sin(sics_angle) * sics_d;
sics_input_y = sics_output_y + cos(sics_angle) * sics_d;
sics_data_exit_x = sics_output_x + cos(sics_angle) * 3.0;
sics_data_exit_y = sics_output_y + sin(sics_angle) * 3.0;
sics_dc_exit_x = sics_output_x - cos(sics_angle) * 3.0;
sics_dc_exit_y = sics_output_y - sin(sics_angle) * 3.0;
sics_mount_depth = 202.0;
active_mount_depth = splitter_model == "sics"
    ? sics_mount_depth : mount_depth;

// Keep the badge visually opposite the optional front jack. The left-jack
// edition shifts it right to open a more comfortable gap between parts.
logo_center_x = front_ethernet_enabled && front_keystone_side == "left"
    ? 50.0 : 46.0;
logo_center_z = 21.5;

// Proven community keystone opening proportions. The larger rear relief
// leaves a 1.5 mm front latch land in the 3 mm faceplate.
front_keystone_x = front_keystone_side == "far_right"
    ? 210.25
    : (front_keystone_side == "right" ? 77.0 : 25.0);
front_keystone_z = rack_height / 2;
front_keystone_w = 15.0;
front_keystone_h = 16.0;
front_keystone_rear_h = 22.25;
front_keystone_latch_land = 1.50;
front_keystone_body_depth = 31.0;  // conservative viewer planning envelope

// Front status-window geometry. The three preview LEDs are intentionally an
// approximate visual simulation: official documentation identifies their
// white/green/yellow roles but does not publish a mechanical LED drawing.
led_window_w = 92.0;
led_window_h = 8.0;
led_window_x = green_x + (green_inner_w - led_window_w) / 2;
led_window_z = 10.0 + green_standoff;
// Image-derived LED offsets are referenced to the enclosure center, not its
// measured lower-left edge. This preserves their visual alignment when the
// physical bottom-width estimate changes; caliper measurements can replace
// these approximate center offsets later.
led_status_x = [green_x + green_w / 2 - 10.46875,
                green_x + green_w / 2 + 1.43125,
                green_x + green_w / 2 + 13.53125];
led_status_y = green_y - 0.40;
led_status_z = led_window_z + led_window_h / 2;

// Captive LED-window shutter. A fixed flush lens stays in the face while a
// white PETG blade moves vertically behind it. The front actuator is coplanar
// with the rack face, so neither state adds an embossed feature.
led_lens_body_depth = 1.10;
led_lens_flange_y = 0.85;
led_lens_flange_depth = 0.35;
led_shutter_y = 1.40;
led_shutter_t = 1.00;
led_shutter_w = 95.0;
led_shutter_h = 10.0;
led_shutter_x = led_window_x - (led_shutter_w - led_window_w) / 2;
led_shutter_closed_z = led_window_z
    - (led_shutter_h - led_window_h) / 2;
led_shutter_travel = 11.0;
led_shutter_open_z = led_shutter_closed_z + led_shutter_travel;
led_actuator_x = 193.0;
led_actuator_w = 6.0;
led_actuator_h = 5.5;
led_actuator_z_offset = 2.25;
led_retainer_x0 = 95.5;
led_retainer_x1 = 200.5;
led_reference_z_shift = led_window_z - 16.025;
led_retainer_z0 = 13.5 + led_reference_z_shift;
led_retainer_z1 = 37.5 + led_reference_z_shift;
led_pocket_z0 = 13.25 + led_reference_z_shift;
led_lens_seat_z = 13.825 + led_reference_z_shift;
led_actuator_slot_z = 17.025 + led_reference_z_shift;
led_snap_z = 31.0 + led_reference_z_shift;
led_retainer_opening_z0 = 14.775 + led_reference_z_shift;
led_retainer_backplate_z = 24.30 + led_reference_z_shift;
led_retainer_y0 = 1.25;
led_retainer_y1 = 4.15;
led_window_center_x = led_window_x + led_window_w / 2;
far_right_front = front_ethernet_enabled
    && front_keystone_side == "far_right";

// The 3 mm-deep honeycomb preserves most heatsink airflow while connecting
// the Green's perimeter ring across both axes to resist tray racking/twist.
green_honeycomb_pitch = 15.0;
green_honeycomb_wall = 1.8;
green_honeycomb_inset = 5.0;
green_screw_pad_r = 7.0;
friction_lower_honeycomb_wall = 1.20;
friction_honeycomb_transition_h = 0.50;
friction_honeycomb_top_h = 2.50;
splitter_honeycomb_pitch = 10.0;
splitter_honeycomb_wall = 1.6;
splitter_honeycomb_side_inset = 6.0;
splitter_honeycomb_end_inset = 5.0;

// Viewer-only rear-loading device sleeves inspired by the UCG-Fiber, USW-Lite,
// and Mauker Chromebox rack cases. Thin honeycomb floors/roofs are joined by
// thick rounded side frames with large capsule-shaped ventilation openings.
sleeve_roof_t = 1.60;
sleeve_green_interference = 0.10;
sleeve_green_vertical_interference = 0.40;
sleeve_green_frame_t = 2.40;
sleeve_green_roof_pitch = 15.0;
sleeve_green_roof_wall = 1.80;
sleeve_splitter_roof_pitch = 10.0;
sleeve_splitter_roof_wall = 1.60;
sleeve_roof_border = 5.0;
sleeve_green_frame_end_border = 8.0;
sleeve_splitter_frame_end_border = 7.0;
sleeve_green_frame_open_z = 15.0;
sleeve_green_frame_open_h = 21.0;
sleeve_splitter_frame_open_z = 9.0;
sleeve_splitter_frame_open_h = 13.0;
vent_frame_coupon_depth = 5.0;
vent_frame_coupon_spacing = 8.0;

// Optional rear dovetail gates for the rounded vent-frame cages. The wide
// buried head carries rearward pullout load while a blind-bottom track and
// short close-clearance zone keep each removable H-gate seated without screws.
dovetail_depth = 2.80;
dovetail_neck_w = 2.60;
dovetail_head_w = 5.80;
dovetail_running_clearance = 0.25;
dovetail_lock_clearance = 0.10;
dovetail_receiver_wall = 1.20;
dovetail_receiver_overlap = 0.80;
dovetail_bottom_stop_h = 1.20;
dovetail_stop_clearance = 0.05;
dovetail_lock_h = 7.0;
dovetail_top_lead_h = 2.0;
dovetail_top_lead_extra = 0.35;
dovetail_gate_t = 2.40;
dovetail_gate_post_w = 6.20;
dovetail_gate_bar_h = 3.20;
dovetail_gate_contact_gap = 0.10;
dovetail_coupon_h = 28.0;
dovetail_coupon_spacing = 5.0;

// Viewer-only open protective shell. Thin point-up honeycomb shear walls add
// stiffness and edge protection without consuming the Green's 1U top gap.
// Two millimeters equals five 0.4 mm extrusion lines and keeps the concept
// materially lighter than a lid or full cage.
airframe_wall_t = 2.0;
airframe_honeycomb_pitch = 15.0;
airframe_honeycomb_wall = 1.8;
airframe_border = 3.5;
airframe_corner_r = 1.6;

// Viewer-only screwless-retention studies. These dimensions intentionally
// expose the mechanism and are not production fits: Home Assistant publishes
// the Green's overall envelope, but not the lower heatsink ledge geometry.
// The concepts therefore remain visual until a rail/latch coupon is checked
// against the user's physical unit.
retention_accent_z0 = green_device_z - 0.85;
retention_ledge_z = green_device_z + 3.80;
retention_wall_h = retention_ledge_z - retention_accent_z0 + 1.15;
retention_segment_y = [green_y + 13.0, green_y + 77.0];
retention_segment_len = 20.0;
retention_side_wall = 2.4;
retention_lip_overlap = 1.0;
retention_latch_len = 28.0;
retention_latch_t = 1.8;

// Whole-tray friction fit.  This is deliberately small because two continuous
// walls accumulate substantially more insertion force than localized ribs.
// Tune only after printing the three-gap coupon against the actual enclosure.
friction_interference = 0.10;     // inward movement per side, mm
friction_lead_relief = 0.60;      // opening gained per side at wall top, mm
friction_grip_h = 8.0;            // straight contact above device bottom, mm
friction_lead_h = 3.0;            // printable insertion chamfer height, mm

// Viewer-only top-catch study. The Green retains one releasable side because
// its nearly full-1U height leaves little room to maneuver. The shorter
// TP-Link uses four rigid, mirrored catches on continuous walls as requested.
hybrid_green_guide_interference = 0.20;
hybrid_green_cover_clearance = 0.35;
hybrid_green_lower_grip_h = 2.50;
hybrid_green_transition_h = 1.50;
hybrid_green_clip_len = 18.0;
hybrid_green_clip_center_offset = 25.0;
hybrid_green_clip_clearance = 0.30;
hybrid_green_top_overlap = 1.20;
hybrid_green_catch_flat = 1.40;      // starts 0.20 mm outside the top edge
hybrid_green_clip_reach = green_cover_top_inset
                          + hybrid_green_cover_clearance
                          + hybrid_green_top_overlap;
hybrid_green_catch_nose_t = 0.80;    // four 0.2 mm layers at the shoulder
hybrid_green_catch_tip_t = 0.40;     // two-layer minimum leading edge
hybrid_green_catch_tip_bevel = 0.40; // 45-degree support-free lead-in
hybrid_green_top_ramp_h = 1.225;
hybrid_green_fixed_arm_t = 2.4;
hybrid_green_spring_arm_t = 2.8;
hybrid_green_window_margin = 1.0;
hybrid_splitter_clip_len = 14.0;
hybrid_splitter_clip_center_offset = 20.0;
hybrid_splitter_clip_clearance = 0.00;
hybrid_splitter_tower_t = 1.20;
hybrid_splitter_top_overlap = 1.20;
hybrid_splitter_catch_flat = 1.40;    // starts 0.20 mm outside the top edge
hybrid_splitter_clip_reach = splitter_upper_bevel_inset
                             - splitter_friction_interference
                             + hybrid_splitter_top_overlap;
hybrid_splitter_catch_nose_t = 0.80;
hybrid_splitter_catch_tip_t = 0.40;
hybrid_splitter_catch_tip_bevel = 0.40;

module rounded_rect_2d(w, h, r) {
    hull() {
        translate([r, r]) circle(r = r);
        translate([w-r, r]) circle(r = r);
        translate([r, h-r]) circle(r = r);
        translate([w-r, h-r]) circle(r = r);
    }
}

// Rounded toward the rack face, square at the rear-loading opening. Using the
// same outline for cage floors, roofs, and side-wall clipping prevents the
// horizontal panels from appearing to jut past the walls at the rear corners.
module front_rounded_rect_2d(w, d, r) {
    union() {
        translate([0, r]) square([w, d - r]);
        translate([r, 0]) square([w - 2 * r, r]);
        translate([r, r]) circle(r = r);
        translate([w - r, r]) circle(r = r);
    }
}

// Extrude an X/Z wall profile through Y. Keeping tapered guide walls as one
// polygon avoids coplanar hull seams and stays fast in the Manifold backend.
module extrude_xz_profile_y(points, y0, length) {
    translate([0, y0 + length, 0])
        rotate([90, 0, 0])
            linear_extrude(height = length)
                polygon(points = points);
}

// Viewer-only approximation for enclosures whose straight side band is
// bounded by lower and upper bevels. Thin overlapping slices keep the mockup
// manifold while making the contact assumptions visible in the browser.
module beveled_rounded_box(
    w, d, h, r,
    lower_bevel_h = 0.8,
    upper_bevel_h = 1.8,
    lower_inset = 0.8,
    upper_inset = 1.0,
    lower_inset_x = undef,
    lower_inset_y = undef,
    upper_inset_x = undef,
    upper_inset_y = undef) {
    slice_h = 0.08;
    middle_h = h - lower_bevel_h - upper_bevel_h;
    lower_x = is_undef(lower_inset_x) ? lower_inset : lower_inset_x;
    lower_y = is_undef(lower_inset_y) ? lower_inset : lower_inset_y;
    upper_x = is_undef(upper_inset_x) ? upper_inset : upper_inset_x;
    upper_y = is_undef(upper_inset_y) ? upper_inset : upper_inset_y;
    lower_r = max(0.8, r - min(lower_x, lower_y));
    upper_r = max(0.8, r - min(upper_x, upper_y));

    assert(middle_h > 0, "Beveled mockup needs a positive straight band");
    assert(2 * lower_x < w && 2 * lower_y < d,
           "Lower bevel inset exceeds the enclosure footprint");
    assert(2 * upper_x < w && 2 * upper_y < d,
           "Upper bevel inset exceeds the enclosure footprint");
    union() {
        hull() {
            translate([lower_x, lower_y, 0])
                linear_extrude(height = slice_h)
                    rounded_rect_2d(
                        w - 2 * lower_x,
                        d - 2 * lower_y,
                        lower_r);
            translate([0, 0, lower_bevel_h - slice_h])
                linear_extrude(height = slice_h)
                    rounded_rect_2d(w, d, r);
        }
        translate([0, 0, lower_bevel_h - epsilon])
            linear_extrude(height = middle_h + 2 * epsilon)
                rounded_rect_2d(w, d, r);
        hull() {
            translate([0, 0, h - upper_bevel_h])
                linear_extrude(height = slice_h)
                    rounded_rect_2d(w, d, r);
            translate([upper_x, upper_y, h - slice_h])
                linear_extrude(height = slice_h)
                    rounded_rect_2d(
                        w - 2 * upper_x,
                        d - 2 * upper_y,
                        upper_r);
        }
    }
}

// Viewer approximation of the measured Green shell. The 111.125 mm lower/body
// width remains straight for 6.35 mm, then tapers continuously to the measured
// 107.95 mm top plateau. The published 112 mm figure remains documentation and
// is not used as an active mockup cross-section.
module green_device_mock_local() {
    top_inset_x = (green_w - green_top_w) / 2;
    top_inset_y = (green_d - green_top_d) / 2;
    straight_h = green_taper_start_h;
    slice_h = 0.08;

    union() {
        linear_extrude(height = straight_h + epsilon)
            rounded_rect_2d(green_w, green_d, 4.0);
        hull() {
            translate([0, 0, straight_h])
                linear_extrude(height = slice_h)
                    rounded_rect_2d(green_w, green_d, 4.0);
            translate([
                top_inset_x, top_inset_y,
                green_h - slice_h
            ]) linear_extrude(height = slice_h)
                    rounded_rect_2d(
                        green_top_w, green_top_d,
                        max(0.8, 4.0 - min(top_inset_x, top_inset_y)));
        }
    }
}

// The far-right front jack sits beyond the Green. Mirroring the cartridge
// moves its flush actuator to the window's left side and leaves a generous
// solid web between the shutter pocket and keystone opening.
module led_cartridge_transform() {
    if (far_right_front)
        translate([2 * led_window_center_x, 0, 0])
            mirror([1, 0, 0]) children();
    else
        children();
}

module selective_rounded_rect_2d(w, h, r,
                                 round_left = true,
                                 round_right = true) {
    union() {
        translate([round_left ? r : 0, 0])
            square([w - (round_left ? r : 0)
                      - (round_right ? r : 0), h]);
        if (round_left) {
            translate([0, r]) square([r, h - 2 * r]);
            translate([r, r]) circle(r = r);
            translate([r, h - r]) circle(r = r);
        }
        if (round_right) {
            translate([w - r, r]) square([r, h - 2 * r]);
            translate([w - r, r]) circle(r = r);
            translate([w - r, h - r]) circle(r = r);
        }
    }
}

module rounded_prism_z(w, d, h, r) {
    linear_extrude(height = h)
        rounded_rect_2d(w, d, min(r, min(w, d) / 2));
}

// Extrude a 2D X/Z profile through Y from y0 to y0+depth.
module extrude_y(y0, depth) {
    translate([0, y0 + depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = depth)
                children();
}

module capsule_2d(w, h) {
    hull() {
        translate([-(w-h)/2, 0]) circle(d = h);
        translate([(w-h)/2, 0]) circle(d = h);
    }
}

module hole_along_y(x, y, z, depth, diameter) {
    translate([x, y, z])
        rotate([-90, 0, 0])
            cylinder(h = depth, d = diameter);
}

module rack_slot(x, z) {
    translate([x, face_thickness + epsilon, z])
        rotate([90, 0, 0])
            linear_extrude(height = face_thickness + 2 * epsilon)
                capsule_2d(rack_slot_w, rack_slot_h);
}

// Flat-top hexagonal openings on a true hex grid. `pitch` is the notional
// cell's flat-to-flat spacing; the smaller cut hex leaves `wall` between
// adjacent openings.
module honeycomb_openings_2d(w, h, pitch, wall) {
    cell_r = pitch / sqrt(3);
    hole_r = (pitch - wall) / sqrt(3);
    pitch_x = 1.5 * cell_r;
    column_extent = ceil(w / pitch_x) + 2;
    row_extent = ceil(h / pitch) + 2;

    // Clip the outer cells against the safe aperture instead of dropping the
    // whole boundary row. The solid frame outside this mask closes every rib,
    // so the lattice reaches the perimeter cleanly without fragile slivers.
    intersection() {
        square([w, h]);
        for (column = [-column_extent : column_extent])
            for (row = [-row_extent : row_extent])
                translate([
                    w / 2 + column * pitch_x,
                    h / 2 + row * pitch
                        + ((abs(column) % 2) == 1 ? pitch / 2 : 0)
                ]) circle(r = hole_r, $fn = 6);
    }
}

module green_honeycomb_cutouts_2d(
    preserve_screw_pads = true,
    honeycomb_wall_value = green_honeycomb_wall) {
    cut_x = green_x + green_honeycomb_inset;
    cut_y = green_y + green_honeycomb_inset;
    cut_w = green_inner_w - 2 * green_honeycomb_inset;
    cut_d = green_inner_d - 2 * green_honeycomb_inset;

    difference() {
        translate([cut_x, cut_y])
            honeycomb_openings_2d(
                cut_w, cut_d,
                green_honeycomb_pitch, honeycomb_wall_value);

        // Local solid islands spread the four screw/spacer loads into several
        // surrounding ribs instead of requiring a thick solid perimeter.
        // The raised friction deck deliberately disables them so these pads
        // do not become four tall standoffs.
        if (preserve_screw_pads)
            for (x = green_mount_x)
                for (y = green_mount_y)
                    translate([x, y])
                        circle(r = green_screw_pad_r, $fn = 36);
    }
}

// Exact 2D floor shared by the original Green tray and its viewer-only raised
// friction extension. The outer outline, honeycomb registration, and screw
// bores therefore cannot drift between the two versions.
module green_tray_outer_outline_2d() {
    outer_x = green_x - wall_thickness;
    outer_y = face_thickness - 0.20;
    outer_w = green_inner_w + 2 * wall_thickness;
    outer_d = green_inner_d + (green_y - face_thickness) + wall_thickness;

    translate([outer_x, outer_y])
        rounded_rect_2d(outer_w, outer_d, tray_corner_r);
}

module green_tray_floor_2d(
    preserve_screw_pads = true,
    honeycomb_wall_value = green_honeycomb_wall) {
    outer_x = green_x - wall_thickness;
    outer_y = face_thickness - 0.20;
    outer_w = green_inner_w + 2 * wall_thickness;
    outer_d = green_inner_d + (green_y - face_thickness) + wall_thickness;

    difference() {
        green_tray_outer_outline_2d();

        green_honeycomb_cutouts_2d(
            preserve_screw_pads = preserve_screw_pads,
            honeycomb_wall_value = honeycomb_wall_value);

        // Keep the original through-hole registration.  With screw pads
        // disabled these holes merely interrupt an occasional lattice rib;
        // they do not create four raised support columns.
        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y])
                    circle(d = green_mount_hole_d, $fn = 28);
    }
}

module splitter_honeycomb_cutouts_2d() {
    translate([splitter_honeycomb_side_inset,
               splitter_honeycomb_end_inset])
        honeycomb_openings_2d(
            splitter_w - 2 * splitter_honeycomb_side_inset,
            splitter_d - 2 * splitter_honeycomb_end_inset,
            splitter_honeycomb_pitch, splitter_honeycomb_wall);
}

module splitter_tray_outer_outline_2d() {
    outer_x = -splitter_clearance - wall_thickness;
    outer_y = -splitter_clearance - wall_thickness;
    outer_w = splitter_inner_w + 2 * wall_thickness;
    outer_d = splitter_inner_d + 2 * wall_thickness;

    translate([outer_x, outer_y])
        rounded_rect_2d(outer_w, outer_d, tray_corner_r);
}

module green_tray_guides_and_stops() {
    outer_x = green_x - wall_thickness;
    outer_w = green_inner_w + 2 * wall_thickness;
    rear_y = green_y + green_inner_d;

    // Low side guides leave the translucent top and vents open.
    translate([outer_x, green_y - 0.20, base_thickness - 0.20])
        rounded_prism_z(wall_thickness, green_inner_d + 0.20, 8.20,
                        wall_thickness / 2);
    translate([green_x + green_inner_w, green_y - 0.20,
               base_thickness - 0.20])
        rounded_prism_z(wall_thickness, green_inner_d + 0.20, 8.20,
                        wall_thickness / 2);

    // Low front stop catches the Green's base without masking its LEDs.
    translate([outer_x, face_thickness - 0.20, base_thickness - 0.20])
        rounded_prism_z(outer_w,
                        green_y - face_thickness + 0.20,
                        4.20, 0.8);

    // Low rear corner stops sit below the rear connector openings.
    translate([outer_x, rear_y - 0.20, base_thickness - 0.20])
        rounded_prism_z(14.0, wall_thickness + 0.20, 4.20,
                        small_end_r);
    translate([outer_x + outer_w - 14.0, rear_y - 0.20,
               base_thickness - 0.20])
        rounded_prism_z(14.0, wall_thickness + 0.20, 4.20,
                        small_end_r);
}

module green_tray() {
    union() {
        // Ventilated perimeter support ring.
        linear_extrude(height = base_thickness)
            green_tray_floor_2d(preserve_screw_pads = true);
        green_tray_guides_and_stops();
    }
}

// Single production-tray dispatch point. Keeping the legacy modules intact
// lets old slicer projects and the viewer's side-by-side comparison exports
// request their exact historical geometry, while every printable mount mode
// follows one explicit selection.
module production_green_tray() {
    if (green_tray_style == "standard")
        green_tray();
    else if (green_tray_style == "friction_raised")
        green_tray_friction_raised_local();
    else if (green_tray_style == "friction_full")
        green_tray_friction_full_local();
    else if (green_tray_style == "friction_skeletal")
        green_tray_friction_skeletal_local();
    else
        green_tray_friction_pads_local();
}

module green_spacer() {
    difference() {
        union() {
            cylinder(h = green_standoff, d = green_spacer_od, $fn = 36);
            translate([0, 0, green_standoff])
                cylinder(h = green_spacer_tip_h,
                         d1 = green_spacer_od,
                         d2 = green_spacer_bore, $fn = 36);
        }
        translate([0, 0, -epsilon])
            cylinder(h = green_spacer_h + 2 * epsilon,
                     d = green_spacer_bore, $fn = 28);
    }
}

module installed_green_spacers(x_offset = 0) {
    for (x = green_mount_x)
        for (y = green_mount_y)
            translate([x_offset + x, y, base_thickness]) green_spacer();
}

module green_spacers_4x() {
    for (x = [0, 11.0])
        for (y = [0, 11.0])
            translate([x + green_spacer_od / 2,
                       y + green_spacer_od / 2, 0])
                green_spacer();
}

module splitter_transform() {
    if (stacked_center_layout)
        translate([stacked_splitter_output_x,
                   splitter_y,
                   unified_deck_raise])
            rotate([0, 0, 90]) children();
    else
        translate([splitter_x, splitter_y, unified_deck_raise])
            children();
}

module splitter_side_wall_left_local(
    interference = splitter_friction_interference) {
    outer_left = -splitter_clearance - wall_thickness;
    inner_left = interference;
    wall_y = -splitter_clearance - wall_thickness;
    wall_d = splitter_inner_d + 2 * wall_thickness;
    wall_z = base_thickness - 0.20;
    bevel_top = base_thickness + splitter_lower_bevel_h;
    grip_top = base_thickness + splitter_friction_grip_h;
    lead_top = grip_top + splitter_friction_lead_h;
    lower_inner_left = inner_left + splitter_lower_bevel_inset;

    intersection() {
        // Follow the measured lower bevel from the narrow bottom plateau to
        // the full-width straight side band. The top retreats again for a
        // support-free insertion lead-in.
        extrude_xz_profile_y([
            [outer_left, wall_z],
            [lower_inner_left, wall_z],
            [inner_left, bevel_top],
            [inner_left, grip_top],
            [inner_left - splitter_friction_lead_relief, lead_top],
            [outer_left, lead_top]
        ], wall_y, wall_d);

        // Clip the complete wall profile to the floor's exact 4 mm rounded
        // silhouette. Matching rectangular bounds alone left tiny corner ears.
        translate([0, 0, wall_z])
            linear_extrude(height = lead_top - wall_z)
                splitter_tray_outer_outline_2d();
    }
}

module splitter_side_wall_right_local(
    interference = splitter_friction_interference) {
    outer_right = splitter_w + splitter_clearance + wall_thickness;
    inner_right = splitter_w - interference;
    wall_y = -splitter_clearance - wall_thickness;
    wall_d = splitter_inner_d + 2 * wall_thickness;
    wall_z = base_thickness - 0.20;
    bevel_top = base_thickness + splitter_lower_bevel_h;
    grip_top = base_thickness + splitter_friction_grip_h;
    lead_top = grip_top + splitter_friction_lead_h;
    lower_inner_right = inner_right - splitter_lower_bevel_inset;

    intersection() {
        extrude_xz_profile_y([
            [lower_inner_right, wall_z],
            [outer_right, wall_z],
            [outer_right, lead_top],
            [inner_right + splitter_friction_lead_relief, lead_top],
            [inner_right, grip_top],
            [inner_right, bevel_top]
        ], wall_y, wall_d);

        translate([0, 0, wall_z])
            linear_extrude(height = lead_top - wall_z)
                splitter_tray_outer_outline_2d();
    }
}

module splitter_side_walls_local(
    interference = splitter_friction_interference) {
    splitter_side_wall_left_local(interference);
    splitter_side_wall_right_local(interference);
}

module splitter_end_stops_local(
    interference = splitter_friction_interference,
    include_front = true,
    include_rear = true) {
    outer_y = -splitter_clearance - wall_thickness;
    outer_d = splitter_inner_d + 2 * wall_thickness;
    inner_left = interference;
    inner_right = splitter_w - interference;
    wall_overlap = 0.20;
    stop_w = 9.20;
    stop_z = base_thickness - 0.20;
    stop_h = 7.0 - stop_z;
    silhouette_margin = 0.20;
    longitudinal_clearance = 0.15;
    front_y = outer_y + silhouette_margin;
    front_d = -longitudinal_clearance - front_y;
    rear_y = splitter_d + longitudinal_clearance;
    rear_d = outer_y + outer_d - silhouette_margin - rear_y;
    left_x = inner_left - wall_overlap;
    right_x = inner_right - (stop_w - wall_overlap);

    // Four low corner stops prevent fore/aft walking without closing either
    // connector end. Their Z=7.0 tops remain below every modeled RJ45, DC,
    // and selector envelope, and their rounded end corners stay inside the
    // floor's R4 silhouette.
    for (x0 = [left_x, right_x]) {
        if (include_front)
            translate([x0, front_y, stop_z])
                rounded_prism_z(stop_w, front_d, stop_h, 1.0);
        if (include_rear)
            translate([x0, rear_y, stop_z])
                rounded_prism_z(stop_w, rear_d, stop_h, 1.0);
    }
}

module splitter_tray_floor_2d() {
    difference() {
        splitter_tray_outer_outline_2d();
        splitter_honeycomb_cutouts_2d();
    }
}

module splitter_tray() {
    splitter_transform()
        union() {
            linear_extrude(height = base_thickness)
                splitter_tray_floor_2d();
            splitter_side_walls_local();
            splitter_end_stops_local();
        }
}

// Viewer base without side walls. The normal walls are a separate material so
// the hybrid-retention view can replace them with its integrated clip walls.
module splitter_tray_without_side_walls() {
    splitter_transform()
        union() {
            linear_extrude(height = base_thickness)
                splitter_tray_floor_2d();
            splitter_end_stops_local();
        }
}

// Extrude a Z/Y structural profile through X. These ribs are deliberately
// bounded below the straight-plug envelopes and use only vertical or
// 45-degree surfaces for support-free faceplate-down printing.
module reinforcement_extrude_x(x0, thickness) {
    translate([x0 + thickness, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = thickness)
                children();
}

module splitter_spine_reinforcement_local(spine_x, spine_w, spine_y0) {
    rib_t = 2.0;
    rib_z0 = unified_deck_raise + base_thickness - 0.20;
    rib_top = unified_deck_raise + 8.0;
    taper_run = rib_top - rib_z0;
    taper_y0 = splitter_y - taper_run;
    knee_top = unified_deck_raise + 14.0;
    knee_run = knee_top - rib_top;

    for (x0 = [spine_x, spine_x + spine_w - rib_t]) {
        // Two edge flanges turn the flat 12 mm neck into a shallow U-channel.
        // Each flange tapers to the floor before the splitter body begins.
        reinforcement_extrude_x(x0, rib_t)
            polygon(points = [
                [rib_z0, spine_y0],
                [rib_top, spine_y0],
                [rib_top, taper_y0],
                [rib_z0, splitter_y]
            ]);

        // Compact 45-degree knees reinforce the face/spine root. Their upper
        // edge is kept below the compact layout's lowest cable envelope.
        reinforcement_extrude_x(x0, rib_t)
            polygon(points = [
                [rib_top - 0.20, spine_y0],
                [knee_top, spine_y0],
                [rib_top - 0.20, spine_y0 + knee_run + 0.20]
            ]);
    }
}

module device_bridge_web_2d(
    y0, web_d, bridge_x, bridge_w) {
    // A straight web with only the 0.20 mm manifold overlap at each end. Its
    // long visible edges terminate directly against the two inner tray walls;
    // there are no rounded landing blocks extending into either tray floor.
    translate([bridge_x, y0])
        square([bridge_w, web_d]);
}

module side_by_side_device_bridges() {
    splitter_outer_right = splitter_x + splitter_w + splitter_clearance
                           + wall_thickness;
    green_outer_left = green_x - wall_thickness;
    splitter_outer_front = splitter_y - splitter_clearance - wall_thickness;
    splitter_outer_rear = splitter_y + splitter_d + splitter_clearance
                          + wall_thickness;
    green_outer_front = face_thickness - 0.20;
    green_outer_rear = green_y + green_inner_d + wall_thickness;
    bridge_x = splitter_outer_right - 0.20;
    bridge_w = green_outer_left - splitter_outer_right + 0.40;
    bridge_target_d = 14.0;
    bridge_pair_gap = 2.0;

    // Keep every web on the straight vertical portion of both rounded tray
    // outlines. This eliminates corner ledges in underside views while the
    // shallow X overlaps keep the complete mount manifold. The front-left
    // layout has 25.9 mm of common straight wall, so its two webs narrow
    // symmetrically to 11.95 mm and retain a clear 2 mm separation.
    bridge_straight_front = max(
        splitter_outer_front + tray_corner_r,
        green_outer_front + tray_corner_r);
    bridge_straight_rear = min(
        splitter_outer_rear - tray_corner_r,
        green_outer_rear - tray_corner_r);
    bridge_available_d = bridge_straight_rear - bridge_straight_front;
    bridge_web_d = min(
        bridge_target_d,
        (bridge_available_d - bridge_pair_gap) / 2);
    bridge_front_y = bridge_straight_front;
    bridge_rear_y = bridge_straight_rear - bridge_web_d;
    bridge_rib_t = 2.4;
    bridge_rib_z0 = unified_deck_raise + base_thickness - 0.20;
    bridge_rib_top = unified_deck_raise + 8.0;
    spine_x = splitter_x + splitter_w / 2 - 6.0;
    spine_w = 12.0;
    spine_y0 = face_thickness - 0.20;

    difference() {
        union() {
            // Two flush-ended webs tie the straight inner walls together
            // without changing either tray's rounded outer silhouette.
            for (y0 = [bridge_front_y, bridge_rear_y])
                translate([0, 0, unified_deck_z0])
                    linear_extrude(height = base_thickness)
                        device_bridge_web_2d(
                            y0, bridge_web_d, bridge_x, bridge_w);

            // A narrow center spine carries rear-patching loads to the face.
            translate([spine_x, spine_y0, unified_deck_z0])
                cube([spine_w, splitter_y - face_thickness + 0.40,
                      base_thickness]);

            splitter_spine_reinforcement_local(
                spine_x, spine_w, spine_y0);

            // A low return flange on the rear edge turns each flat bridge web
            // into an L-beam. It avoids the central zip slot and remains below
            // the DC and Ethernet cable envelopes in every TP-Link layout.
            // Its 0.20 mm overlaps point inward into each tray, guaranteeing a
            // manifold union without extending beyond either outer silhouette.
            for (y0 = [bridge_front_y, bridge_rear_y])
                translate([bridge_x,
                           y0 + bridge_web_d - bridge_rib_t,
                           bridge_rib_z0])
                    rounded_prism_z(
                        bridge_w, bridge_rib_t,
                        bridge_rib_top - bridge_rib_z0, 0.65);
        }

        // Optional 2.5 mm zip-tie slots for the short DC and LAN jumpers.
        for (y0 = [
            bridge_front_y + (bridge_web_d - 3.2) / 2,
            bridge_rear_y + (bridge_web_d - 3.2) / 2
        ])
            translate([bridge_x + (bridge_w - 7.5) / 2, y0,
                       unified_deck_z0 - epsilon])
                cube([7.5, 3.2, base_thickness + 2 * epsilon]);
    }
}

module stacked_center_device_bridge() {
    splitter_tray_left = stacked_splitter_output_x
        - (splitter_d + splitter_clearance + wall_thickness);
    splitter_tray_right = stacked_splitter_output_x
        + splitter_clearance + wall_thickness;
    splitter_tray_front = splitter_y
        - splitter_clearance - wall_thickness;
    green_tray_rear = green_y + green_inner_d + wall_thickness;
    bridge_x = splitter_tray_left - 0.20;
    bridge_y = green_tray_rear - 0.20;
    bridge_w = splitter_tray_right - splitter_tray_left + 0.40;
    bridge_d = splitter_tray_front - green_tray_rear + 0.40;
    flange_t = 2.40;
    flange_z0 = 1.20;

    assert(bridge_d > 8.0,
           "Centered stacked bridge needs a positive cable bay");

    // The short honeycomb bridge lands flush with both raised floors. Three
    // deep longitudinal return flanges resist sag without filling the volume
    // below the common 9.025 mm device seating plane.
    translate([0, 0, unified_deck_z0])
        linear_extrude(height = base_thickness)
            difference() {
                translate([bridge_x, bridge_y])
                    rounded_rect_2d(bridge_w, bridge_d, 2.5);
                translate([bridge_x + 5.0, bridge_y + 4.0])
                    honeycomb_openings_2d(
                        bridge_w - 10.0, bridge_d - 8.0,
                        12.0, 1.8);
            }

    for (x = [
        bridge_x + 1.20,
        (splitter_tray_left + splitter_tray_right) / 2 - flange_t / 2,
        bridge_x + bridge_w - flange_t - 1.20
    ])
        translate([x, bridge_y, flange_z0])
            cube([
                flange_t,
                bridge_d,
                unified_deck_z0 + base_thickness - flange_z0
            ]);
}

module device_bridges() {
    if (stacked_center_layout) stacked_center_device_bridge();
    else side_by_side_device_bridges();
}

module sics_transform() {
    translate([sics_output_x, sics_output_y, 0])
        rotate([0, 0, sics_angle])
            translate([-sics_w / 2, 0, 0])
                children();
}

module sics_tray_mock() {
    // Viewer-only cradle matching the cable-valid angled placement. It is not
    // included in any production STL until the actual unit is measured.
    sics_transform()
        union() {
            translate([-2.5, -2.5, 0])
                rounded_prism_z(sics_w + 5.0, sics_d + 5.0,
                                base_thickness, 3.0);

            for (y0 = [7.0, 59.0]) {
                translate([-2.5, y0, base_thickness - 0.2])
                    rounded_prism_z(2.5, 14.0, 10.0, small_end_r);
                translate([sics_w, y0, base_thickness - 0.2])
                    rounded_prism_z(2.5, 14.0, 10.0, small_end_r);
            }
        }
}

module sics_bridge_mock() {
    // Broad rectangular pad joins the angled cradle to the Green's rear ring
    // without reintroducing the exposed triangular braces the user disliked.
    translate([75.0, 109.0, 0])
        rounded_prism_z(25.0, 28.0, base_thickness, 3.0);
}

module sics_core_mock() {
    difference() {
        union() {
            cube([core_width, face_thickness, rack_height]);
            production_green_tray();
            sics_tray_mock();
            sics_bridge_mock();
            core_joint_bosses();
        }

        led_window_cut();
        if (led_shutter_enabled) led_shutter_pocket_cut();
        face_logo_cut();
        front_keystone_cut();
        core_joint_pilot_holes();
    }
}

module sics_one_piece_mock() {
    difference() {
        union() {
            extrude_y(0, face_thickness)
                rounded_rect_2d(rack_width, rack_height, outer_corner_r);
            translate([ear_width, 0, 0]) {
                production_green_tray();
                sics_tray_mock();
                sics_bridge_mock();
            }
        }

        for (z = rack_hole_z) {
            rack_slot(rack_hole_x, z);
            rack_slot(rack_width - rack_hole_x, z);
        }

        translate([ear_width, 0, 0]) {
            led_window_cut();
            if (led_shutter_enabled) led_shutter_pocket_cut();
            face_logo_cut();
            front_keystone_cut();
        }
    }
}

// Browser-only immutable shell used when the Green tray is supplied as a
// separately swappable mesh.  Keep the SICS cradle and joining bridge; the
// selected Green tray reconnects to the bridge at the same coordinates.
module sics_one_piece_mock_without_green_tray() {
    difference() {
        union() {
            extrude_y(0, face_thickness)
                rounded_rect_2d(rack_width, rack_height, outer_corner_r);
            translate([ear_width, 0, 0]) {
                sics_tray_mock();
                sics_bridge_mock();
            }
        }

        for (z = rack_hole_z) {
            rack_slot(rack_hole_x, z);
            rack_slot(rack_width - rack_hole_x, z);
        }

        translate([ear_width, 0, 0]) {
            led_window_cut();
            if (led_shutter_enabled) led_shutter_pocket_cut();
            face_logo_cut();
            front_keystone_cut();
        }
    }
}

module core_joint_bosses() {
    for (x0 = [0, core_width - 14.0])
        for (z0 = [5.0, 27.5])
            translate([x0, face_thickness - 0.20, z0])
                cube([14.0, 5.20, 11.0]);
}

module core_joint_pilot_holes() {
    for (x = [7.0, core_width - 7.0])
        for (z = [10.5, 33.0])
            hole_along_y(x, face_thickness - epsilon, z, 5.5 + 2 * epsilon, 2.6);
}

module ha_mark_2d(size = 13.0) {
    // OpenSCAD 2021 imports SVG CSS pixels at 72 dpi (8.4667 mm for 24 px).
    svg_native_size = 24.0 * 25.4 / 72.0;
    translate([logo_center_x - size / 2, logo_center_z - size / 2])
        scale([size / svg_native_size, size / svg_native_size])
            import("assets/home-assistant-logo.svg");
}

module ha_badge_background_2d() {
    // Colored rounded badge with the white faceplate showing through as the HA mark.
    difference() {
        translate([logo_center_x - 10.0, logo_center_z - 10.0])
            rounded_rect_2d(20.0, 20.0, 3.5);
        ha_mark_2d();
    }
}

module face_logo_cut() {
    if (face_logo_enabled)
        translate([0, 0.72, 0])
            rotate([90, 0, 0])
                linear_extrude(height = 0.75)
                    ha_badge_background_2d();
}

module face_logo_inlay() {
    // Front surface lands exactly on Y=0. Print in black/HA-blue to show the
    // badge, or in the same white as the panel for a flat visual blackout.
    translate([0, 0.66, 0])
        rotate([90, 0, 0])
            linear_extrude(height = 0.66)
                ha_badge_background_2d();
}

module led_window_cut() {
    translate([led_window_x, face_thickness + epsilon, led_window_z])
        rotate([90, 0, 0])
            linear_extrude(height = face_thickness + 2 * epsilon)
                rounded_rect_2d(led_window_w, led_window_h,
                                led_window_h / 2);
}

module led_shutter_pocket_cut() {
    led_cartridge_transform() {
        // Rear running pocket leaves 1.15 mm of solid front skin around the
        // lens. This entire pocket exists only in the shutter-equipped
        // edition; the bare-aperture mount keeps its rear face solid.
        translate([95.25, 1.15, led_pocket_z0])
            cube([105.50, face_thickness - 1.15 + epsilon, 24.50]);

        // Slightly deeper local seat for the clear lens flange.
        translate([96.30, 0.82, led_lens_seat_z])
            cube([96.40, face_thickness - 0.82 + epsilon, 12.40]);

        if (led_shutter_enabled)
            // Flush actuator travel slot. The white slider fills this opening
            // without projecting in front of Y=0.
            translate([192.75, -epsilon, led_actuator_slot_z])
                extrude_y(0, face_thickness + 2 * epsilon)
                    rounded_rect_2d(6.50, 17.00, 1.0);

        // Side wells receive the retainer's shallow snap nibs and keep the
        // lens clamp seated rather than relying on the Green's 0.35 mm gap.
        translate([94.90, 2.40, led_snap_z])
            rotate([0, 90, 0]) cylinder(h = 0.60, d = 1.10, $fn = 20);
        translate([200.50, 2.40, led_snap_z])
            rotate([0, 90, 0]) cylinder(h = 0.60, d = 1.10, $fn = 20);
    }
}

module front_keystone_cut(force = false) {
    if (front_ethernet_enabled || force) {
        // Nominal 15 x 16 mm snap opening through the full face.
        translate([front_keystone_x - front_keystone_w / 2,
                   -epsilon,
                   front_keystone_z - front_keystone_h / 2])
            cube([front_keystone_w,
                  face_thickness + 2 * epsilon,
                  front_keystone_h]);

        // Taller rear-only pocket gives the latch room to flex while
        // preserving a 1.5 mm front panel land.
        translate([front_keystone_x - front_keystone_w / 2,
                   front_keystone_latch_land,
                   front_keystone_z - front_keystone_rear_h / 2])
            cube([front_keystone_w,
                  face_thickness - front_keystone_latch_land + epsilon,
                  front_keystone_rear_h]);
    }
}

module core() {
    difference() {
        union() {
            cube([core_width, face_thickness, rack_height]);
            production_green_tray();
            splitter_tray();
            device_bridges();
            core_joint_bosses();
        }

        led_window_cut();
        if (led_shutter_enabled) led_shutter_pocket_cut();
        face_logo_cut();
        front_keystone_cut();
        core_joint_pilot_holes();
    }
}

// Optional one-piece version for the X2D main nozzle. At 254 mm wide it is
// nominally inside the 256 mm main-nozzle bed, but leaves only 1 mm per side,
// so center it carefully and do not use a brim. It does not fit the 235.5 mm
// dual-nozzle overlap area; use the split core/ears for that workflow.
module one_piece_mount() {
    difference() {
        union() {
            extrude_y(0, face_thickness)
                rounded_rect_2d(rack_width, rack_height, outer_corner_r);
            translate([ear_width, 0, 0]) {
                production_green_tray();
                splitter_tray();
                device_bridges();
            }
        }

        for (z = rack_hole_z) {
            rack_slot(rack_hole_x, z);
            rack_slot(rack_width - rack_hole_x, z);
        }

        translate([ear_width, 0, 0]) {
            led_window_cut();
            if (led_shutter_enabled) led_shutter_pocket_cut();
            face_logo_cut();
            front_keystone_cut();
        }
    }
}

// Browser-only immutable shell. Both device trays are loaded as separate
// meshes, avoiding overlaps when the UI swaps in wall-integrated clips or the
// rear-loading ventilated sleeves.
module one_piece_mount_without_green_tray() {
    difference() {
        union() {
            extrude_y(0, face_thickness)
                rounded_rect_2d(rack_width, rack_height, outer_corner_r);
            translate([ear_width, 0, 0]) {
                device_bridges();
            }
        }

        for (z = rack_hole_z) {
            rack_slot(rack_hole_x, z);
            rack_slot(rack_width - rack_hole_x, z);
        }

        translate([ear_width, 0, 0]) {
            led_window_cut();
            if (led_shutter_enabled) led_shutter_pocket_cut();
            face_logo_cut();
            front_keystone_cut();
        }
    }
}

module one_piece_logo_inlay() {
    translate([ear_width, 0, 0]) face_logo_inlay();
}

module left_ear() {
    difference() {
        union() {
            extrude_y(0, face_thickness)
                selective_rounded_rect_2d(
                    ear_width, rack_height, outer_corner_r, true, false);
            for (z0 = [5.0, 27.5]) {
                // Neck keeps each rear tongue integral with the ear face.
                translate([ear_width - 4.0, face_thickness - 0.20, z0])
                    cube([4.20, 11.20, 11.0]);
                translate([ear_width - 0.20, 8.0, z0])
                    cube([14.20, 6.0, 11.0]);
            }
        }

        for (z = rack_hole_z)
            rack_slot(rack_hole_x, z);

        for (z = [10.5, 33.0]) {
            hole_along_y(ear_width + 7.0, 7.8, z, 6.5, 3.4);
            hole_along_y(ear_width + 7.0, 11.2, z, 3.2, 6.2);
        }
    }
}

module right_ear() {
    difference() {
        union() {
            translate([rack_width - ear_width, 0, 0])
                extrude_y(0, face_thickness)
                    selective_rounded_rect_2d(
                        ear_width, rack_height, outer_corner_r, false, true);
            for (z0 = [5.0, 27.5]) {
                // Neck keeps each rear tongue integral with the ear face.
                translate([rack_width - ear_width - 0.20,
                           face_thickness - 0.20, z0])
                    cube([4.20, 11.20, 11.0]);
                translate([rack_width - ear_width - 14.0, 8.0, z0])
                    cube([14.20, 6.0, 11.0]);
            }
        }

        for (z = rack_hole_z)
            rack_slot(rack_width - rack_hole_x, z);

        for (z = [10.5, 33.0]) {
            hole_along_y(rack_width - ear_width - 7.0, 7.8, z, 6.5, 3.4);
            hole_along_y(rack_width - ear_width - 7.0, 11.2, z, 3.2, 6.2);
        }
    }
}

module led_lens() {
    fit = 0.20;
    // Fixed colorless/translucent lens. Its nose fills the front opening and
    // the shallow rear flange is trapped by the shutter retainer.
    union() {
        translate([fit, 0, fit])
            extrude_y(0, led_lens_body_depth)
                rounded_rect_2d(
                    led_window_w - 2 * fit,
                    led_window_h - 2 * fit,
                    led_window_h / 2 - fit);
        translate([-2.0, led_lens_flange_y, -2.0])
            extrude_y(0, led_lens_flange_depth)
                rounded_rect_2d(
                    led_window_w + 4.0,
                    led_window_h + 4.0,
                    led_window_h / 2 + 2.0);
    }
}

module led_fixed_lens() {
    fit = 0.08;
    // Shutterless edition: one rear-installed, self-holding lens. The long
    // nose fills the full 3 mm face, six shallow PETG ribs create a light
    // press fit, and the rear flange prevents the lens moving forward.
    union() {
        translate([fit, 0, fit])
            extrude_y(0, face_thickness + 0.25)
                rounded_rect_2d(
                    led_window_w - 2 * fit,
                    led_window_h - 2 * fit,
                    led_window_h / 2 - fit);

        translate([-2.0, face_thickness, -2.0])
            extrude_y(0, 0.40)
                rounded_rect_2d(
                    led_window_w + 4.0,
                    led_window_h + 4.0,
                    led_window_h / 2 + 2.0);

        // Short interference ribs are easier to tune than a full 92 mm-long
        // press-fit edge and remain replaceable after a test print.
        for (x = [18.0, 46.0, 74.0])
            for (z = [fit, led_window_h - fit])
                translate([x, 1.0, z])
                    rotate([-90, 0, 0])
                        cylinder(h = 1.60, d = 0.32, $fn = 18);

        // Two rear pads stop the lens escaping during service. The installed
        // Green begins at Y=4.5, leaving 0.45 mm nominal clearance.
        for (x0 = [-1.5, led_window_w - 1.5])
            translate([x0, 3.20, -1.0])
                cube([3.0, 0.85, led_window_h + 2.0]);
    }
}

module led_insert() {
    // Compatibility name retained for existing build files and slicer setups.
    if (led_shutter_enabled) led_lens();
    else led_fixed_lens();
}

module led_shutter(z0 = led_shutter_closed_z) {
    union() {
        // Main blackout blade and its narrow side arm.
        extrude_y(led_shutter_y, led_shutter_t)
            union() {
                translate([led_shutter_x, z0])
                    rounded_rect_2d(
                        led_shutter_w, led_shutter_h, 1.0);
                translate([191.0, z0 + led_actuator_z_offset])
                    rounded_rect_2d(
                        8.0, led_actuator_h, 1.0);
            }

        // Integral front actuator. Its front surface lands exactly on Y=0,
        // leaving a flush white tab rather than a protruding handle.
        extrude_y(0, led_shutter_y + led_shutter_t)
            translate([led_actuator_x, z0 + led_actuator_z_offset])
                rounded_rect_2d(
                    led_actuator_w, led_actuator_h, 1.0);

        // Small PETG detent nib; matching retainer pockets mark open/closed.
        translate([led_shutter_x, led_shutter_y,
                   z0 + led_shutter_h / 2])
            rotate([-90, 0, 0])
                cylinder(h = led_shutter_t, d = 0.70, $fn = 20);
    }
}

module led_shutter_retainer() {
    difference() {
        union() {
            // Side guides run nearly to the Green. Once the Green is installed
            // at Y=4.5 it becomes the cartridge's captive rear backstop.
            translate([led_retainer_x0, led_retainer_y0,
                       led_retainer_z0])
                cube([1.25,
                      led_retainer_y1 - led_retainer_y0,
                      led_retainer_z1 - led_retainer_z0]);
            translate([led_retainer_x1 - 1.25, led_retainer_y0,
                       led_retainer_z0])
                cube([1.25,
                      led_retainer_y1 - led_retainer_y0,
                      led_retainer_z1 - led_retainer_z0]);

            // Bottom stop and rear bearing surfaces.
            translate([led_retainer_x0, led_retainer_y0,
                       led_retainer_z0])
                cube([led_retainer_x1 - led_retainer_x0,
                      led_retainer_y1 - led_retainer_y0, 1.275]);
            translate([led_retainer_x0, 2.60,
                       led_retainer_opening_z0])
                cube([2.5, led_retainer_y1 - 2.60, 9.525]);
            translate([191.0, 2.60, led_retainer_opening_z0])
                cube([led_retainer_x1 - 191.0,
                      led_retainer_y1 - 2.60, 9.525]);

            // Upper backplate supports the shutter in its parked/open state.
            translate([led_retainer_x0, 2.60,
                       led_retainer_backplate_z])
                cube([led_retainer_x1 - led_retainer_x0,
                      led_retainer_y1 - 2.60,
                      led_retainer_z1 - led_retainer_backplate_z]);

            // Shallow opposing snap nibs lock the retainer into the panel
            // wells with about 0.10 mm nominal PETG interference.
            translate([95.15, 2.40, led_snap_z])
                rotate([0, 90, 0])
                    cylinder(h = 0.70, d = 0.70, $fn = 20);
            translate([200.15, 2.40, led_snap_z])
                rotate([0, 90, 0])
                    cylinder(h = 0.70, d = 0.70, $fn = 20);
        }

        // Two shallow seats give tactile clicks at closed and open positions.
        for (zc = [led_shutter_closed_z + led_shutter_h / 2,
                   led_shutter_open_z + led_shutter_h / 2])
            translate([96.75, 1.20, zc])
                rotate([-90, 0, 0])
                    cylinder(h = 3.10, d = 1.10, $fn = 24);
    }
}

module fit_test() {
    // Legacy coarse-clearance coupons retained for compatibility. Use
    // friction_fit_coupon and splitter_fit_coupon for the continuous-wall
    // designs before committing to the full plate.
    union() {
        // 24 mm section of the Green channel.
        difference() {
            translate([0, 0, 0])
                cube([green_inner_w + 2 * wall_thickness, 24.0, base_thickness]);
            translate([10.0, 5.0, -epsilon])
                cube([green_inner_w - 20.0, 14.0, base_thickness + 2 * epsilon]);
        }
        translate([0, 0, base_thickness]) cube([wall_thickness, 24.0, 8.0]);
        translate([green_inner_w + wall_thickness, 0, base_thickness])
            cube([wall_thickness, 24.0, 8.0]);

        // 24 mm section of the former splitter snap channel.
        translate([green_inner_w + 15.0, 0, 0]) {
            cube([splitter_inner_w + 2 * wall_thickness, 24.0, base_thickness]);

            // Mirrors the real cradle's two low output-end retention tabs.
            translate([0, 0, base_thickness - 0.20])
                cube([5.0, wall_thickness, 4.20]);
            translate([splitter_inner_w + 2 * wall_thickness - 5.0, 0,
                       base_thickness - 0.20])
                cube([5.0, wall_thickness, 4.20]);

            translate([0, 5.0, base_thickness])
                cube([wall_thickness, 14.0, splitter_h + 2.4]);
            translate([splitter_inner_w + wall_thickness, 5.0, base_thickness])
                cube([wall_thickness, 14.0, splitter_h + 2.4]);
            translate([0, 5.0, base_thickness + splitter_h
                       + splitter_vertical_clearance])
                cube([wall_thickness + 1.2, 14.0, 1.8]);
            translate([splitter_inner_w + wall_thickness - 1.2, 5.0,
                       base_thickness + splitter_h
                           + splitter_vertical_clearance])
                cube([wall_thickness + 1.2, 14.0, 1.8]);
        }
    }
}

module keystone_fit_test() {
    // Flat-print coupon reproducing the final 3 mm face and 1.5 mm latch land.
    // Keystone bodies vary slightly by vendor, so verify the actual coupler
    // before committing to the full front-entry mount.
    coupon_w = 25.0;
    coupon_h = 32.0;
    difference() {
        rounded_prism_z(coupon_w, coupon_h, face_thickness, 2.0);
        translate([(coupon_w - front_keystone_w) / 2,
                   (coupon_h - front_keystone_h) / 2,
                   -epsilon])
            cube([front_keystone_w, front_keystone_h,
                  face_thickness + 2 * epsilon]);
        translate([(coupon_w - front_keystone_w) / 2,
                   (coupon_h - front_keystone_rear_h) / 2,
                   front_keystone_latch_land])
            cube([front_keystone_w, front_keystone_rear_h,
                  face_thickness - front_keystone_latch_land + epsilon]);
    }
}

module left_ear_print() {
    translate([0, rack_height, 0]) rotate([90, 0, 0]) left_ear();
}

module right_ear_print() {
    translate([0, rack_height, 0]) rotate([90, 0, 0])
        translate([-(rack_width - ear_width - 14.0), 0, 0]) right_ear();
}

module core_face_down_print() {
    // Put the front face directly on the build plate. Original Y (rack
    // depth) becomes print Z, so every raised deck and bridge grows outward
    // from the face instead of beginning as a floating horizontal surface.
    translate([0, rack_height, 0]) rotate([90, 0, 0]) core();
}

module led_lens_print() {
    translate([2.0, 10.0, 0]) rotate([90, 0, 0]) led_insert();
}

module led_insert_print() {
    led_lens_print();
}

module led_shutter_print() {
    // Broad rear face on the bed; the flush actuator grows upward.
    if (far_right_front)
        translate([102.0, 0, 0]) mirror([1, 0, 0])
            led_shutter_print_base();
    else
        led_shutter_print_base();
}

module led_shutter_print_base() {
    translate([0, 0, led_shutter_y + led_shutter_t])
        rotate([-90, 0, 0])
            translate([-led_shutter_x, 0, -led_shutter_closed_z])
                led_shutter(led_shutter_closed_z);
}

module led_shutter_retainer_print() {
    // Rear bearing faces the bed and all guide walls grow upward.
    if (far_right_front)
        translate([105.0, 0, 0]) mirror([1, 0, 0])
            led_shutter_retainer_print_base();
    else
        led_shutter_retainer_print_base();
}

module led_shutter_retainer_print_base() {
    translate([0, 0, led_retainer_y1 - led_retainer_y0])
        rotate([-90, 0, 0])
            translate([-led_retainer_x0, -led_retainer_y0,
                       -led_retainer_z0])
                led_shutter_retainer();
}

module led_shutter_kit() {
    led_lens_print();
    translate([0, 15.0, 0]) led_shutter_print();
    translate([0, 29.0, 0]) led_shutter_retainer_print();
}

module led_fixed_window_kit() {
    translate([2.0, 10.0, 0]) rotate([90, 0, 0]) led_fixed_lens();
}

module x2d_plate() {
    // The core and ears all sit front-face-down. Loose pieces occupy compact
    // rows beside the 220 x 43 mm core footprint, while rack depth grows only
    // in print Z. This keeps the unified raised decks support-free.
    // Green spacers are emitted only for the legacy screw-mounted tray; the
    // friction trays carry the device directly on their integrated support.
    loose_parts_y = 50.0;
    core_face_down_print();
    translate([0, loose_parts_y, 0]) left_ear_print();
    translate([38.0, loose_parts_y, 0]) right_ear_print();
    if (led_shutter_enabled || led_window_insert_enabled)
        translate([78.0, loose_parts_y, 0]) led_lens_print();
    if (led_shutter_enabled) {
        translate([1.0, loose_parts_y + 54.0, 0]) led_shutter_print();
        translate([110.0, loose_parts_y + 54.0, 0])
            led_shutter_retainer_print();
    }
    if (green_tray_style == "standard")
        translate([190.0, loose_parts_y, 0]) green_spacers_4x();
}

module cable_path(points, diameter = 3.0) {
    for (i = [0 : len(points) - 2])
        hull() {
            translate(points[i]) sphere(d = diameter, $fn = 20);
            translate(points[i + 1]) sphere(d = diameter, $fn = 20);
        }
}

function arc_points_xy(center, radius, start_angle, end_angle, z, steps = 16) =
    [for (i = [0 : steps])
        let(a = start_angle + (end_angle - start_angle) * i / steps)
            [center[0] + radius * cos(a),
             center[1] + radius * sin(a), z]];

function arc_points_yz(center, radius, start_angle, end_angle, x,
                       steps = 16) =
    [for (i = [0 : steps])
        let(a = start_angle + (end_angle - start_angle) * i / steps)
            [x, center[0] + radius * cos(a),
                center[1] + radius * sin(a)]];

// A 180-degree cable turn whose diameter may be tilted in X/Z while its
// bend bows toward the rack front in Y. `u` is a unit X/Z diameter vector.
function tilted_half_arc_points(center, radius, u, steps = 24) =
    [for (i = [0 : steps])
        let(a = 180 * i / steps)
            [center[0] - radius * u[0] * cos(a),
             center[1] - radius * sin(a),
             center[2] - radius * u[2] * cos(a)]];

function cubic_bezier_point(p0, p1, p2, p3, t) =
    [for (axis = [0 : 2])
        pow(1 - t, 3) * p0[axis]
        + 3 * pow(1 - t, 2) * t * p1[axis]
        + 3 * (1 - t) * pow(t, 2) * p2[axis]
        + pow(t, 3) * p3[axis]];

function cubic_bezier_points(p0, p1, p2, p3, steps = 16,
                             first_index = 0) =
    [for (i = [first_index : steps])
        cubic_bezier_point(p0, p1, p2, p3, i / steps)];

// Route between two opposite-facing straight plugs through a dedicated X/Z
// lane. Front turns are collision-clamped to the panel; rear turns retain the
// cable's nominal bend radius. Compact/Balanced stay visibly too tight, but no
// cable mesh is allowed to pass through the faceplate or the other jumper.
function opposite_port_route(start_x, start_y, end_x, end_y,
                             lane_x, cross_y, plug_depth,
                             front_bend_radius, rear_bend_radius,
                             start_z, route_z, end_z) =
    let(
        front_exit_y = start_y - plug_depth,
        rear_exit_y = end_y + plug_depth,
        lane_direction = lane_x >= start_x ? 1 : -1,
        front_turn_y = front_exit_y - front_bend_radius,
        rear_turn_y = cross_y - rear_bend_radius,
        ramp_end_y = min(front_exit_y + 24.0, rear_turn_y - 10.0),
        final_control = min(10.0, (rear_turn_y - rear_exit_y) / 2),
        first_front_arc = lane_direction > 0
            ? arc_points_xy(
                [start_x + front_bend_radius, front_exit_y],
                front_bend_radius, 180, 270, start_z)
            : arc_points_xy(
                [start_x - front_bend_radius, front_exit_y],
                front_bend_radius, 0, -90, start_z),
        second_front_arc = lane_direction > 0
            ? arc_points_xy(
                [lane_x - front_bend_radius, front_exit_y],
                front_bend_radius, 270, 360, start_z)
            : arc_points_xy(
                [lane_x + front_bend_radius, front_exit_y],
                front_bend_radius, -90, -180, start_z),
        z_ramp = cubic_bezier_points(
            [lane_x, front_exit_y, start_z],
            [lane_x, front_exit_y + 10.0, start_z],
            [lane_x, ramp_end_y - 10.0, route_z],
            [lane_x, ramp_end_y, route_z], 12, 1),
        final_transition = cubic_bezier_points(
            [end_x, rear_turn_y, route_z],
            [end_x, rear_turn_y - final_control, route_z],
            [end_x, rear_exit_y + final_control, end_z],
            [end_x, rear_exit_y, end_z], 12, 1)
    )
    concat(
        [[start_x, front_exit_y, start_z]],
        first_front_arc,
        [[lane_x - lane_direction * front_bend_radius,
          front_turn_y, start_z]],
        second_front_arc,
        z_ramp,
        [[lane_x, rear_turn_y, route_z]],
        arc_points_xy([lane_x + rear_bend_radius, rear_turn_y],
                      rear_bend_radius, 180, 90, route_z),
        [[end_x - rear_bend_radius, cross_y, route_z]],
        arc_points_xy([end_x - rear_bend_radius, rear_turn_y],
                      rear_bend_radius, 90, 0, route_z),
        final_transition
    );

// Compact's two front loops occupy the same shallow zone. Lift the Ethernet
// cable during its horizontal run so it clears the DC cable in 3D. The 3.7 mm
// front bend remains intentionally orange/invalid in the viewer; this only
// makes the comparison geometry collision-free rather than claiming it is a
// cable-safe production route.
function compact_ethernet_route() =
    let(
        r = ethernet_front_bend_radius,
        front_exit_y = splitter_y - ethernet_plug_depth,
        front_turn_y = front_exit_y - r,
        first_arc = arc_points_xy(
            [splitter_lan_x + r, front_exit_y],
            r, 180, 270, splitter_port_z),
        horizontal_lift = cubic_bezier_points(
            [splitter_lan_x + r, front_turn_y, splitter_port_z],
            [splitter_lan_x + r + 10.0, front_turn_y, splitter_port_z],
            [60.4 - 10.0, front_turn_y, 22.0],
            [60.4, front_turn_y, 22.0], 14, 1),
        second_arc = arc_points_xy(
            [ethernet_cable_lane_x - r, front_exit_y],
            r, 270, 360, 22.0),
        settle = cubic_bezier_points(
            [ethernet_cable_lane_x, front_exit_y, 22.0],
            [ethernet_cable_lane_x, front_exit_y + 6.0, 22.0],
            [ethernet_cable_lane_x, 28.0, green_port_z],
            [ethernet_cable_lane_x, 34.0, green_port_z], 12, 1),
        rear_turn_y = ethernet_cross_y - ethernet_bend_radius
    )
    concat(
        [[splitter_lan_x, front_exit_y, splitter_port_z]],
        first_arc,
        horizontal_lift,
        [[ethernet_cable_lane_x - r, front_turn_y, 22.0]],
        second_arc,
        settle,
        [[ethernet_cable_lane_x, rear_turn_y, green_port_z]],
        arc_points_xy(
            [ethernet_cable_lane_x + ethernet_bend_radius, rear_turn_y],
            ethernet_bend_radius, 180, 90, green_port_z),
        [[green_ethernet_x - ethernet_bend_radius,
          ethernet_cross_y, green_port_z]],
        arc_points_xy(
            [green_ethernet_x - ethernet_bend_radius, rear_turn_y],
            ethernet_bend_radius, 90, 0, green_port_z),
        [[green_ethernet_x,
          green_port_y + ethernet_plug_depth, green_port_z]]
    );

module ethernet_plug(center, direction = 1) {
    // Conservative straight molded RJ45 plug/boot planning envelope.
    translate([center[0] - 6.0,
               direction > 0 ? center[1] : center[1] - ethernet_plug_depth,
               center[2] - 4.5])
        cube([12.0, ethernet_plug_depth, 9.0]);
}

module dc_plug(center, direction = 1) {
    // Conservative straight 5.5 x 2.1 mm molded plug planning envelope.
    translate(center)
        rotate([direction > 0 ? -90 : 90, 0, 0])
            cylinder(h = dc_plug_depth, d = 8.5, $fn = 28);
}

module ethernet_plug_x(center, direction = 1) {
    // Same planning envelope rotated onto a side-facing TP-Link connector.
    translate([
        direction > 0 ? center[0] : center[0] - ethernet_plug_depth,
        center[1] - 6.0,
        center[2] - 4.5
    ]) cube([ethernet_plug_depth, 12.0, 9.0]);
}

module dc_plug_x(center, direction = 1) {
    translate(center)
        rotate([0, direction > 0 ? 90 : -90, 0])
            cylinder(h = dc_plug_depth, d = 8.5, $fn = 28);
}

module mockups() {
    // Visual aids only; never included in production STL exports.
    color([0.45, 0.95, 0.65, 0.48])
        translate([green_x, green_y, green_device_z])
            green_device_mock_local();
    color([0.95, 0.95, 0.95, 0.85]) {
        if (splitter_model == "sics")
            sics_transform()
                translate([0, 0, base_thickness])
                    linear_extrude(height = sics_h)
                        rounded_rect_2d(sics_w, sics_d, 3.0);
        else
            splitter_transform()
                translate([0, 0, base_thickness])
                    beveled_rounded_box(
                        splitter_w, splitter_d, splitter_h, 4.0,
                        lower_bevel_h = splitter_lower_bevel_h,
                        upper_bevel_h = splitter_upper_bevel_h,
                        lower_inset_x = splitter_lower_bevel_inset,
                        lower_inset_y =
                            splitter_upper_end_bevel_inset,
                        upper_inset = splitter_upper_bevel_inset,
                        upper_inset_y =
                            splitter_upper_end_bevel_inset);
    }

    color([0.08, 0.09, 0.10, 1.0]) viewer_ports(false);
    color([0.12, 0.42, 0.78, 1.0]) viewer_data_cables(false);
    color([0.08, 0.09, 0.10, 1.0]) viewer_dc_cable(false);
    color([0.42, 0.44, 0.47, 1.0]) viewer_fasteners(false);
}

module viewer_keystone_ports(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;

    if (front_ethernet_enabled)
        translate([xoff, 0, 0]) {
            // Generic female-to-female keystone planning envelope.  Actual
            // coupler bodies differ; the printable coupon verifies its latch.
            translate([front_keystone_x - 7.3, -0.8,
                       front_keystone_z - 7.8])
                cube([14.6, 2.3, 15.6]);
            translate([front_keystone_x - 7.0, 1.5,
                       front_keystone_z - 10.0])
                cube([14.0, front_keystone_body_depth - 1.5, 20.0]);
        }
}

module viewer_splitter_ports(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;

    translate([xoff, 0, 0]) {
        if (splitter_model == "sics") {
            // SICSOLINK has one female PoE input at the rear end; LAN and DC
            // are captive leads emerging from the opposite end.
            sics_transform()
                translate([sics_w / 2 - 8.0, sics_d - 0.9,
                           base_thickness + 7.0])
                    cube([16.0, 1.8, 14.0]);
        } else if (stacked_center_layout) {
            input_face_x = stacked_splitter_output_x - splitter_d;

            // Rotated TP-Link: LAN/DC face right, while selector and PoE IN
            // face left. The device remains centered behind the Green.
            translate([stacked_splitter_output_x - 0.9,
                       splitter_y + splitter_lan_local_x - 8.0,
                       splitter_device_z + 5.0])
                cube([1.8, 16.0, 14.0]);
            translate([stacked_splitter_output_x - 0.9,
                       splitter_y + splitter_dc_local_x,
                       splitter_port_z])
                rotate([0, 90, 0]) cylinder(h = 1.8, d = 8.5, $fn = 28);

            translate([input_face_x - 0.9,
                       splitter_y + 8.0 - 4.5,
                       splitter_device_z + 8.5])
                cube([1.8, 9.0, 5.0]);
            translate([input_face_x - 0.9,
                       splitter_y + splitter_input_local_x - 8.0,
                       splitter_device_z + 5.0])
                cube([1.8, 16.0, 14.0]);
        } else {
            // TP-Link LAN OUT and DC OUT on the front-facing end.
            translate([splitter_lan_x - 8.0, splitter_y - 0.9,
                       splitter_device_z + 5.0])
                cube([16.0, 1.8, 14.0]);
            translate([splitter_dc_x, splitter_y - 0.9, splitter_port_z])
                rotate([90, 0, 0]) cylinder(h = 1.8, d = 8.5, $fn = 28);

            // TP-Link voltage selector and POWER+DATA IN on the rear-facing end.
            translate([splitter_x + 8.0, splitter_input_y - 0.9,
                       splitter_device_z + 8.5])
                cube([9.0, 1.8, 5.0]);
            translate([splitter_input_x - 8.0, splitter_input_y - 0.9,
                       splitter_device_z + 5.0])
                cube([16.0, 1.8, 14.0]);
        }
    }
}

module viewer_green_ports(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;

    translate([xoff, 0, 0]) {
        // Home Assistant Green rear connector field.
        translate([green_power_x, green_port_y - 0.9, green_port_z])
            rotate([90, 0, 0]) cylinder(h = 1.8, d = 8.5, $fn = 28);
        translate([green_x + 25.0, green_port_y - 0.9,
                   green_device_z + 5.0])
            cube([17.0, 1.8, 18.0]);
        translate([green_x + 48.0, green_port_y - 0.9,
                   green_device_z + 8.0])
            cube([15.0, 1.8, 7.0]);
        translate([green_x + 72.0, green_port_y - 0.9,
                   green_device_z + 10.0])
            cube([16.0, 1.8, 2.4]);
        translate([green_x + 88.0, green_port_y - 1.0,
                   green_device_z + 11.0])
            rotate([90, 0, 0]) cylinder(h = 2.0, d = 4.0, $fn = 24);
        translate([green_ethernet_x - 8.0, green_port_y - 0.9,
                   green_device_z + 5.0])
            cube([16.0, 1.8, 14.0]);
    }
}

// Compatibility union retained for existing GLB build scripts and previews.
module viewer_ports(add_ear_offset = true) {
    viewer_keystone_ports(add_ear_offset);
    viewer_splitter_ports(add_ear_offset);
    viewer_green_ports(add_ear_offset);
}

module viewer_internal_data_cable(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;
    z = splitter_port_z;

    translate([xoff, 0, 0]) {
        if (splitter_model == "sics") {
            // Full seller-stated 180 mm captive data lead, including the
            // Green-side plug. Two C1-continuous curves keep the service loop
            // smooth while lifting this lead above the DC route.
            data_start = [sics_data_exit_x, sics_data_exit_y, 20.0];
            data_first_control = [
                data_start[0] + sin(sics_angle) * 15.0,
                data_start[1] - cos(sics_angle) * 15.0,
                31.0
            ];
            data_loop = [128.0, 174.0, 31.0];
            data_loop_in = [118.0, 156.0, 31.0];
            data_loop_out = data_loop + 0.5 * (data_loop - data_loop_in);
            data_end = [green_ethernet_x,
                        green_port_y + ethernet_plug_depth,
                        green_port_z];
            sics_data_points = concat(
                cubic_bezier_points(
                    data_start, data_first_control,
                    data_loop_in, data_loop, 24),
                cubic_bezier_points(
                    data_loop, data_loop_out,
                    [green_ethernet_x, 156.0, green_port_z],
                    data_end, 24, 1));
            cable_path(sics_data_points, 4.2);
            ethernet_plug([green_ethernet_x, green_port_y,
                           green_port_z], 1);

        } else if (stacked_center_layout) {
            green_exit = [
                green_ethernet_x,
                green_port_y + ethernet_plug_depth,
                green_port_z
            ];
            splitter_port = [
                stacked_splitter_output_x,
                splitter_y + splitter_lan_local_x,
                splitter_port_z
            ];
            splitter_exit = splitter_port
                + [ethernet_plug_depth, 0, 0];
            bend_center = green_exit
                + [ethernet_bend_radius, 0, 0];
            bend = [for (index = [0 : 20])
                let(angle = 180 - 90 * index / 20)
                    [bend_center[0] + ethernet_bend_radius * cos(angle),
                     bend_center[1] + ethernet_bend_radius * sin(angle),
                     green_exit[2]]];
            tail = cubic_bezier_points(
                bend[len(bend) - 1],
                bend[len(bend) - 1] + [3.0, 0, 0],
                splitter_exit + [-3.0, 0, 0],
                splitter_exit, 8, 1);

            // Rotating the splitter aligns LAN closely enough with the
            // Green Ethernet jack for one full-radius R21 quarter-turn.
            cable_path(concat(bend, tail), ethernet_cable_diameter);
            ethernet_plug(
                [green_ethernet_x, green_port_y, green_port_z], 1);
            ethernet_plug_x(splitter_port, 1);
        } else if (front_ethernet_enabled
                   && front_keystone_side == "right") {
            // The centered-right front jack occupies the original X=78 LAN
            // lane. Lift this jumper into a high, collision-free layer while
            // retaining an exact R21 front turn and generous rear bends.
            lan_u = [36.0 / 42.0, 0, 21.6333077 / 42.0];
            lan_points = concat(
                tilted_half_arc_points(
                    [46.7, 35.0, 25.8166538], 21.0, lan_u, 24),
                [[64.7, 60.0, 36.6333077]],
                cubic_bezier_points(
                    [64.7, 60.0, 36.6333077],
                    [64.7, 80.0, 36.6333077],
                    [82.0, 100.0, 36.6333077],
                    [82.0, 120.0, 36.6333077], 18, 1),
                [[82.0, 142.0, 36.6333077]],
                arc_points_xy([103.0, 142.0], 21.0, 180, 90,
                              36.6333077, 16),
                cubic_bezier_points(
                    [103.0, 163.0, 36.6333077],
                    [123.6667, 163.0, 36.6333077],
                    [144.3333, 163.0, green_port_z],
                    [165.0, 163.0, green_port_z], 18, 1),
                arc_points_xy([165.0, 142.0], 21.0, 90, 0,
                              green_port_z, 16),
                [[green_ethernet_x,
                  green_port_y + ethernet_plug_depth, green_port_z]]);
            cable_path(lan_points, ethernet_cable_diameter);
            ethernet_plug([splitter_lan_x, splitter_y, z], -1);
            ethernet_plug([green_ethernet_x, green_port_y, green_port_z], 1);
        } else {
            // Internal LAN jumper with full straight plug envelopes and tangent
            // bends. Compact/Balanced use orange warning materials in the GLB
            // because their collision-clamped front radii remain below 21 mm.
            internal_points = splitter_y < 40.0
                ? compact_ethernet_route()
                : opposite_port_route(
                    splitter_lan_x, splitter_y,
                    green_ethernet_x, green_port_y,
                    ethernet_cable_lane_x, ethernet_cross_y,
                    ethernet_plug_depth,
                    ethernet_front_bend_radius, ethernet_bend_radius,
                    z, ethernet_route_z, green_port_z);
            cable_path(internal_points, ethernet_cable_diameter);
            ethernet_plug([splitter_lan_x, splitter_y, z], -1);
            ethernet_plug([green_ethernet_x, green_port_y, green_port_z], 1);
        }
    }
}

module viewer_input_data_cable(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;
    z = splitter_port_z;

    translate([xoff, 0, 0]) {
        if (splitter_model == "sics") {
            // The straight plug initially follows the angled input face, then
            // the patch lead curves centerward before continuing toward the
            // rack rear. This keeps it clear of the left rack-ear envelope.
            input_direction = [-sin(sics_angle), cos(sics_angle), 0];
            input_tip = [
                sics_input_x + input_direction[0] * ethernet_plug_depth,
                sics_input_y + input_direction[1] * ethernet_plug_depth,
                20.0
            ];
            input_points = cubic_bezier_points(
                input_tip,
                input_tip + input_direction * 7.0,
                [55.0, 216.0, 20.0],
                [55.0, 232.0, 20.0], 24);
            cable_path(input_points, ethernet_cable_diameter);
            sics_transform()
                ethernet_plug([sics_w / 2, sics_d, 20.0], 1);
        } else if (stacked_center_layout) {
            input_face_x = stacked_splitter_output_x - splitter_d;
            input_y = splitter_y + splitter_input_local_x;
            input_port = [input_face_x, input_y, splitter_port_z];
            input_exit = input_port + [-ethernet_plug_depth, 0, 0];
            input_points = cubic_bezier_points(
                input_exit,
                input_exit + [-18.0, 0, 0],
                [input_exit[0] - 24.0, 212.0, splitter_port_z],
                [input_exit[0] - 24.0, 232.0, splitter_port_z], 24);

            // The side-facing PoE input turns toward the rack rear without
            // crossing either device or its raised support bridge.
            cable_path(input_points, ethernet_cable_diameter);
            ethernet_plug_x(input_port, -1);
        } else if (front_ethernet_enabled) {
            // All front-entry editions use ordinary straight plugs and
            // verified R21-or-larger paths back to POWER+DATA IN.
            front_start = [front_keystone_x,
                           front_keystone_body_depth
                               + ethernet_plug_depth,
                           front_keystone_z];
            front_input_points = front_keystone_side == "far_right"
                ? concat(
                    [front_start,
                     [front_keystone_x, 165.8, front_keystone_z]],
                    arc_points_xy(
                        [front_keystone_x - ethernet_bend_radius, 165.8],
                        ethernet_bend_radius, 0, 90,
                        front_keystone_z, 16),
                    cubic_bezier_points(
                        [front_keystone_x - ethernet_bend_radius,
                         186.8, front_keystone_z],
                        [148.13, 186.8, front_keystone_z],
                        [107.02, 186.8, z],
                        [65.9, 186.8, z], 20, 1),
                    arc_points_xy([65.9, 165.8],
                                  ethernet_bend_radius,
                                  90, 180, z, 16))
                : front_keystone_side == "right"
                ? concat(
                    cubic_bezier_points(
                        front_start,
                        [77.0, 77.333, 21.5],
                        [77.0, 98.667, 15.0],
                        [77.0, 120.0, 15.0], 18),
                    [[77.0, 148.1, 15.0]],
                    arc_points_xy([56.0, 148.1], 21.0, 0, 90,
                                  15.0, 16),
                    [[23.9, 169.1, 15.0]],
                    arc_points_xy([23.9, 190.1], 21.0, 270, 0,
                                  15.0, 28),
                    [[splitter_input_x,
                      splitter_input_y + ethernet_plug_depth, z]])
                : concat(
                    arc_points_yz(
                        [56.0, 42.5], 21.0,
                        -90.0, -46.5679717, 25.0, 12),
                    arc_points_yz(
                        [84.8747294, 12.0], 21.0,
                        133.4320283, 90.0, 25.0, 12),
                    cubic_bezier_points(
                        [25.0, 84.8747294, 33.0],
                        [25.0, 105.5164863, 33.0],
                        [2.9, 126.1582431, 33.0],
                        [2.9, 146.8, 33.0], 18, 1),
                    cubic_bezier_points(
                        [2.9, 146.8, 33.0],
                        [2.9, 162.8, 33.0],
                        [2.9, 178.8, 15.0],
                        [2.9, 194.8, 15.0], 18, 1),
                    arc_points_xy([23.9, 194.8], 21.0, 180, 0,
                                  15.0, 24));
            cable_path(front_input_points, ethernet_cable_diameter);
            ethernet_plug([front_keystone_x,
                           front_keystone_body_depth,
                           front_keystone_z], 1);
            ethernet_plug([splitter_input_x, splitter_input_y, z], 1);

            // Short exterior stub makes the front-feed topology obvious in
            // the browser while keeping the exact rack-to-switch lead optional.
            cable_path([[front_keystone_x, -ethernet_plug_depth,
                         front_keystone_z],
                        [front_keystone_x, -48.0,
                         front_keystone_z]], ethernet_cable_diameter);
            ethernet_plug([front_keystone_x, 0,
                           front_keystone_z], -1);
        } else {
            // Incoming PoE lead continues toward the rack rear / patch panel.
            input_points = [
                [splitter_input_x, splitter_input_y + ethernet_plug_depth, z],
                [splitter_input_x, 205.0, z]
            ];
            cable_path(input_points, ethernet_cable_diameter);
            ethernet_plug([splitter_input_x, splitter_input_y, z], 1);
        }
    }
}

module viewer_data_cables(add_ear_offset = true) {
    // Compatibility export containing both Ethernet runs.
    viewer_internal_data_cable(add_ear_offset);
    viewer_input_data_cable(add_ear_offset);
}

module viewer_dc_cable(add_ear_offset = true) {
    xoff = add_ear_offset ? ear_width : 0;
    z = splitter_port_z;

    translate([xoff, 0, 0]) {
        if (splitter_model == "sics") {
            // Full captive DC lead with a low service loop. The three Bezier
            // sections share collinear handles at both joins, eliminating the
            // old visible kinks and keeping this cable below the LAN lead.
            dc_start = [sics_dc_exit_x, sics_dc_exit_y, 12.0];
            dc_first_control = [
                dc_start[0] + sin(sics_angle) * 15.0,
                dc_start[1] - cos(sics_angle) * 15.0,
                12.0
            ];
            dc_loop = [68.0, 82.0, 12.0];
            dc_loop_in = [78.0, 92.0, 12.0];
            dc_loop_out = dc_loop + 0.6 * (dc_loop - dc_loop_in);
            dc_ramp = [99.0, 150.0, 12.0];
            dc_end = [green_power_x,
                      green_port_y + dc_plug_depth,
                      green_port_z];
            sics_dc_points = concat(
                cubic_bezier_points(
                    dc_start, dc_first_control,
                    dc_loop_in, dc_loop, 24),
                cubic_bezier_points(
                    dc_loop, dc_loop_out,
                    [99.0, 160.0, 12.0], dc_ramp, 24, 1),
                cubic_bezier_points(
                    dc_ramp, [99.0, 146.0, 12.0],
                    [99.0, 143.0, green_port_z], dc_end, 16, 1));
            cable_path(sics_dc_points, dc_cable_diameter);
            dc_plug([green_power_x, green_port_y, green_port_z], 1);
        } else if (stacked_center_layout) {
            green_port = [green_power_x, green_port_y, green_port_z];
            green_exit = green_port + [0, dc_plug_depth, 0];
            splitter_port = [
                stacked_splitter_output_x,
                splitter_y + splitter_dc_local_x,
                splitter_port_z
            ];
            splitter_exit = splitter_port + [dc_plug_depth, 0, 0];
            tray_rear_y = splitter_y + splitter_w
                + splitter_clearance + wall_thickness;
            left_turn_center = green_exit + [-dc_bend_radius, 0, 0];
            rear_left_center = [
                left_turn_center[0] + dc_bend_radius,
                tray_rear_y,
                splitter_port_z
            ];
            rear_right_center = [
                splitter_exit[0] - dc_bend_radius,
                tray_rear_y,
                splitter_port_z
            ];
            dc_points = concat(
                arc_points_xy(
                    left_turn_center, dc_bend_radius,
                    0, 90, splitter_port_z, 12),
                [[left_turn_center[0], tray_rear_y, splitter_port_z]],
                arc_points_xy(
                    rear_left_center, dc_bend_radius,
                    180, 90, splitter_port_z, 12),
                [[rear_right_center[0],
                  tray_rear_y + dc_bend_radius, splitter_port_z]],
                arc_points_xy(
                    rear_right_center, dc_bend_radius,
                    90, 0, splitter_port_z, 12),
                [splitter_exit]);

            // Route around the splitter's left and rear edges with full R10
            // corners, then descend its open right side to DC OUT.
            cable_path(dc_points, dc_cable_diameter);
            dc_plug(green_port, 1);
            dc_plug_x(splitter_port, 1);
        } else if (front_ethernet_enabled
                   && front_keystone_side == "right") {
            // Layer the DC jumper below the centered-right Ethernet paths.
            dc_u = [11.0 / 20.0, 0, 16.7032931 / 20.0];
            dc_points = concat(
                tilted_half_arc_points(
                    [55.8, 38.0, 23.3516465], 10.0, dc_u, 20),
                [[61.3, 175.0, 31.7032931]],
                arc_points_xy([71.3, 175.0], 10.0, 180, 0,
                              31.7032931, 16),
                cubic_bezier_points(
                    [81.3, 175.0, 31.7032931],
                    [81.3, 162.8333, 31.7032931],
                    [99.0, 150.6667, green_port_z],
                    [99.0, 138.5, green_port_z], 18, 1));
            cable_path(dc_points, dc_cable_diameter);
            dc_plug([splitter_dc_x, splitter_y, z], -1);
            dc_plug([green_power_x, green_port_y, green_port_z], 1);
        } else {
            // Straight-plug route with rounded bends. Bare tip-to-tip planning
            // lengths are about 272 / 262 / 249 mm for the three viewer layouts;
            // use a 12-inch lead for comfortable service slack.
            dc_points = opposite_port_route(
                splitter_dc_x, splitter_y,
                green_power_x, green_port_y,
                dc_cable_lane_x, dc_cross_y,
                dc_plug_depth,
                dc_front_bend_radius, dc_bend_radius,
                z, dc_route_z, green_port_z);
            cable_path(dc_points, dc_cable_diameter);
            dc_plug([splitter_dc_x, splitter_y, z], -1);
            dc_plug([green_power_x, green_port_y, green_port_z], 1);
        }
    }
}

module viewer_rulers() {
    tick_step = 10.0;
    minor_tick = 3.0;
    major_tick = 6.0;
    bar = 1.2;

    // X / overall rack width ruler, positioned just in front of the panel.
    translate([0, -20.0, 0.4]) cube([rack_width, bar, bar]);
    for (x = [0 : tick_step : 250])
        translate([x, -20.0, 0.4])
            cube([0.8, (x % 50 == 0) ? major_tick : minor_tick, bar]);
    translate([rack_width - 0.8, -20.0, 0.4])
        cube([0.8, major_tick, bar]);

    // Y / printed mount-depth ruler, positioned just outside the right ear.
    translate([rack_width + 5.0, 0, 0.4])
        cube([bar, active_mount_depth, bar]);
    for (y = [0 : tick_step : floor(active_mount_depth / tick_step) * tick_step])
        translate([rack_width + 5.0
                       - ((y % 50 == 0) ? major_tick : minor_tick),
                   y, 0.4])
            cube([(y % 50 == 0) ? major_tick : minor_tick, 0.8, bar]);
    translate([rack_width + 5.0 - major_tick,
               active_mount_depth - 0.8, 0.4])
        cube([major_tick, 0.8, bar]);

    // Z / 1U face height ruler at the left edge.
    translate([-8.0, -1.0, 0]) cube([bar, bar, rack_height]);
    for (z = [0 : tick_step : 40])
        translate([-8.0, -1.0, z])
            cube([(z % 20 == 0) ? major_tick : minor_tick, bar, 0.8]);
    translate([-8.0, -1.0, rack_height - 0.8])
        cube([major_tick, bar, 0.8]);
}

module viewer_fasteners(add_ear_offset = true) {
    // Preview-only M3 x 25 screw envelopes showing how the Green is retained.
    xoff = add_ear_offset ? ear_width : 0;
    for (x = green_mount_x)
        for (y = green_mount_y) {
            translate([xoff + x, y, -3.0])
                cylinder(h = 3.0, d = 5.5, $fn = 28);
            translate([xoff + x, y, 0])
                cylinder(h = 25.0, d = 3.0, $fn = 24);
    }
}

// Viewer-only comparison geometry for Green retention concepts. These models
// deliberately exaggerate exposed tabs/pads slightly so their operation is
// readable in the browser. They do not alter any printable rack export.
module retention_support_pads_local(size = 8.0) {
    // Four broad feet preserve the proven 6.025 mm heatsink standoff without
    // requiring the Green's factory screws. They sit on the corner lands and
    // leave the finned center/honeycomb airflow field open.
    for (x = [green_x + 1.0, green_x + green_w - size - 1.0])
        for (y = [green_y + 1.0, green_y + green_d - size - 1.0])
            translate([x, y, base_thickness])
                rounded_prism_z(size, size, green_standoff, 1.2);
}

module retention_slide_latch_local() {
    retention_support_pads_local();
    // Four short C-shoes: a lower shelf, outside wall, and provisional lip
    // engaging the dark lower-base ledge rather than the clear upper shell.
    for (y0 = retention_segment_y) {
        translate([green_x - 4.0, y0, retention_accent_z0])
            rounded_prism_z(5.0, retention_segment_len, 0.85, 0.7);
        translate([green_x - 3.5, y0, retention_accent_z0])
            rounded_prism_z(retention_side_wall, retention_segment_len,
                            retention_wall_h, 0.65);
        translate([green_x - 3.5, y0, retention_ledge_z])
            rounded_prism_z(3.5 + retention_lip_overlap,
                            retention_segment_len, 1.0, 0.55);

        translate([green_x + green_w - 1.0, y0, retention_accent_z0])
            rounded_prism_z(5.0, retention_segment_len, 0.85, 0.7);
        translate([green_x + green_w + 1.1, y0, retention_accent_z0])
            rounded_prism_z(retention_side_wall, retention_segment_len,
                            retention_wall_h, 0.65);
        translate([green_x + green_w - retention_lip_overlap, y0,
                   retention_ledge_z])
            rounded_prism_z(3.5 + retention_lip_overlap,
                            retention_segment_len, 1.0, 0.55);
    }

    // Low front locating stops.
    translate([green_x - 2.8, green_y - 1.6, retention_accent_z0])
        rounded_prism_z(15.0, 2.5, 4.7, 0.75);
    translate([green_x + green_w - 12.2, green_y - 1.6,
               retention_accent_z0])
        rounded_prism_z(15.0, 2.5, 4.7, 0.75);

    // Two rear cantilever latches with outward thumb tabs. The arms flex in
    // the build plane and relax after their hooks pass the lower-base corners.
    latch_y = green_y + green_d - retention_latch_len;
    translate([green_x - 3.3, latch_y, green_device_z - 0.1])
        rounded_prism_z(retention_latch_t, retention_latch_len, 4.7, 0.65);
    translate([green_x - 3.3, green_y + green_d - 2.2,
               green_device_z - 0.1])
        rounded_prism_z(4.4, 2.2, 4.7, 0.55);
    translate([green_x - 7.0, green_y + green_d - 10.5,
               green_device_z + 1.0])
        rounded_prism_z(4.0, 7.0, 2.5, 0.8);

    translate([green_x + green_w + 1.5, latch_y,
               green_device_z - 0.1])
        rounded_prism_z(retention_latch_t, retention_latch_len, 4.7, 0.65);
    translate([green_x + green_w - 1.1, green_y + green_d - 2.2,
               green_device_z - 0.1])
        rounded_prism_z(4.4, 2.2, 4.7, 0.55);
    translate([green_x + green_w + 3.0, green_y + green_d - 10.5,
               green_device_z + 1.0])
        rounded_prism_z(4.0, 7.0, 2.5, 0.8);
}

module retention_corner_gate_local() {
    retention_support_pads_local();
    cup_z = green_device_z - 0.9;
    cup_h = 5.2;
    // Four low L-cups leave the top shell and center heatsink open.
    for (y0 = [green_y - 1.0, green_y + green_d - 16.0]) {
        translate([green_x - 3.2, y0, cup_z])
            rounded_prism_z(3.0, 17.0, cup_h, 0.75);
        translate([green_x + green_w + 0.2, y0, cup_z])
            rounded_prism_z(3.0, 17.0, cup_h, 0.75);
    }
    translate([green_x - 3.2, green_y - 1.5, cup_z])
        rounded_prism_z(19.0, 1.3, cup_h, 0.6);
    translate([green_x + green_w - 15.8, green_y - 1.5, cup_z])
        rounded_prism_z(19.0, 1.3, cup_h, 0.6);

    // Captive low rear gate: the thin bridge stays below the Green while the
    // two end shoulders block rearward motion without covering its ports.
    gate_y = green_y + green_d + 0.4;
    translate([green_x - 2.0, gate_y, green_device_z - 1.9])
        rounded_prism_z(green_w + 4.0, 2.5, 1.7, 0.65);
    translate([green_x - 2.0, gate_y, green_device_z - 0.4])
        rounded_prism_z(15.0, 2.5, 4.5, 0.65);
    translate([green_x + green_w - 13.0, gate_y,
               green_device_z - 0.4])
        rounded_prism_z(15.0, 2.5, 4.5, 0.65);
    translate([green_x + green_w + 2.0, gate_y - 0.4,
               green_device_z + 0.5])
        rounded_prism_z(5.5, 3.3, 2.7, 0.8);
}

module retention_sled_gate_local() {
    retention_support_pads_local();
    sled_z = green_device_z - 1.65;
    // Open U-frame: side beams sit only under the solid perimeter lands.
    translate([green_x + 1.0, green_y, sled_z])
        rounded_prism_z(7.5, green_d, 1.6, 0.8);
    translate([green_x + green_w - 8.5, green_y, sled_z])
        rounded_prism_z(7.5, green_d, 1.6, 0.8);
    translate([green_x + 1.0, green_y, sled_z])
        rounded_prism_z(green_w - 2.0, 8.0, 1.6, 0.8);

    // Low cage rails and rear detent bar make the removable sled visually
    // distinct from the rack tray while preserving the center airflow field.
    translate([green_x - 2.5, green_y + 1.0, sled_z])
        rounded_prism_z(3.0, green_d - 2.0, 6.0, 0.75);
    translate([green_x + green_w - 0.5, green_y + 1.0, sled_z])
        rounded_prism_z(3.0, green_d - 2.0, 6.0, 0.75);
    translate([green_x + 12.0, green_y + green_d + 0.5, sled_z])
        rounded_prism_z(green_w - 24.0, 3.0, 3.2, 0.75);
    translate([green_x + green_w / 2 - 17.0,
               green_y + green_d + 2.8, sled_z])
        rounded_prism_z(34.0, 4.0, 2.3, 1.0);
}

module retention_padded_rails_local() {
    retention_support_pads_local();
    pad_z = green_device_z + 0.2;
    // Four compliant inserts between the Green and the existing rigid guides.
    for (y0 = [green_y + 21.0, green_y + 77.0]) {
        translate([green_x - 1.0, y0, pad_z])
            rounded_prism_z(1.35, 14.0, 4.2, 0.55);
        translate([green_x + green_w - 0.35, y0, pad_z])
            rounded_prism_z(1.35, 14.0, 4.2, 0.55);
    }
    // Low rear pads show the accompanying hard-stop contact locations.
    translate([green_x + 7.0, green_y + green_d - 0.7, pad_z])
        rounded_prism_z(18.0, 1.4, 3.5, 0.55);
    translate([green_x + green_w - 25.0, green_y + green_d - 0.7, pad_z])
        rounded_prism_z(18.0, 1.4, 3.5, 0.55);
}

// Extrude an X/Z detent profile along Y. `direction` points toward the
// retained device: +1 from its left wall, -1 from its right wall.
module retention_detent_y_local(
    x_plane, y0, length, z_center, reach, height, direction = 1) {
    overlap = 0.25;
    points = direction > 0
        ? [[x_plane - overlap, z_center - height / 2],
           [x_plane + reach, z_center],
           [x_plane - overlap, z_center + height / 2]]
        : [[x_plane + overlap, z_center - height / 2],
           [x_plane - reach, z_center],
           [x_plane + overlap, z_center + height / 2]];
    translate([0, y0 + length, 0])
        rotate([90, 0, 0])
            linear_extrude(height = length)
                polygon(points = points);
}

// The proven community pattern captures the clear lid/top edge rather than a
// guessed lower undercut. This lower guide grips only the measured base, then
// follows the measured inward taper. Windows free the two right-hand
// spring towers above the tray floor; the left-hand towers stay rigid.
module hybrid_green_lower_side_walls_local() {
    cover_x = green_x + (green_w - green_cover_w) / 2;
    outer_left = green_x - wall_thickness;
    outer_right = green_x + green_inner_w + wall_thickness;
    lower_left = green_x + hybrid_green_guide_interference;
    lower_right = green_x + green_w - hybrid_green_guide_interference;
    upper_left = cover_x - hybrid_green_cover_clearance;
    upper_right = cover_x + green_cover_w
                  + hybrid_green_cover_clearance;
    z0 = base_thickness - 0.20;
    lower_top = green_device_z + hybrid_green_lower_grip_h;
    upper_top = lower_top + hybrid_green_transition_h;
    y0 = green_y - 0.20;
    d = green_inner_d + 0.20;
    clip_ys = [green_y + green_d / 2
                   - hybrid_green_clip_center_offset
                   - hybrid_green_clip_len / 2,
               green_y + green_d / 2
                   + hybrid_green_clip_center_offset
                   - hybrid_green_clip_len / 2];

    intersection() {
        union() {
            extrude_xz_profile_y([
                [outer_left, z0],
                [lower_left, z0],
                [lower_left, lower_top],
                [upper_left, upper_top],
                [outer_left, upper_top]
            ], y0, d);

            difference() {
                extrude_xz_profile_y([
                    [lower_right, z0],
                    [outer_right, z0],
                    [outer_right, upper_top],
                    [upper_right, upper_top],
                    [lower_right, lower_top]
                ], y0, d);

                for (clip_y = clip_ys)
                    translate([
                        lower_right - 0.30,
                        clip_y - hybrid_green_window_margin,
                        base_thickness
                    ])
                        cube([
                            outer_right - lower_right + 0.80,
                            hybrid_green_clip_len
                                + 2 * hybrid_green_window_margin,
                            upper_top - base_thickness + 0.20
                        ]);
            }
        }

        translate([0, 0, z0])
            linear_extrude(height = upper_top - z0)
                green_tray_outer_outline_2d();
    }
}

module hybrid_green_top_catch_left(y0,
                                    reach = hybrid_green_clip_reach) {
    cover_x = green_x + (green_w - green_cover_w) / 2;
    top_edge_x = cover_x + green_cover_top_inset;
    inner = cover_x - hybrid_green_cover_clearance;
    outer = inner - hybrid_green_fixed_arm_t;
    bevel_start_z = green_device_z + green_h
                    - green_cover_upper_bevel_h;
    bevel_follow_x = top_edge_x - hybrid_green_cover_clearance;
    catch_z = green_device_z + green_h + hybrid_green_clip_clearance;
    flat_x = inner + reach - hybrid_green_catch_flat;
    tip_x = inner + reach;
    nose_top_z = catch_z + hybrid_green_catch_nose_t;
    tip_top_z = catch_z + hybrid_green_catch_tip_t;
    shoulder_x = tip_x - hybrid_green_catch_tip_bevel;
    root_inner_x = inner + 2.4;

    // One continuous profile eliminates the ridges produced by overlapping
    // rounded towers, root hulls, and square-ended catch solids.
    extrude_xz_profile_y([
        [outer, 0],
        [root_inner_x, 0],
        [root_inner_x, 1.4],
        [inner, 3.8],
        [inner, bevel_start_z],
        [bevel_follow_x, green_device_z + green_h],
        [flat_x, catch_z],
        [tip_x, catch_z],
        [tip_x, tip_top_z],
        [shoulder_x, nose_top_z],
        [flat_x, nose_top_z],
        [inner, catch_z + hybrid_green_top_ramp_h],
        [outer, catch_z + hybrid_green_top_ramp_h]
    ], y0, hybrid_green_clip_len);
}

module hybrid_green_top_catch_right(y0,
                                     reach = hybrid_green_clip_reach) {
    cover_x = green_x + (green_w - green_cover_w) / 2;
    top_edge_x = cover_x + green_cover_w - green_cover_top_inset;
    inner = cover_x + green_cover_w + hybrid_green_cover_clearance;
    outer = inner + hybrid_green_spring_arm_t;
    bevel_start_z = green_device_z + green_h
                    - green_cover_upper_bevel_h;
    bevel_follow_x = top_edge_x + hybrid_green_cover_clearance;
    catch_z = green_device_z + green_h + hybrid_green_clip_clearance;
    flat_x = inner - reach + hybrid_green_catch_flat;
    tip_x = inner - reach;
    nose_top_z = catch_z + hybrid_green_catch_nose_t;
    tip_top_z = catch_z + hybrid_green_catch_tip_t;
    shoulder_x = tip_x + hybrid_green_catch_tip_bevel;
    root_outer_x = outer + 0.9;
    root_inner_x = inner - 0.9;

    // The outer wall is itself the release surface. Keeping the root, tower,
    // taper follower, and nose in one extrusion removes the former add-on tab.
    extrude_xz_profile_y([
        [root_inner_x, 0],
        [root_outer_x, 0],
        [root_outer_x, 1.4],
        [outer, 3.8],
        [outer, catch_z + hybrid_green_top_ramp_h],
        [inner, catch_z + hybrid_green_top_ramp_h],
        [flat_x, nose_top_z],
        [shoulder_x, nose_top_z],
        [tip_x, tip_top_z],
        [tip_x, catch_z],
        [flat_x, catch_z],
        [bevel_follow_x, green_device_z + green_h],
        [inner, bevel_start_z],
        [inner, 3.8],
        [root_inner_x, 1.4]
    ], y0, hybrid_green_clip_len);
}

module retention_green_hybrid_clips_local(
    fixed_reach = hybrid_green_clip_reach,
    spring_reach = hybrid_green_clip_reach) {
    clip_ys = [green_y + green_d / 2
                   - hybrid_green_clip_center_offset
                   - hybrid_green_clip_len / 2,
               green_y + green_d / 2
                   + hybrid_green_clip_center_offset
                   - hybrid_green_clip_len / 2];

    for (y0 = clip_ys) {
        hybrid_green_top_catch_left(y0, fixed_reach);
        hybrid_green_top_catch_right(y0, spring_reach);
    }
}

module hybrid_green_end_stops_local() {
    cover_x = green_x + (green_w - green_cover_w) / 2;
    cover_y = green_y + (green_d - green_cover_d) / 2;
    outer_y0 = face_thickness - 0.20;
    outer_y1 = green_y + green_inner_d + wall_thickness;
    stop_z = base_thickness - 0.20;
    stop_top = green_device_z + hybrid_green_lower_grip_h;
    x0 = cover_x + 0.25;
    x1 = cover_x + green_cover_w - 0.25;
    front_y1 = cover_y - 0.25;
    rear_y0 = cover_y + green_cover_d + 0.25;
    corner_w = 14.0;

    translate([x0, outer_y0 + 0.20, stop_z])
        rounded_prism_z(
            x1 - x0, front_y1 - (outer_y0 + 0.20),
            stop_top - stop_z, 0.65);
    translate([x0, rear_y0, stop_z])
        rounded_prism_z(
            corner_w, outer_y1 - 0.20 - rear_y0,
            stop_top - stop_z, 0.65);
    translate([x1 - corner_w, rear_y0, stop_z])
        rounded_prism_z(
            corner_w, outer_y1 - 0.20 - rear_y0,
            stop_top - stop_z, 0.65);
}

module green_tray_hybrid_pads_local() {
    union() {
        green_friction_deck_pads();
        hybrid_green_lower_side_walls_local();
        hybrid_green_end_stops_local();
        retention_green_hybrid_clips_local();
    }
}

// All four TP-Link catches rise directly from continuous, rigid mini walls.
// The left and right profiles are true mirrors: there are no spring tongues,
// relief cuts, cosmetic skins, outriggers, or visible wall-to-clip gaps. The
// measured housing taper and the printed cradle provide the insertion flex.
module retention_splitter_hybrid_clips_local(
    clip_reach = hybrid_splitter_clip_reach,
    clip_y_override = undef) {
    inner_left = splitter_friction_interference;
    inner_right = splitter_w - splitter_friction_interference;
    clip_ys = is_undef(clip_y_override)
        ? [splitter_d / 2 - hybrid_splitter_clip_center_offset
               - hybrid_splitter_clip_len / 2,
           splitter_d / 2 + hybrid_splitter_clip_center_offset
               - hybrid_splitter_clip_len / 2]
        : [clip_y_override];
    catch_z = base_thickness + splitter_h
              + hybrid_splitter_clip_clearance;
    tip_x = inner_left + clip_reach;
    flat_x = tip_x - hybrid_splitter_catch_flat;
    fixed_tip_x = inner_right - clip_reach;
    fixed_flat_x = fixed_tip_x + hybrid_splitter_catch_flat;
    tower_outer_left = inner_left - hybrid_splitter_tower_t;
    tower_outer_right = inner_right + hybrid_splitter_tower_t;
    tower_root_z = base_thickness + splitter_friction_grip_h
                   + splitter_friction_lead_h - 0.20;
    ramp_bottom_z = base_thickness + splitter_h
                    - splitter_upper_bevel_h;
    land_outer_margin = hybrid_splitter_catch_flat
                        - hybrid_splitter_top_overlap;
    ramp_contact_z = ramp_bottom_z
                     + splitter_upper_bevel_h
                       * splitter_friction_interference
                       / splitter_upper_bevel_inset;
    bevel_flat_z = ramp_bottom_z
                   + splitter_upper_bevel_h
                     * (splitter_upper_bevel_inset - land_outer_margin)
                     / splitter_upper_bevel_inset;
    nose_top_z = catch_z + hybrid_splitter_catch_nose_t;
    tip_top_z = catch_z + hybrid_splitter_catch_tip_t;
    shoulder_x = tip_x - hybrid_splitter_catch_tip_bevel;
    fixed_shoulder_x = fixed_tip_x
                       + hybrid_splitter_catch_tip_bevel;
    ramp_top_z = ramp_contact_z + hybrid_splitter_catch_nose_t;

    union() {
        splitter_side_walls_local();

        for (clip_y0 = clip_ys) {
            // Rack-outboard rigid catch.
            extrude_xz_profile_y([
                [tower_outer_left, tower_root_z],
                [inner_left, tower_root_z],
                [inner_left, ramp_contact_z],
                [flat_x, bevel_flat_z],
                [flat_x, catch_z],
                [tip_x, catch_z],
                [tip_x, tip_top_z],
                [shoulder_x, nose_top_z],
                [flat_x, nose_top_z],
                [inner_left, ramp_top_z],
                [tower_outer_left, ramp_top_z]
            ], clip_y0, hybrid_splitter_clip_len);

            // Bridge-side rigid catch, mirrored from the outboard profile.
            extrude_xz_profile_y([
                [inner_right, tower_root_z],
                [tower_outer_right, tower_root_z],
                [tower_outer_right, ramp_top_z],
                [inner_right, ramp_top_z],
                [fixed_flat_x, nose_top_z],
                [fixed_shoulder_x, nose_top_z],
                [fixed_tip_x, tip_top_z],
                [fixed_tip_x, catch_z],
                [fixed_flat_x, catch_z],
                [fixed_flat_x, bevel_flat_z],
                [inner_right, ramp_contact_z]
            ], clip_y0, hybrid_splitter_clip_len);
        }
    }
}

module retention_hybrid_clips_local() {
    green_tray_hybrid_pads_local();
    if (splitter_model == "tplink")
        splitter_transform() retention_splitter_hybrid_clips_local();
}

module retention_captive_strap_local() {
    retention_support_pads_local();
    strap_y = green_y + 14.0;
    strap_w = 4.0;
    strap_t = 0.75;
    // A thin TPU band across the front perimeter, away from the main top vent.
    translate([green_x - 1.5, strap_y,
               green_device_z + green_h + 0.12])
        rounded_prism_z(green_w + 3.0, strap_w, strap_t, 0.75);
    translate([green_x - 1.5, strap_y, green_device_z - 0.2])
        rounded_prism_z(1.5, strap_w, green_h + 1.1, 0.6);
    translate([green_x + green_w, strap_y, green_device_z - 0.2])
        rounded_prism_z(1.5, strap_w, green_h + 1.1, 0.6);
    // Captive hinge and snap/button blocks; neither part becomes loose.
    translate([green_x - 4.2, strap_y - 0.8, green_device_z + 1.0])
        rounded_prism_z(3.2, strap_w + 1.6, 4.8, 0.9);
    translate([green_x + green_w + 1.0, strap_y - 0.8,
               green_device_z + 1.0])
        rounded_prism_z(3.2, strap_w + 1.6, 4.8, 0.9);
}

module retention_zip_ties_local() {
    // Legacy visualization only. The Green tray no longer contains zip-tie
    // slots, so this mechanism is intentionally absent from the selector.
    retention_support_pads_local();
    tie_y = green_y + 48.0;
    tie_w = 3.0;
    tie_t = 0.65;
    // White tie through the existing tray slots. The locking head remains at
    // the splitter-side wall rather than consuming the scarce top clearance.
    translate([green_x - 2.0, tie_y,
               green_device_z + green_h + 0.10])
        rounded_prism_z(green_w + 4.0, tie_w, tie_t, 0.55);
    // The lower legs land in the actual slot centers, then flare outward
    // below the enclosure before climbing its sides.
    left_slot_x = green_x + 5.5;
    right_slot_x = green_x + green_w - 4.5;
    hull() {
        translate([left_slot_x, tie_y, base_thickness + 0.15])
            rounded_prism_z(1.1, tie_w, 1.1, 0.4);
        translate([green_x - 2.0, tie_y, green_device_z - 0.2])
            rounded_prism_z(1.1, tie_w, 1.1, 0.4);
    }
    hull() {
        translate([right_slot_x, tie_y, base_thickness + 0.15])
            rounded_prism_z(1.1, tie_w, 1.1, 0.4);
        translate([green_x + green_w + 0.9, tie_y,
                   green_device_z - 0.2])
            rounded_prism_z(1.1, tie_w, 1.1, 0.4);
    }
    translate([green_x - 2.0, tie_y, green_device_z - 0.2])
        rounded_prism_z(1.1, tie_w, green_h + 0.4, 0.4);
    translate([green_x + green_w + 0.9, tie_y,
               green_device_z - 0.2])
        rounded_prism_z(1.1, tie_w, green_h + 0.4, 0.4);
    translate([left_slot_x - 3.0, tie_y - 1.0, base_thickness + 0.2])
        rounded_prism_z(5.5, tie_w + 2.0, 5.5, 0.8);
}

module retention_beam_xy_local(p1, p2, width, z0, height) {
    translate([0, 0, z0])
        linear_extrude(height = height)
            hull() {
                translate(p1) circle(d = width, $fn = 20);
                translate(p2) circle(d = width, $fn = 20);
            }
}

module retention_x_cage_local() {
    // MakerWorld 590818-inspired concept: an open perimeter cage, diagonal
    // top trusses, and a separate slotted rear cap. This is reconstructed from
    // published photos rather than copied model geometry.
    retention_support_pads_local();
    cage_z = green_device_z - 0.8;
    cage_top_z = green_device_z + green_h + 0.35;
    brace_h = 0.65;
    cage_wall_h = cage_top_z + brace_h - cage_z + 0.10;

    // Full-depth side frames. Short underside webs connect each frame to the
    // four support pads so this represents a buildable cage rather than a
    // collection of floating viewer solids.
    translate([green_x - 3.0, green_y, cage_z])
        rounded_prism_z(2.6, green_d, cage_wall_h, 0.8);
    translate([green_x + green_w + 0.4, green_y, cage_z])
        rounded_prism_z(2.6, green_d, cage_wall_h, 0.8);
    for (y0 = [green_y + 1.0, green_y + green_d - 9.0]) {
        translate([green_x - 3.0, y0, cage_z - 0.10])
            rounded_prism_z(12.0, 8.0, 1.10, 0.65);
        translate([green_x + green_w - 9.0, y0, cage_z - 0.10])
            rounded_prism_z(12.0, 8.0, 1.10, 0.65);
    }

    // Reinforced X-shaped top brace. Each end overlaps a side frame, avoiding
    // the fragile floating/needle-node geometry reported on one community
    // print. It still crosses the Green's top vent field, which is one reason
    // this remains a comparison rather than the recommended concept.
    retention_beam_xy_local(
        [green_x - 1.7, green_y + 7.0],
        [green_x + green_w + 1.7, green_y + green_d - 7.0],
        4.0, cage_top_z, brace_h);
    retention_beam_xy_local(
        [green_x + green_w + 1.7, green_y + 7.0],
        [green_x - 1.7, green_y + green_d - 7.0],
        4.0, cage_top_z, brace_h);

    // Removable rear cap shown in its locked position: an open rectangular
    // frame drops vertically between paired guide rails behind the device.
    cap_y = green_y + green_d + 0.5;
    cap_left_x = green_x - 2.65;
    cap_right_x = green_x + green_w + 0.35;
    cap_post_w = 2.30;
    cap_depth = 2.0;
    guide_y = green_y + green_d - 0.7;
    guide_d = 4.4;
    guide_web_d = 0.7;
    cap_bar_y = guide_y + guide_d + 0.30;
    cap_post_d = cap_bar_y + cap_depth - cap_y;
    // Two guide pairs plus low webs make the sliding interface visible while
    // leaving 0.20 mm nominal side clearance around each cap upright.
    for (x0 = [green_x - 4.0, green_x - 0.15,
               green_x + green_w - 1.0,
               green_x + green_w + 2.85])
        translate([x0, guide_y, cage_z])
            rounded_prism_z(1.15, guide_d, cage_wall_h, 0.30);
    // Join each rail pair only at its front edge. Extending these webs through
    // the full guide depth would weld the installed cap posts to the cage.
    translate([green_x - 4.0, guide_y, cage_z - 0.10])
        rounded_prism_z(5.0, guide_web_d, 1.20, 0.32);
    translate([green_x + green_w - 1.0, guide_y, cage_z - 0.10])
        rounded_prism_z(5.0, guide_web_d, 1.20, 0.32);

    translate([cap_left_x, cap_y, cage_z])
        rounded_prism_z(cap_post_w, cap_post_d, green_h + 1.0, 0.65);
    translate([cap_right_x, cap_y, cage_z])
        rounded_prism_z(cap_post_w, cap_post_d, green_h + 1.0, 0.65);
    // Crossbars sit just behind the guide rails, so the cap remains a
    // genuinely separate removable shell instead of welding to the cage.
    translate([cap_left_x, cap_bar_y, cage_z])
        rounded_prism_z(cap_right_x + cap_post_w - cap_left_x,
                        cap_depth, 2.6, 0.65);
    translate([cap_left_x, cap_bar_y, cage_top_z - 2.0])
        rounded_prism_z(cap_right_x + cap_post_w - cap_left_x,
                        cap_depth, 2.7, 0.65);
    translate([green_x + green_w / 2 - 10.0,
               cap_bar_y + cap_depth - 0.2,
               cage_top_z - 1.5])
        rounded_prism_z(20.0, 3.5, 2.2, 0.8);
}

module friction_raised_deck_local() {
    // Compatibility name retained for older viewer exports. The current
    // raised deck is a translated 3 mm plate, not a filled 9.025 mm lattice.
    green_friction_deck_raised();
}

module honeycomb_tapered_openings_3d(
    w, h, pitch, wall_bottom, wall_top, transition_h) {
    cell_r = pitch / sqrt(3);
    bottom_r = (pitch - wall_bottom) / sqrt(3);
    top_r = (pitch - wall_top) / sqrt(3);
    pitch_x = 1.5 * cell_r;
    column_extent = ceil(w / pitch_x) + 2;
    row_extent = ceil(h / pitch) + 2;

    intersection() {
        cube([w, h, transition_h]);
        union()
            for (column = [-column_extent : column_extent])
                for (row = [-row_extent : row_extent])
                    translate([
                        w / 2 + column * pitch_x,
                        h / 2 + row * pitch
                            + ((abs(column) % 2) == 1 ? pitch / 2 : 0),
                        0
                    ])
                        linear_extrude(
                            height = transition_h,
                            scale = top_r / bottom_r)
                            circle(r = bottom_r, $fn = 6);
    }
}

module green_friction_deck_optimized() {
    cut_x = green_x + green_honeycomb_inset;
    cut_y = green_y + green_honeycomb_inset;
    cut_w = green_inner_w - 2 * green_honeycomb_inset;
    cut_d = green_inner_d - 2 * green_honeycomb_inset;
    top_z = green_device_z;
    transition_top = top_z - friction_honeycomb_top_h;
    transition_bottom = transition_top - friction_honeycomb_transition_h;

    difference() {
        // Keep the exact full perimeter through the complete 9.025 mm height.
        linear_extrude(height = top_z)
            green_tray_outer_outline_2d();

        // Hidden lower lattice: same registered 15 mm grid, reduced to three
        // 0.4 mm extrusion lines for a better stiffness/filament compromise.
        translate([0, 0, -epsilon])
            linear_extrude(height = transition_bottom + epsilon)
                green_honeycomb_cutouts_2d(
                    preserve_screw_pads = false,
                    honeycomb_wall_value =
                        friction_lower_honeycomb_wall);

        // Enlarge each hole toward the lower section. The 0.4 mm radial rib
        // growth over 0.5 mm rises no faster than 45 degrees.
        translate([cut_x, cut_y, transition_bottom])
            honeycomb_tapered_openings_3d(
                cut_w, cut_d, green_honeycomb_pitch,
                friction_lower_honeycomb_wall,
                green_honeycomb_wall,
                friction_honeycomb_transition_h);

        // Preserve the current 15 mm / 1.8 mm contact lattice for the top
        // 2.5 mm directly beneath the Green.
        translate([0, 0, transition_top])
            linear_extrude(height = friction_honeycomb_top_h + epsilon)
                green_honeycomb_cutouts_2d(
                    preserve_screw_pads = false,
                    honeycomb_wall_value = green_honeycomb_wall);

        // The legacy hole coordinates remain available for measurement and
        // cannot become hidden columns in the optimized pad-free deck.
        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y, -epsilon])
                    cylinder(h = top_z + 2 * epsilon,
                             d = green_mount_hole_d, $fn = 28);
    }
}

// Stable reference used by the production/viewer friction tray.  This is the
// exact original Green floor footprint and 15 mm / 1.8 mm honeycomb carried
// continuously to the normal Green seating plane.
module green_friction_deck_full() {
    linear_extrude(height = green_device_z)
        green_tray_floor_2d(preserve_screw_pads = false);
}

// Four broad annular lands centered on the factory mounting-hole locations.
// The pads are clipped to the exact rounded tray silhouette (the front pair
// would otherwise exceed it by 0.30 mm) and retain the original through holes.
module green_friction_support_pads_local() {
    pad_overlap = 0.20;

    difference() {
        intersection() {
            union()
                for (x = green_mount_x)
                    for (y = green_mount_y)
                        translate([x, y, base_thickness - pad_overlap])
                            cylinder(
                                h = green_device_z - base_thickness
                                    + pad_overlap,
                                r = green_screw_pad_r, $fn = 48);

            linear_extrude(height = green_device_z)
                green_tray_outer_outline_2d();
        }

        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y, base_thickness - 2 * pad_overlap])
                    cylinder(
                        h = green_device_z - base_thickness
                            + 3 * pad_overlap,
                        d = green_mount_hole_d, $fn = 28);
    }
}

// Original 3 mm honeycomb floor plus four integrated support lands.  This is
// intentionally a comparison model: the Green is carried at four known screw
// lands rather than by a continuous lattice immediately beneath its base.
module green_friction_deck_pads() {
    union() {
        linear_extrude(height = base_thickness)
            green_tray_floor_2d(preserve_screw_pads = true);
        green_friction_support_pads_local();
    }
}

// New production deck: translate the original thin honeycomb upward instead
// of filling the volume beneath it. Its top is exactly the existing Green
// seating plane, so the device needs no separate riser columns. Solid annular
// lands and through holes remain available for optional screw installation.
module green_friction_deck_raised() {
    translate([0, 0, unified_deck_z0])
        linear_extrude(height = base_thickness)
            green_tray_floor_2d(preserve_screw_pads = true);
}

module green_friction_skeletal_base_2d() {
    frame_w = 5.0;
    crossbar_w = 7.0;
    spine_w = 7.0;
    outer_x = green_x - wall_thickness;
    outer_y = face_thickness - 0.20;
    outer_w = green_inner_w + 2 * wall_thickness;
    outer_d = green_inner_d + (green_y - face_thickness)
        + wall_thickness;

    difference() {
        intersection() {
            green_tray_outer_outline_2d();
            union() {
                // Continuous exact-perimeter frame carries both side walls.
                difference() {
                    green_tray_outer_outline_2d();
                    offset(delta = -frame_w)
                        green_tray_outer_outline_2d();
                }

                // Load paths through both pad rows and the device center.
                for (y = green_mount_y)
                    translate([outer_x, y - crossbar_w / 2])
                        square([outer_w, crossbar_w]);
                translate([
                    green_x + green_w / 2 - spine_w / 2,
                    outer_y
                ]) square([spine_w, outer_d]);

                // Preserve a full bearing land beneath every raised pad.
                for (x = green_mount_x)
                    for (y = green_mount_y)
                        translate([x, y])
                            circle(r = green_screw_pad_r, $fn = 48);
            }
        }

        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y])
                    circle(d = green_mount_hole_d, $fn = 28);
    }
}

// Open comparison base: exact outer frame, two transverse load paths, one
// center spine, and the same four broad support lands as the pad version.
module green_friction_deck_skeletal() {
    union() {
        linear_extrude(height = base_thickness)
            green_friction_skeletal_base_2d();
        green_friction_support_pads_local();
    }
}

module friction_side_walls_local(
    interference = friction_interference,
    wall_z_override = base_thickness - 0.20) {
    outer_left = green_x - wall_thickness;
    outer_right = green_x + green_inner_w + wall_thickness;
    inner_left = green_x + interference;
    inner_right = green_x + green_w - interference;
    left_w = inner_left - outer_left;
    right_w = outer_right - inner_right;
    wall_y = green_y - 0.20;
    wall_d = green_inner_d + 0.20;
    wall_z = wall_z_override;
    base_grip_top = green_device_z + green_lower_base_h;
    cover_relief_top = base_grip_top + green_cover_relief_h;
    guide_top = green_device_z + friction_grip_h + friction_lead_h;
    cover_left = green_x - (green_cover_w - green_w) / 2
                 - green_cover_side_clearance;
    cover_right = green_x + green_w + (green_cover_w - green_w) / 2
                  + green_cover_side_clearance;
    cover_left_w = cover_left - outer_left;
    cover_right_w = outer_right - cover_right;

    intersection() {
        union() {
            // Grip only the physically measured lower footprint, then relieve
            // the wall before the measured taper begins so the upper shell is
            // not pinched when the lower-base coupon is correct.
            extrude_xz_profile_y([
                [outer_left, wall_z],
                [inner_left, wall_z],
                [inner_left, base_grip_top],
                [cover_left, cover_relief_top],
                [cover_left, guide_top],
                [outer_left, guide_top]
            ], wall_y, wall_d);
            extrude_xz_profile_y([
                [inner_right, wall_z],
                [outer_right, wall_z],
                [outer_right, guide_top],
                [cover_right, guide_top],
                [cover_right, cover_relief_top],
                [inner_right, base_grip_top]
            ], wall_y, wall_d);
        }

        // Preserve the exact floor silhouette at the rounded end corners.
        translate([0, 0, wall_z])
            linear_extrude(height = guide_top - wall_z)
                green_tray_outer_outline_2d();
    }
}

module friction_end_stops_local(
    include_front = true,
    include_rear = true) {
    outer_y = face_thickness - 0.20;
    outer_d = green_inner_d + (green_y - face_thickness) + wall_thickness;
    inner_left = green_x + friction_interference;
    inner_right = green_x + green_w - friction_interference;
    wall_overlap = 0.20;
    stop_x = inner_left - wall_overlap;
    stop_w = inner_right - inner_left + 2 * wall_overlap;
    stop_z = green_device_z - 0.20;
    stop_h = 4.20;
    silhouette_margin = 0.20;
    front_y = outer_y + silhouette_margin;
    front_d = green_y - 0.15 - front_y;
    rear_y = green_y + green_d + 0.15;
    rear_d = outer_y + outer_d - silhouette_margin - rear_y;
    rear_corner_w = 14.0;

    // One low integrated front stop and two low rear corner stops mirror the
    // simple UniFi-style case. The rear center remains fully open for ports.
    if (include_front)
        translate([stop_x, front_y, stop_z])
            rounded_prism_z(stop_w, front_d, stop_h, 0.8);
    if (include_rear) {
        translate([stop_x, rear_y, stop_z])
            rounded_prism_z(
                rear_corner_w + wall_overlap,
                rear_d, stop_h, small_end_r);
        translate([inner_right - rear_corner_w, rear_y, stop_z])
            rounded_prism_z(
                rear_corner_w + wall_overlap,
                rear_d, stop_h, small_end_r);
    }
}

// Pad and skeletal bases do not have a full-height lattice below the stops.
// These webs fill only the existing stop footprints down to the 3 mm base, so
// the visible stop outline and device clearances stay unchanged while the part
// remains support-free when printed faceplate-down.
module friction_end_stop_supports_local(
    include_front = true,
    include_rear = true) {
    outer_y = face_thickness - 0.20;
    outer_d = green_inner_d + (green_y - face_thickness) + wall_thickness;
    inner_left = green_x + friction_interference;
    inner_right = green_x + green_w - friction_interference;
    wall_overlap = 0.20;
    stop_x = inner_left - wall_overlap;
    stop_w = inner_right - inner_left + 2 * wall_overlap;
    silhouette_margin = 0.20;
    front_y = outer_y + silhouette_margin;
    front_d = green_y - 0.15 - front_y;
    rear_y = green_y + green_d + 0.15;
    rear_d = outer_y + outer_d - silhouette_margin - rear_y;
    rear_corner_w = 14.0;
    support_z = base_thickness - 0.20;
    support_h = green_device_z - support_z;

    intersection() {
        union() {
            if (include_front)
                translate([stop_x, front_y, support_z])
                    rounded_prism_z(
                        stop_w, front_d, support_h, 0.8);
            if (include_rear) {
                translate([stop_x, rear_y, support_z])
                    rounded_prism_z(
                        rear_corner_w + wall_overlap,
                        rear_d, support_h, small_end_r);
                translate([
                    inner_right - rear_corner_w,
                    rear_y, support_z
                ]) rounded_prism_z(
                        rear_corner_w + wall_overlap,
                        rear_d, support_h, small_end_r);
            }
        }

        translate([0, 0, support_z])
            linear_extrude(height = support_h)
                green_tray_outer_outline_2d();
    }
}

module retention_friction_sleeve_local(include_raised_deck = true) {
    // Compatibility overlay for older viewer builds. The current whole-tray
    // contract uses these same smooth walls and stops as part of one tray mesh.
    if (include_raised_deck) friction_raised_deck_local();
    friction_side_walls_local();
    friction_end_stops_local();
}

// Complete whole-tray replacement for the browser's friction-fit choice.
// Unlike the compatibility overlay above, this starts at Z=0 and carries one
// pad-free tray floor continuously to the normal Green device height.
module green_tray_friction_local() {
    union() {
        green_friction_deck_full();
        friction_side_walls_local();
        friction_end_stops_local();
    }
}

module green_tray_friction_full_local() {
    green_tray_friction_local();
}

module green_tray_friction_raised_local() {
    union() {
        green_friction_deck_raised();
        friction_side_walls_local(
            wall_z_override = unified_deck_z0 - 0.20);
        friction_end_stops_local();
    }
}

module green_tray_friction_pads_local() {
    union() {
        green_friction_deck_pads();
        friction_side_walls_local();
        friction_end_stop_supports_local();
        friction_end_stops_local();
    }
}

module green_tray_friction_skeletal_local() {
    union() {
        green_friction_deck_skeletal();
        friction_side_walls_local();
        friction_end_stop_supports_local();
        friction_end_stops_local();
    }
}

module friction_fit_coupon_single(interference = 0.10,
                                  marker_count = 1) {
    coupon_w = green_w + 2 * wall_thickness;
    coupon_d = 14.0;
    coupon_base_h = 2.0;
    inner_left = wall_thickness + interference;
    inner_right = wall_thickness + green_w - interference;
    grip_top = coupon_base_h + friction_grip_h;
    lead_top = grip_top + friction_lead_h;
    slice_h = 0.40;

    difference() {
        union() {
            rounded_prism_z(coupon_w, coupon_d, coupon_base_h, 1.2);

            translate([0, 0, 0])
                rounded_prism_z(inner_left, coupon_d, grip_top, 0.55);
            translate([inner_right, 0, 0])
                rounded_prism_z(coupon_w - inner_right,
                                coupon_d, grip_top, 0.55);

            hull() {
                translate([0, 0, grip_top - slice_h / 2])
                    rounded_prism_z(inner_left, coupon_d,
                                    slice_h, 0.55);
                translate([0, 0, lead_top - slice_h])
                    rounded_prism_z(inner_left - friction_lead_relief,
                                    coupon_d, slice_h, 0.55);
            }
            hull() {
                translate([inner_right, 0, grip_top - slice_h / 2])
                    rounded_prism_z(coupon_w - inner_right,
                                    coupon_d, slice_h, 0.55);
                translate([inner_right + friction_lead_relief, 0,
                           lead_top - slice_h])
                    rounded_prism_z(
                        coupon_w - inner_right - friction_lead_relief,
                        coupon_d, slice_h, 0.55);
            }
        }

        // One, two, or three small through-holes identify the 0.25, 0.30,
        // and 0.35 mm-per-side follow-up coupons after the first 0.00/0.10/
        // 0.20 test showed that 0.20 was only a near-perfect clearance fit.
        for (mark = [0 : marker_count - 1])
            translate([7.0 + mark * 4.0, coupon_d / 2, -epsilon])
                cylinder(h = coupon_base_h + 2 * epsilon,
                         d = 2.0, $fn = 20);
    }
}

module friction_fit_coupon() {
    values = [0.25, 0.30, 0.35];
    for (index = [0 : len(values) - 1])
        translate([0, index * 20.0, 0])
            friction_fit_coupon_single(
                interference = values[index], marker_count = index + 1);
}

// Compact single-edge Green clip gauge. Keep the production 18 mm catch,
// full-height spring and 9.025 mm device seat, but carry the device on two
// printable ribs instead of a solid 10 mm-deep pedestal. The 3 mm margin at
// each end and broad root rail prevent the coupon itself from twisting and
// making the spring appear softer than it will be in the complete tray.
module green_hybrid_clip_coupon_single(reach = hybrid_green_clip_reach) {
    coupon_len = hybrid_green_clip_len + 6.0;
    clip_y0 = (coupon_len - hybrid_green_clip_len) / 2;
    cover_outset = (green_cover_w - green_w) / 2;
    top_edge_x = 0.0;
    inner = -cover_outset - hybrid_green_cover_clearance;
    outer = inner - hybrid_green_spring_arm_t;
    // Match the production perimeter floor; the reinforced root hull below
    // extends farther outward only beneath the active spring.
    root_outer = -3.50;
    root_inner = 4.00;
    seat_x0 = 0.0;
    seat_x1 = 10.0;
    seat_pad_t = 1.40;
    seat_pad_len = 6.0;
    seat_under_z = green_device_z - seat_pad_t;
    rib_z0 = base_thickness - 0.20;
    rib_top_z = seat_under_z + 0.20;
    rib_foot_x0 = 4.50;
    rib_foot_x1 = 5.50;
    tongue_x0 = 3.80;
    tongue_x1 = 5.70;
    catch_z = green_device_z + green_h + hybrid_green_clip_clearance;
    bevel_start_z = green_device_z + green_h
                    - green_cover_upper_bevel_h;
    bevel_follow_x = top_edge_x - hybrid_green_cover_clearance;
    flat_x = inner + reach - hybrid_green_catch_flat;
    tip_x = inner + reach;
    nose_top_z = catch_z + hybrid_green_catch_nose_t;
    tip_top_z = catch_z + hybrid_green_catch_tip_t;
    shoulder_x = tip_x - hybrid_green_catch_tip_bevel;
    clip_root_outer_x = outer - 0.9;
    clip_root_inner_x = inner + 0.9;

    union() {
        // Full-length root strip matches the production floor thickness while
        // omitting the unused solid floor beneath the device.
        translate([root_outer, 0, 0])
            rounded_prism_z(
                root_inner - root_outer, coupon_len,
                base_thickness, 0.55);

        // Two known-height pads locate the bottom plane. Their printable ribs
        // overlap small floor tongues connected to the root rail.
        for (y0 = [clip_y0,
                   clip_y0 + hybrid_green_clip_len - seat_pad_len]) {
            translate([tongue_x0, y0, 0])
                rounded_prism_z(
                    tongue_x1 - tongue_x0, seat_pad_len,
                    base_thickness, 0.35);
            extrude_xz_profile_y([
                [rib_foot_x0, rib_z0],
                [rib_foot_x1, rib_z0],
                [seat_x1, rib_top_z],
                [seat_x0, rib_top_z]
            ], y0, seat_pad_len);
            translate([seat_x0, y0, seat_under_z])
                rounded_prism_z(
                    seat_x1 - seat_x0, seat_pad_len,
                    seat_pad_t, 0.40);
        }

        // One clean profile reproduces the production spring without union
        // ridges, rounded-end ears, or a separate release-tab bulge.
        extrude_xz_profile_y([
            [clip_root_outer_x, 0],
            [clip_root_inner_x, 0],
            [clip_root_inner_x, 1.4],
            [inner, 3.8],
            [inner, bevel_start_z],
            [bevel_follow_x, green_device_z + green_h],
            [flat_x, catch_z],
            [tip_x, catch_z],
            [tip_x, tip_top_z],
            [shoulder_x, nose_top_z],
            [flat_x, nose_top_z],
            [inner, catch_z + hybrid_green_top_ramp_h],
            [outer, catch_z + hybrid_green_top_ramp_h]
        ], clip_y0, hybrid_green_clip_len);
    }
}

module green_hybrid_clip_coupon() {
    green_hybrid_clip_coupon_single();
}

module splitter_fit_coupon_single(interference = 0.05,
                                  marker_count = 1) {
    coupon_w = splitter_inner_w + 2 * wall_thickness;
    coupon_d = 14.0;
    coupon_base_h = 2.0;
    side_nominal = (coupon_w - splitter_w) / 2;
    inner_left = side_nominal + interference;
    inner_right = side_nominal + splitter_w - interference;
    grip_top = coupon_base_h + splitter_friction_grip_h;
    lead_top = grip_top + splitter_friction_lead_h;
    slice_h = 0.40;

    difference() {
        union() {
            rounded_prism_z(coupon_w, coupon_d, coupon_base_h, 1.2);

            rounded_prism_z(inner_left, coupon_d, grip_top, 0.55);
            translate([inner_right, 0, 0])
                rounded_prism_z(coupon_w - inner_right,
                                coupon_d, grip_top, 0.55);

            hull() {
                translate([0, 0, grip_top - slice_h / 2])
                    rounded_prism_z(inner_left, coupon_d,
                                    slice_h, 0.55);
                translate([0, 0, lead_top - slice_h])
                    rounded_prism_z(
                        inner_left - splitter_friction_lead_relief,
                        coupon_d, slice_h, 0.55);
            }
            hull() {
                translate([inner_right, 0, grip_top - slice_h / 2])
                    rounded_prism_z(coupon_w - inner_right,
                                    coupon_d, slice_h, 0.55);
                translate([inner_right + splitter_friction_lead_relief,
                           0, lead_top - slice_h])
                    rounded_prism_z(
                        coupon_w - inner_right
                            - splitter_friction_lead_relief,
                        coupon_d, slice_h, 0.55);
            }
        }

        // Hole count identifies 0.00, 0.05, and 0.10 mm interference/side.
        for (mark = [0 : marker_count - 1])
            translate([7.0 + mark * 4.0, coupon_d / 2, -epsilon])
                cylinder(h = coupon_base_h + 2 * epsilon,
                         d = 2.0, $fn = 20);
    }
}

module splitter_fit_coupon() {
    values = [0.00, 0.05, 0.10];
    for (index = [0 : len(values) - 1])
        translate([0, index * 20.0, 0])
            splitter_fit_coupon_single(
                interference = values[index], marker_count = index + 1);
}

// Compact production-fit coupon for the selected TP-Link hybrid retention.
// It preserves the exact production mirrored rigid catches, full-height
// wall profiles, and both clip roots. Two narrow transverse seat bars hold the
// production spacing and device height without printing a non-load-bearing
// solid floor across the open center of this short test section.
module splitter_hybrid_clip_coupon_single() {
    slice_d = 20.0;
    seat_bar_d = 5.0;
    root_rail_w = 6.0;
    clip_y0 = (splitter_d - hybrid_splitter_clip_len) / 2;
    slice_y0 = clip_y0
               - (slice_d - hybrid_splitter_clip_len) / 2;
    outer_left = -splitter_clearance - wall_thickness;
    outer_right = splitter_w + splitter_clearance + wall_thickness;
    coupon_left = outer_left;
    coupon_right = outer_right;

    translate([-coupon_left, -slice_y0, 0])
        intersection() {
            union() {
                // Two crossbars preserve the production wall spacing and give
                // the device two coplanar seats at the normal 3 mm height.
                translate([coupon_left, slice_y0, 0])
                    cube([
                        coupon_right - coupon_left,
                        seat_bar_d,
                        base_thickness
                    ]);
                translate([coupon_left,
                           slice_y0 + slice_d - seat_bar_d, 0])
                    cube([
                        coupon_right - coupon_left,
                        seat_bar_d,
                        base_thickness
                    ]);

                // Full-length root rails support the cropped production walls
                // between the crossbars without an external clip outrigger.
                translate([outer_left, slice_y0, 0])
                    cube([
                        root_rail_w,
                        slice_d,
                        base_thickness
                    ]);
                translate([outer_right - root_rail_w,
                           slice_y0, 0])
                    cube([
                        root_rail_w,
                        slice_d,
                        base_thickness
                    ]);

                retention_splitter_hybrid_clips_local(
                    clip_reach = hybrid_splitter_clip_reach,
                    clip_y_override = clip_y0);
            }
            translate([coupon_left - epsilon,
                       slice_y0 - epsilon, -epsilon])
                cube([
                    coupon_right - coupon_left + 2 * epsilon,
                    slice_d + 2 * epsilon,
                    rack_height + 2 * epsilon
                ]);
        }
}

module splitter_hybrid_clip_coupon() {
    splitter_hybrid_clip_coupon_single();
}

// One small print containing the selected Green and TP-Link clip gauges. The
// 12 mm gap leaves room for a 5 mm brim around the tall Green spring without
// joining the two roots and changing their flex behavior.
module hybrid_clip_coupon() {
    splitter_hybrid_clip_coupon();
    translate([80.0, 0, 0]) green_hybrid_clip_coupon();
}

// Extrude a Z/Y profile through X. The profile's first coordinate maps to Z.
module airframe_extrude_x(x0, thickness) {
    translate([x0 + thickness, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = thickness)
                children();
}

// Complete, vertically stretched cells only. Unlike the tray-floor honeycomb,
// this does not clip partial cells at the aperture boundary: a clipped top
// cell would create a flat bridge in a vertical wall. The short shoulders make
// each opening read as a hexagon, while the upper edges stay steeper than 45
// degrees for support-free faceplate-down printing.
module airframe_honeycomb_openings_2d(w, h, pitch, wall) {
    hole_z_r = (pitch - wall) / 2;
    hole_y_r = hole_z_r * 0.88;
    shoulder_z = 0.40;
    pitch_z = pitch;
    pitch_y = 2 * hole_y_r + wall;
    column_count = max(1, floor((w - 2 * hole_z_r) / pitch_z) + 1);
    z_start = (w - (column_count - 1) * pitch_z) / 2;
    row_extent = ceil(h / pitch_y) + 2;

    for (column = [0 : column_count - 1])
        for (row = [-row_extent : row_extent]) {
            zc = z_start + column * pitch_z;
            yc = h / 2 + row * pitch_y
                + ((column % 2) == 1 ? pitch_y / 2 : 0);
            if (zc - hole_z_r >= 0 && zc + hole_z_r <= w
                && yc - hole_y_r >= 0 && yc + hole_y_r <= h)
                polygon(points = [
                    [zc + hole_z_r, yc],
                    [zc + shoulder_z, yc + hole_y_r],
                    [zc - shoulder_z, yc + hole_y_r],
                    [zc - hole_z_r, yc],
                    [zc - shoulder_z, yc - hole_y_r],
                    [zc + shoulder_z, yc - hole_y_r]
                ]);
        }
}

module airframe_cable_portal_2d(y0, y1, z_low, z_edge, z_apex) {
    y_mid = (y0 + y1) / 2;

    // Broad at cable height, with one rounded upper apex instead of a bridge.
    offset(r = 0.8)
        offset(delta = -0.8)
            polygon(points = [
                [z_low, y0],
                [z_low, y1],
                [z_edge, y1],
                [z_apex, y_mid],
                [z_edge, y0]
            ]);
}

module airframe_side_wall_x(x0, y0, depth, z0, height,
                            cable_portal = false,
                            portal_y0 = 0,
                            portal_y1 = 0) {
    inner_z = height - 2 * airframe_border;
    inner_y = depth - 2 * airframe_border;
    portal_local_y0 = portal_y0 - y0;
    portal_local_y1 = portal_y1 - y0;
    portal_z_low = 6.0 - z0;
    portal_z_edge = 22.0 - z0;
    portal_z_apex = min(27.0 - z0,
                        height - airframe_border - 0.30);

    difference() {
        airframe_extrude_x(x0, airframe_wall_t)
            translate([z0, y0])
                rounded_rect_2d(height, depth, airframe_corner_r);

        // Keep a solid perimeter plus an extra 2.4 mm around the cable portal
        // so nearby honeycomb cells cannot leave a thin or isolated roof rib.
        airframe_extrude_x(x0 - epsilon,
                           airframe_wall_t + 2 * epsilon)
            translate([z0, y0])
                difference() {
                    translate([airframe_border, airframe_border])
                        airframe_honeycomb_openings_2d(
                            inner_z, inner_y,
                            airframe_honeycomb_pitch,
                            airframe_honeycomb_wall);
                    if (cable_portal)
                        offset(delta = 2.4)
                            airframe_cable_portal_2d(
                                portal_local_y0, portal_local_y1,
                                portal_z_low, portal_z_edge,
                                portal_z_apex);
                }

        if (cable_portal)
            airframe_extrude_x(x0 - epsilon,
                               airframe_wall_t + 2 * epsilon)
                translate([z0, y0])
                    airframe_cable_portal_2d(
                        portal_local_y0, portal_local_y1,
                        portal_z_low, portal_z_edge,
                        portal_z_apex);
    }
}

module airframe_green_wall_clipped(x0, y0, depth, z0, height) {
    intersection() {
        airframe_side_wall_x(x0, y0, depth, z0, height);
        translate([0, 0, z0 - epsilon])
            linear_extrude(height = height + 2 * epsilon)
                green_tray_outer_outline_2d();
    }
}

module airframe_splitter_wall_clipped(x0, y0, depth, z0, height) {
    intersection() {
        airframe_side_wall_x(x0, y0, depth, z0, height);
        translate([splitter_x, splitter_y, z0 - epsilon])
            linear_extrude(height = height + 2 * epsilon)
                splitter_tray_outer_outline_2d();
    }
}

// The legacy tray outline includes its clearance allowance on only the right
// side. Center this comparison sleeve's floor on the measured Green instead,
// so its roof, wall borders, and honeycomb are true left/right mirrors.
module green_sleeve_outer_outline_2d() {
    outer_w = green_w - 2 * sleeve_green_interference
              + 2 * sleeve_green_frame_t;
    outer_x = green_x + green_w / 2 - outer_w / 2;
    outer_y = face_thickness - 0.20;
    outer_d = green_inner_d + (green_y - face_thickness)
              + wall_thickness;

    translate([outer_x, outer_y])
        front_rounded_rect_2d(outer_w, outer_d, tray_corner_r);
}

module splitter_sleeve_outer_outline_2d() {
    outer_x = -splitter_clearance - wall_thickness;
    outer_y = -splitter_clearance - wall_thickness;
    outer_w = splitter_inner_w + 2 * wall_thickness;
    outer_d = splitter_inner_d + 2 * wall_thickness;

    translate([outer_x, outer_y])
        front_rounded_rect_2d(outer_w, outer_d, tray_corner_r);
}

module splitter_sleeve_floor_2d() {
    difference() {
        splitter_sleeve_outer_outline_2d();
        splitter_honeycomb_cutouts_2d();
    }
}

module green_sleeve_floor_2d(preserve_screw_pads = true) {
    cut_w = green_inner_w - 2 * green_honeycomb_inset;
    cut_x = green_x + green_w / 2 - cut_w / 2;
    cut_y = green_y + green_honeycomb_inset;
    cut_d = green_inner_d - 2 * green_honeycomb_inset;

    difference() {
        green_sleeve_outer_outline_2d();

        difference() {
            translate([cut_x, cut_y])
                honeycomb_openings_2d(
                    cut_w, cut_d,
                    green_honeycomb_pitch, green_honeycomb_wall);

            if (preserve_screw_pads)
                for (x = green_mount_x)
                    for (y = green_mount_y)
                        translate([x, y])
                            circle(r = green_screw_pad_r, $fn = 36);
        }

        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y])
                    circle(d = green_mount_hole_d, $fn = 28);
    }
}

module green_sleeve_support_pads_local() {
    pad_overlap = 0.20;

    difference() {
        intersection() {
            union()
                for (x = green_mount_x)
                    for (y = green_mount_y)
                        translate([x, y, base_thickness - pad_overlap])
                            cylinder(
                                h = green_device_z - base_thickness
                                    + pad_overlap,
                                r = green_screw_pad_r, $fn = 48);

            linear_extrude(height = green_device_z)
                green_sleeve_outer_outline_2d();
        }

        for (x = green_mount_x)
            for (y = green_mount_y)
                translate([x, y, base_thickness - 2 * pad_overlap])
                    cylinder(
                        h = green_device_z - base_thickness
                            + 3 * pad_overlap,
                        d = green_mount_hole_d, $fn = 28);
    }
}

module green_sleeve_floor_pads() {
    union() {
        linear_extrude(height = base_thickness)
            green_sleeve_floor_2d(preserve_screw_pads = true);
        green_sleeve_support_pads_local();
    }
}

module green_sleeve_floor_raised() {
    translate([0, 0, unified_deck_z0])
        linear_extrude(height = base_thickness)
            green_sleeve_floor_2d(preserve_screw_pads = true);
}

// Mauker-style side frame: keep a substantial tapered wall profile and remove
// one or more large capsule windows. The outer silhouette deliberately stays
// square at the roof/floor seams, creating full-length, flush load paths; the
// visible vent openings carry the generous rounded profile.
module sleeve_profiled_side_frame_x(
    profile, y0, depth, cut_x0, cut_w,
    openings) {
    difference() {
        extrude_xz_profile_y(profile, y0, depth);

        airframe_extrude_x(
            cut_x0 - 2 * epsilon, cut_w + 4 * epsilon)
            for (opening = openings)
                translate([opening[0], opening[1]])
                    rounded_rect_2d(
                        opening[2], opening[3], opening[4]);
    }
}

// Thin honeycomb roof with one constant, flat underside from front to rear.
// The cage coupon now tests this exact fit instead of a relaxed insertion end.
module sleeve_roof_panel_local(
    x0, y0, width, depth, z0, thickness,
    pitch, wall, border, corner_r) {
    difference() {
        translate([x0, y0, z0])
            linear_extrude(height = thickness)
                front_rounded_rect_2d(width, depth, corner_r);

        translate([x0 + border, y0 + border, z0 - epsilon])
            linear_extrude(height = thickness + 2 * epsilon)
                honeycomb_openings_2d(
                    width - 2 * border,
                    depth - 2 * border,
                    pitch, wall);
    }
}

// Rear-loading Green sleeve with Mauker-style rounded side frames. One large
// capsule vent leaves most of each side open while a thick lower rail, roof
// rail, and end blocks create a strong continuous frame.
// The thin honeycomb sits directly at the device seating plane, matching the
// raised TP-Link floor and bridge without separate support columns.
module retention_green_ventilated_sleeve_local() {
    sleeve_y0 = face_thickness - 0.20;
    sleeve_depth = green_inner_d + (green_y - face_thickness)
                   + wall_thickness;
    wall_z0 = unified_deck_z0 - 0.20;
    // The broad honeycomb roof flexes upward over the measured top. Its
    // 0.40 mm preload plus the 1.60 mm roof keeps the complete cage
    // below the 44.45 mm front-panel outline without moving the device or LEDs.
    // Its underside and both side-fit profiles remain constant front-to-back.
    roof_z0 = green_device_z + green_h
              - sleeve_green_vertical_interference;
    roof_top = roof_z0 + sleeve_roof_t;
    inner_left = green_x + sleeve_green_interference;
    inner_right = green_x + green_w - sleeve_green_interference;
    top_left = green_x + (green_w - green_top_w) / 2
               + sleeve_green_interference;
    top_right = green_x + (green_w + green_top_w) / 2
                - sleeve_green_interference;
    outer_left = inner_left - sleeve_green_frame_t;
    outer_right = inner_right + sleeve_green_frame_t;
    upper_taper_start = green_device_z + green_taper_start_h;
    opening_z0 = sleeve_green_frame_open_z;
    opening_h = sleeve_green_frame_open_h;
    opening_d = sleeve_depth - 2 * sleeve_green_frame_end_border;
    opening_y0 = sleeve_y0 + sleeve_green_frame_end_border;
    frame_openings = [[
        opening_z0, opening_y0,
        opening_h, opening_d, opening_h / 2
    ]];
    left_profile = [
        [outer_left, wall_z0],
        [inner_left, wall_z0],
        [inner_left, upper_taper_start],
        [top_left, roof_z0],
        [top_left, roof_top],
        [outer_left, roof_top]
    ];
    right_profile = [
        [inner_right, wall_z0],
        [outer_right, wall_z0],
        [outer_right, roof_top],
        [top_right, roof_top],
        [top_right, roof_z0],
        [inner_right, upper_taper_start]
    ];
    union() {
        green_sleeve_floor_raised();
        friction_end_stops_local(include_rear = false);

        intersection() {
            // Keep the complete fit profile constant from front to rear. The
            // device now sees the same lateral preload at the insertion end as
            // it does through the rest of the rounded cage.
            union() {
                sleeve_profiled_side_frame_x(
                    left_profile,
                    sleeve_y0, sleeve_depth,
                    outer_left,
                    top_left - outer_left,
                    frame_openings);
                sleeve_profiled_side_frame_x(
                    right_profile,
                    sleeve_y0, sleeve_depth,
                    top_right,
                    outer_right - top_right,
                    frame_openings);
            }

            // Match the floor and roof's exact rounded plan footprint so the
            // side-frame corners cannot overhang either horizontal face.
            translate([0, 0, wall_z0])
                linear_extrude(height = roof_top - wall_z0)
                    green_sleeve_outer_outline_2d();
        }

        sleeve_roof_panel_local(
            outer_left, sleeve_y0,
            outer_right - outer_left, sleeve_depth,
            roof_z0, sleeve_roof_t,
            sleeve_green_roof_pitch,
            sleeve_green_roof_wall,
            sleeve_roof_border, tray_corner_r);
    }
}

// Matching TP-Link sleeve with one long capsule vent in each side frame. Its
// six-millimeter upper/lower rails and seven-millimeter end blocks follow the
// measured bevels while leaving most of the small enclosure exposed.
module retention_splitter_ventilated_sleeve_local() {
    outer_left = -splitter_clearance - wall_thickness;
    outer_right = splitter_w + splitter_clearance + wall_thickness;
    inner_left = splitter_friction_interference;
    inner_right = splitter_w - splitter_friction_interference;
    outer_y = -splitter_clearance - wall_thickness;
    outer_depth = splitter_inner_d + 2 * wall_thickness;
    wall_z0 = base_thickness - 0.20;
    lower_inner_left = inner_left + splitter_lower_bevel_inset;
    lower_inner_right = inner_right - splitter_lower_bevel_inset;
    lower_bevel_top = base_thickness + splitter_lower_bevel_h;
    upper_bevel_bottom = lower_bevel_top + splitter_flat_side_h;
    top_inner_left = splitter_upper_bevel_inset
                     + splitter_friction_interference;
    top_inner_right = splitter_w - splitter_upper_bevel_inset
                      - splitter_friction_interference;
    roof_z0 = base_thickness + splitter_h;
    roof_top = roof_z0 + sleeve_roof_t;
    frame_openings = [[
        sleeve_splitter_frame_open_z,
        outer_y + sleeve_splitter_frame_end_border,
        sleeve_splitter_frame_open_h,
        outer_depth - 2 * sleeve_splitter_frame_end_border,
        sleeve_splitter_frame_open_h / 2
    ]];
    left_profile = [
        [outer_left, wall_z0],
        [lower_inner_left, wall_z0],
        [inner_left, lower_bevel_top],
        [inner_left, upper_bevel_bottom],
        [top_inner_left, roof_z0],
        [top_inner_left, roof_top],
        [outer_left, roof_top]
    ];
    right_profile = [
        [lower_inner_right, wall_z0],
        [outer_right, wall_z0],
        [outer_right, roof_top],
        [top_inner_right, roof_top],
        [top_inner_right, roof_z0],
        [inner_right, upper_bevel_bottom],
        [inner_right, lower_bevel_top]
    ];
    union() {
        linear_extrude(height = base_thickness)
            splitter_sleeve_floor_2d();
        splitter_end_stops_local(include_rear = false);

        intersection() {
            // Keep the complete measured bevel profile constant from front to
            // rear. The former six-millimeter rear cavity flare widened the
            // inner wall only at the insertion end, leaving a visible notch
            // where that flare met the continuous upper bevel. This sleeve is
            // intended to be a snug flex fit, so its side frames need no
            // separate lead-relief cut.
            union() {
                sleeve_profiled_side_frame_x(
                    left_profile,
                    outer_y, outer_depth,
                    outer_left, top_inner_left - outer_left,
                    frame_openings);
                sleeve_profiled_side_frame_x(
                    right_profile,
                    outer_y, outer_depth,
                    top_inner_right,
                    outer_right - top_inner_right,
                    frame_openings);
            }

            // The TP-Link floor and roof share this rounded outline, so clip
            // the side frames to it and eliminate square-corner overhangs.
            translate([0, 0, wall_z0])
                linear_extrude(height = roof_top - wall_z0)
                    splitter_sleeve_outer_outline_2d();
        }

        sleeve_roof_panel_local(
            outer_left, outer_y,
            outer_right - outer_left, outer_depth,
            roof_z0, sleeve_roof_t,
            sleeve_splitter_roof_pitch,
            sleeve_splitter_roof_wall,
            sleeve_roof_border, tray_corner_r);
    }
}

module retention_ventilated_sleeves_local() {
    retention_green_ventilated_sleeve_local();
    if (splitter_model == "tplink")
        splitter_transform()
            retention_splitter_ventilated_sleeve_local();
}

function dovetail_receiver_w() =
    dovetail_head_w
    + 2 * (dovetail_running_clearance + dovetail_receiver_wall);
function dovetail_left_center(outer_left) =
    outer_left + dovetail_receiver_overlap - dovetail_receiver_w() / 2;
function dovetail_right_center(outer_right) =
    outer_right - dovetail_receiver_overlap + dovetail_receiver_w() / 2;

// Vertical sliding dovetail: the narrow throat opens toward the rack rear,
// while the buried head widens toward the device. The gate therefore cannot
// pull rearward out of the cage and can leave only by sliding upward.
module dovetail_profile_2d(clearance = 0) {
    polygon(points = [
        [-dovetail_neck_w / 2 - clearance, clearance],
        [ dovetail_neck_w / 2 + clearance, clearance],
        [ dovetail_head_w / 2 + clearance,
          -dovetail_depth - clearance],
        [-dovetail_head_w / 2 - clearance,
          -dovetail_depth - clearance]
    ]);
}

module dovetail_prism_z(center_x, mouth_y, z0, height,
                        clearance = 0) {
    translate([center_x, mouth_y, z0])
        linear_extrude(height = height)
            dovetail_profile_2d(clearance);
}

module dovetail_channel_z(center_x, mouth_y, z0, height,
                          lock_clearance = dovetail_lock_clearance) {
    lock_h = min(dovetail_lock_h,
                 height - dovetail_top_lead_h - 2 * epsilon);
    straight_h = height - lock_h - dovetail_top_lead_h;

    // The blind track starts tight, then relaxes to the normal sliding fit.
    // Its last two millimeters open farther to simplify initial alignment.
    hull() {
        dovetail_prism_z(
            center_x, mouth_y, z0,
            epsilon, lock_clearance);
        dovetail_prism_z(
            center_x, mouth_y, z0 + lock_h,
            epsilon, dovetail_running_clearance);
    }
    dovetail_prism_z(
        center_x, mouth_y, z0 + lock_h - epsilon,
        straight_h + 2 * epsilon,
        dovetail_running_clearance);
    hull() {
        dovetail_prism_z(
            center_x, mouth_y,
            z0 + height - dovetail_top_lead_h - epsilon,
            epsilon, dovetail_running_clearance);
        dovetail_prism_z(
            center_x, mouth_y, z0 + height + epsilon,
            epsilon,
            dovetail_running_clearance + dovetail_top_lead_extra);
    }
}

module dovetail_receiver_tower_local(
    center_x, mouth_y, wall_z0, roof_top,
    lock_clearance = dovetail_lock_clearance) {
    body_w = dovetail_receiver_w();
    body_y0 = mouth_y - dovetail_depth
              - dovetail_running_clearance - dovetail_receiver_wall;
    body_y1 = mouth_y + 0.10;
    track_z0 = wall_z0 + dovetail_bottom_stop_h;
    track_h = roof_top - track_z0;

    difference() {
        translate([center_x - body_w / 2, body_y0, wall_z0])
            rounded_prism_z(
                body_w, body_y1 - body_y0,
                roof_top - wall_z0, 0.65);

        dovetail_channel_z(
            center_x, mouth_y, track_z0,
            track_h + epsilon, lock_clearance);
    }
}

module dovetail_receiver_pair_local(
    outer_left, outer_right, cage_rear_y,
    wall_z0, roof_top,
    lock_clearance = dovetail_lock_clearance) {
    mouth_y = cage_rear_y + 0.10;
    for (center_x = [dovetail_left_center(outer_left),
                     dovetail_right_center(outer_right)])
        dovetail_receiver_tower_local(
            center_x, mouth_y, wall_z0, roof_top,
            lock_clearance);
}

module dovetail_gate_rail_local(
    center_x, mouth_y, wall_z0, roof_top) {
    rail_z0 = wall_z0 + dovetail_bottom_stop_h
              + dovetail_stop_clearance;
    rail_h = roof_top - rail_z0 - 0.30;

    // A short reduced-width nose prevents elephant foot from becoming the
    // first contact surface when the separate gate is lowered into its tracks.
    hull() {
        dovetail_prism_z(
            center_x, mouth_y, rail_z0,
            epsilon, -0.30);
        dovetail_prism_z(
            center_x, mouth_y, rail_z0 + 0.80,
            epsilon, 0);
    }
    dovetail_prism_z(
        center_x, mouth_y, rail_z0 + 0.78,
        rail_h - 0.78);
}

module dovetail_gate_frame_local(
    outer_left, outer_right,
    device_left, device_right, device_rear_y,
    device_z0, device_h, cage_rear_y,
    wall_z0, roof_top,
    contact_inset = 1.0) {
    left_center = dovetail_left_center(outer_left);
    right_center = dovetail_right_center(outer_right);
    mouth_y = cage_rear_y + 0.10;
    gate_y = cage_rear_y + 0.35;
    gate_x0 = left_center - dovetail_gate_post_w / 2;
    gate_x1 = right_center + dovetail_gate_post_w / 2;
    gate_h = roof_top - wall_z0;
    pull_w = 20.0;
    pull_h = 2.20;
    contact_w = min(10.0, (device_right - device_left) / 4);
    contact_h = 2.40;
    contact_y = device_rear_y + dovetail_gate_contact_gap;
    contact_d = gate_y + dovetail_gate_t - contact_y;
    bottom_contact_z = device_z0 + 0.05;
    bottom_bar_h = max(
        dovetail_gate_bar_h,
        bottom_contact_z + contact_h - wall_z0);
    top_contact_z = min(
        device_z0 + device_h - 0.40,
        roof_top - sleeve_roof_t - 0.20) - contact_h;

    union() {
        // Top and bottom rails overlap only the enclosure edges, leaving the
        // complete center connector field open for Ethernet and DC cables.
        translate([gate_x0, gate_y, wall_z0])
            rounded_prism_z(
                gate_x1 - gate_x0,
                dovetail_gate_t, bottom_bar_h, 0.65);
        translate([
            gate_x0, gate_y,
            roof_top - dovetail_gate_bar_h
        ]) rounded_prism_z(
                gate_x1 - gate_x0,
                dovetail_gate_t, dovetail_gate_bar_h, 0.65);

        for (center_x = [left_center, right_center]) {
            translate([
                center_x - dovetail_gate_post_w / 2,
                gate_y, wall_z0
            ]) rounded_prism_z(
                    dovetail_gate_post_w,
                    dovetail_gate_t, gate_h, 0.65);

            dovetail_gate_rail_local(
                center_x, mouth_y, wall_z0, roof_top);

            // Narrow neck connects the buried rail to the rear gate post while
            // remaining inside the receiver's open throat.
            translate([
                center_x - dovetail_neck_w / 2,
                mouth_y - epsilon,
                wall_z0 + dovetail_bottom_stop_h
                    + dovetail_stop_clearance
            ]) cube([
                dovetail_neck_w,
                gate_y - mouth_y + 2 * epsilon,
                gate_h - dovetail_bottom_stop_h - 0.30
                    - dovetail_stop_clearance
            ]);
        }

        // Four shallow corner pads reach forward through the open rear end to
        // stop the device. Their Z positions clear the connector field and
        // avoid the cage floor/roof, keeping the gate a genuinely separate
        // removable component rather than welding it to the sleeve mesh.
        for (contact_x = [device_left + contact_inset,
                          device_right - contact_w - contact_inset])
            for (contact_z = [bottom_contact_z, top_contact_z])
                translate([contact_x, contact_y, contact_z])
                    rounded_prism_z(
                        contact_w, contact_d, contact_h, 0.60);

        // Rearward thumb ledge does not increase the 1U height envelope.
        translate([
            (left_center + right_center - pull_w) / 2,
            gate_y + dovetail_gate_t - 0.10,
            roof_top - pull_h
        ]) rounded_prism_z(pull_w, 3.20, pull_h, 0.65);
    }
}

module green_dovetail_receivers_local() {
    outer_w = green_w - 2 * sleeve_green_interference
              + 2 * sleeve_green_frame_t;
    outer_left = green_x + green_w / 2 - outer_w / 2;
    outer_right = outer_left + outer_w;
    wall_z0 = unified_deck_z0 - 0.20;
    roof_top = green_device_z + green_h
               - sleeve_green_vertical_interference + sleeve_roof_t;
    sleeve_y0 = face_thickness - 0.20;
    sleeve_depth = green_inner_d + (green_y - face_thickness)
                   + wall_thickness;

    dovetail_receiver_pair_local(
        outer_left, outer_right, sleeve_y0 + sleeve_depth,
        wall_z0, roof_top);
}

module green_dovetail_gate_local() {
    outer_w = green_w - 2 * sleeve_green_interference
              + 2 * sleeve_green_frame_t;
    outer_left = green_x + green_w / 2 - outer_w / 2;
    outer_right = outer_left + outer_w;
    wall_z0 = unified_deck_z0 - 0.20;
    roof_top = green_device_z + green_h
               - sleeve_green_vertical_interference + sleeve_roof_t;
    sleeve_y0 = face_thickness - 0.20;
    sleeve_depth = green_inner_d + (green_y - face_thickness)
                   + wall_thickness;

    dovetail_gate_frame_local(
        outer_left, outer_right,
        green_x, green_x + green_w, green_y + green_d,
        green_device_z, green_h, sleeve_y0 + sleeve_depth,
        wall_z0, roof_top,
        (green_w - green_top_w) / 2
            + sleeve_green_interference + 0.50);
}

module splitter_dovetail_receivers_local() {
    outer_left = -splitter_clearance - wall_thickness;
    outer_right = splitter_w + splitter_clearance + wall_thickness;
    wall_z0 = base_thickness - 0.20;
    roof_top = base_thickness + splitter_h + sleeve_roof_t;
    outer_y = -splitter_clearance - wall_thickness;
    outer_depth = splitter_inner_d + 2 * wall_thickness;

    dovetail_receiver_pair_local(
        outer_left, outer_right, outer_y + outer_depth,
        wall_z0, roof_top);
}

module splitter_dovetail_gate_local() {
    outer_left = -splitter_clearance - wall_thickness;
    outer_right = splitter_w + splitter_clearance + wall_thickness;
    wall_z0 = base_thickness - 0.20;
    roof_top = base_thickness + splitter_h + sleeve_roof_t;
    outer_y = -splitter_clearance - wall_thickness;
    outer_depth = splitter_inner_d + 2 * wall_thickness;

    dovetail_gate_frame_local(
        outer_left, outer_right,
        0, splitter_w, splitter_d,
        base_thickness, splitter_h, outer_y + outer_depth,
        wall_z0, roof_top, splitter_lower_bevel_inset + 0.50);
}

// Rounded cages plus two installed removable rear gates. Receiver towers live
// only in each existing solid rear end block and remain outside the device-fit
// cavities, so the normal vent-frame friction dimensions stay unchanged.
module green_dovetail_cage_local() {
    retention_green_ventilated_sleeve_local();
    green_dovetail_receivers_local();
}

module splitter_dovetail_cage_local() {
    retention_splitter_ventilated_sleeve_local();
    splitter_dovetail_receivers_local();
}

module retention_dovetail_gates_local() {
    green_dovetail_cage_local();
    green_dovetail_gate_local();

    if (splitter_model == "tplink")
        splitter_transform() {
            splitter_dovetail_cage_local();
            splitter_dovetail_gate_local();
        }
}

module dovetail_coupon_key_local(marker_count = 1) {
    mouth_y = 0;
    gate_y = 0.15;
    wall_z0 = 0;
    roof_top = dovetail_coupon_h;

    difference() {
        union() {
            translate([
                -dovetail_gate_post_w / 2,
                gate_y, wall_z0
            ]) rounded_prism_z(
                    dovetail_gate_post_w,
                    dovetail_gate_t,
                    roof_top - wall_z0, 0.65);
            dovetail_gate_rail_local(
                0, mouth_y, wall_z0, roof_top);
            translate([
                -dovetail_neck_w / 2,
                mouth_y - epsilon,
                wall_z0 + dovetail_bottom_stop_h
                    + dovetail_stop_clearance
            ]) cube([
                dovetail_neck_w,
                gate_y - mouth_y + 2 * epsilon,
                roof_top - wall_z0
                    - dovetail_bottom_stop_h - 0.30
                    - dovetail_stop_clearance
            ]);
        }

        // One, two, or three holes identify the 0.10, 0.15, and 0.20 mm lock
        // clearances after the coupon is removed from the build plate.
        for (marker = [0 : marker_count - 1])
            translate([
                0, gate_y - epsilon,
                dovetail_coupon_h - 4.0 - marker * 3.0
            ]) rotate([-90, 0, 0])
                cylinder(
                    h = dovetail_gate_t + 2 * epsilon,
                    d = 1.4, $fn = 20);
    }
}

module dovetail_coupon_receiver_print(lock_clearance) {
    body_y0 = -dovetail_depth
              - dovetail_running_clearance - dovetail_receiver_wall;
    translate([
        dovetail_receiver_w() / 2,
        dovetail_coupon_h,
        -body_y0
    ]) rotate([90, 0, 0])
        dovetail_receiver_tower_local(
            0, 0, 0, dovetail_coupon_h,
            lock_clearance);
}

module dovetail_coupon_key_print(marker_count) {
    translate([
        dovetail_gate_post_w / 2,
        dovetail_coupon_h,
        dovetail_depth
    ]) rotate([90, 0, 0])
        dovetail_coupon_key_local(marker_count);
}

module dovetail_rail_coupon() {
    lock_values = [0.10, 0.15, 0.20];
    pair_pitch = dovetail_receiver_w()
                 + dovetail_coupon_spacing
                 + dovetail_gate_post_w
                 + dovetail_coupon_spacing;

    for (index = [0 : len(lock_values) - 1]) {
        pair_x = index * pair_pitch;
        translate([pair_x, 0, 0])
            dovetail_coupon_receiver_print(lock_values[index]);
        translate([
            pair_x + dovetail_receiver_w()
                + dovetail_coupon_spacing,
            0, 0
        ]) dovetail_coupon_key_print(index + 1);
    }
}

// Low-material, production-derived cage gauges. Each coupon is the exact rear
// 5 mm of its complete sleeve: exactly the solid rear perimeter border before
// any honeycomb openings begin. Printing the cropped opening on the build plate preserves
// the faceplate-down production layer direction while testing the full device
// width, height and local bevel profile in one short insertion.
function green_vent_coupon_sleeve_y0() = face_thickness - 0.20;
function green_vent_coupon_sleeve_depth() =
    green_inner_d + (green_y - face_thickness) + wall_thickness;
function green_vent_coupon_y0() =
    green_vent_coupon_sleeve_y0()
    + green_vent_coupon_sleeve_depth()
    - vent_frame_coupon_depth;
function green_vent_coupon_outer_w() =
    green_w - 2 * sleeve_green_interference
    + 2 * sleeve_green_frame_t;
function green_vent_coupon_outer_left() =
    green_x + green_w / 2 - green_vent_coupon_outer_w() / 2;
function green_vent_coupon_roof_top() =
    green_device_z + green_h
    - sleeve_green_vertical_interference + sleeve_roof_t;

function splitter_vent_coupon_outer_left() =
    -splitter_clearance - wall_thickness;
function splitter_vent_coupon_outer_w() =
    splitter_inner_w + 2 * wall_thickness;
function splitter_vent_coupon_outer_y() =
    -splitter_clearance - wall_thickness;
function splitter_vent_coupon_outer_depth() =
    splitter_inner_d + 2 * wall_thickness;
function splitter_vent_coupon_y0() =
    splitter_vent_coupon_outer_y()
    + splitter_vent_coupon_outer_depth()
    - vent_frame_coupon_depth;
function splitter_vent_coupon_roof_top() =
    base_thickness + splitter_h + sleeve_roof_t;

module green_vent_frame_coupon_raw() {
    intersection() {
        retention_green_ventilated_sleeve_local();
        translate([
            green_vent_coupon_outer_left() - epsilon,
            green_vent_coupon_y0(),
            -epsilon
        ]) cube([
            green_vent_coupon_outer_w() + 2 * epsilon,
            vent_frame_coupon_depth + epsilon,
            rack_height + 2 * epsilon
        ]);
    }
}

module splitter_vent_frame_coupon_raw() {
    intersection() {
        retention_splitter_ventilated_sleeve_local();
        translate([
            splitter_vent_coupon_outer_left() - epsilon,
            splitter_vent_coupon_y0(),
            -epsilon
        ]) cube([
            splitter_vent_coupon_outer_w() + 2 * epsilon,
            vent_frame_coupon_depth + epsilon,
            rack_height + 2 * epsilon
        ]);
    }
}

module green_vent_frame_coupon() {
    translate([
        -green_vent_coupon_outer_left(),
        green_vent_coupon_roof_top(),
        -green_vent_coupon_y0()
    ]) rotate([90, 0, 0]) green_vent_frame_coupon_raw();
}

module splitter_vent_frame_coupon() {
    translate([
        -splitter_vent_coupon_outer_left(),
        splitter_vent_coupon_roof_top(),
        -splitter_vent_coupon_y0()
    ]) rotate([90, 0, 0]) splitter_vent_frame_coupon_raw();
}

module vent_frame_coupon() {
    green_vent_frame_coupon();
    translate([
        green_vent_coupon_outer_w() + vent_frame_coupon_spacing,
        0,
        0
    ]) splitter_vent_frame_coupon();
}

function chassis_depth_for_layout() =
    splitter_model == "sics" ? 238.0
    : stacked_center_layout ? 225.0
    : (front_ethernet_enabled && front_keystone_side == "left") ? 225.0
    : front_ethernet_enabled ? 205.0
    : 185.0;

module chassis_roof_local(chassis_depth) {
    chassis_x0 = -2.5;
    chassis_w = core_width + 5.0;
    chassis_y0 = face_thickness + 0.20;
    roof_outer_z = rack_height - 0.20;
    roof_t = 0.80;
    roof_z0 = roof_outer_z - roof_t;
    roof_border = 6.0;
    roof_pitch = 18.0;
    roof_wall = 2.0;
    beam_z0 = 40.80;
    beam_h = roof_z0 - beam_z0 + 0.20;
    center_beam_x = 78.0;
    center_beam_w = 4.0;

    difference() {
        translate([chassis_x0, chassis_y0, roof_z0])
            linear_extrude(height = roof_t)
                rounded_rect_2d(
                    chassis_w, chassis_depth - chassis_y0, 4.0);

        // A flat-printed 18 mm honeycomb keeps the roof mostly open. Preserve
        // side rails and one longitudinal beam over the device gap. With the
        // revised 33.3375 mm physical Green height and exact 44.45 mm panel,
        // the underside retains 1.0875 mm nominal clearance over the Green.
        // The enclosure remains viewer-only until its assembly and cable
        // access are physically validated.
        translate([0, 0, roof_z0 - epsilon])
            linear_extrude(height = roof_t + 2 * epsilon)
                difference() {
                    translate([chassis_x0 + roof_border,
                               chassis_y0 + roof_border])
                        honeycomb_openings_2d(
                            chassis_w - 2 * roof_border,
                            chassis_depth - chassis_y0
                                - 2 * roof_border,
                            roof_pitch, roof_wall);
                    translate([center_beam_x, chassis_y0])
                        square([center_beam_w,
                                chassis_depth - chassis_y0]);
                }
    }

    // Deep beams live only outside the Green footprint, over the center cable
    // gap, or at the open rear where all modeled cables are well below them.
    translate([chassis_x0, chassis_y0, beam_z0])
        rounded_prism_z(roof_border,
                        chassis_depth - chassis_y0, beam_h, 1.2);
    translate([chassis_x0 + chassis_w - roof_border,
               chassis_y0, beam_z0])
        rounded_prism_z(roof_border,
                        chassis_depth - chassis_y0, beam_h, 1.2);
    translate([center_beam_x, chassis_y0, beam_z0])
        rounded_prism_z(center_beam_w,
                        chassis_depth - chassis_y0, beam_h, 1.0);
    translate([chassis_x0, chassis_y0, beam_z0])
        rounded_prism_z(chassis_w, 1.0, beam_h, 0.45);
    translate([chassis_x0, chassis_depth - roof_border, beam_z0])
        rounded_prism_z(chassis_w, roof_border, beam_h, 1.2);
}

module chassis_cover_local(chassis_depth) {
    chassis_x0 = -2.5;
    chassis_w = core_width + 5.0;
    chassis_y0 = face_thickness + 0.20;
    chassis_z0 = base_thickness - 0.20;
    chassis_top = rack_height - 0.20;
    chassis_h = chassis_top - chassis_z0;

    union() {
        chassis_roof_local(chassis_depth);
        airframe_side_wall_x(
            chassis_x0, chassis_y0,
            chassis_depth - chassis_y0,
            chassis_z0, chassis_h);
        airframe_side_wall_x(
            chassis_x0 + chassis_w - airframe_wall_t,
            chassis_y0, chassis_depth - chassis_y0,
            chassis_z0, chassis_h);
    }
}

module chassis_base_guides_local(chassis_depth) {
    guide_y0 = face_thickness - 0.20;
    guide_w = 2.40;
    guide_h = 7.50;
    guide_left_x = 0.0;
    guide_right_x = core_width - guide_w;
    rear_tie_d = 3.0;

    // These rails are the future printable receiver for the removable cover.
    // They overlap the rear of the faceplate by 0.20 mm and close into a low
    // rear U-frame below every cable. A 0.40 mm side clearance lets the cover
    // slide forward and leaves room for shallow rear snap detents.
    translate([guide_left_x, guide_y0, 0])
        rounded_prism_z(
            guide_w, chassis_depth - guide_y0, guide_h, 0.8);
    translate([guide_right_x, guide_y0, 0])
        rounded_prism_z(
            guide_w, chassis_depth - guide_y0, guide_h, 0.8);
    translate([guide_left_x, chassis_depth - rear_tie_d, 0])
        rounded_prism_z(
            guide_right_x + guide_w - guide_left_x,
            rear_tie_d, base_thickness, 0.8);
}

module open_airframe_local() {
    chassis_depth = chassis_depth_for_layout();

    // Replacement for the earlier device-local airframe: a proper full-width
    // 1U chassis. The inverted-U ventilated cover is intentionally a removable
    // shell; the low receiver frame becomes part of the printable rack mount.
    chassis_cover_local(chassis_depth);
    chassis_base_guides_local(chassis_depth);
}

module viewer_enclosure_airframe() {
    translate([ear_width, 0, 0]) open_airframe_local();
}

module viewer_retention_factory_screws() {
    translate([ear_width, 0, 0]) installed_green_spacers();
    viewer_fasteners();
}

module viewer_retention_slide_latch() {
    translate([ear_width, 0, 0]) retention_slide_latch_local();
}

module viewer_retention_corner_gate() {
    translate([ear_width, 0, 0]) retention_corner_gate_local();
}

module viewer_retention_sled_gate() {
    translate([ear_width, 0, 0]) retention_sled_gate_local();
}

module viewer_retention_padded_rails() {
    translate([ear_width, 0, 0]) retention_padded_rails_local();
}

module viewer_retention_captive_strap() {
    translate([ear_width, 0, 0]) retention_captive_strap_local();
}

module viewer_retention_zip_ties() {
    // Compatibility export for older build scripts; do not expose in the UI.
    translate([ear_width, 0, 0]) retention_zip_ties_local();
}

module viewer_retention_x_cage() {
    translate([ear_width, 0, 0]) retention_x_cage_local();
}

module viewer_retention_hybrid_clips() {
    translate([ear_width, 0, 0]) retention_hybrid_clips_local();
}

module viewer_retention_ventilated_sleeves() {
    translate([ear_width, 0, 0]) retention_ventilated_sleeves_local();
}

module viewer_retention_dovetail_gates() {
    translate([ear_width, 0, 0]) retention_dovetail_gates_local();
}

module viewer_retention_friction_sleeve() {
    translate([ear_width, 0, 0]) retention_friction_sleeve_local();
}

module viewer_retention_selected(mode) {
    if (mode == "factory_screws") viewer_retention_factory_screws();
    else if (mode == "slide_latch") viewer_retention_slide_latch();
    else if (mode == "corner_gate") viewer_retention_corner_gate();
    else if (mode == "sled_gate") viewer_retention_sled_gate();
    else if (mode == "padded_rails") viewer_retention_padded_rails();
    else if (mode == "captive_strap") viewer_retention_captive_strap();
    else if (mode == "x_cage") viewer_retention_x_cage();
    else if (mode == "hybrid_clips") viewer_retention_hybrid_clips();
    else if (mode == "ventilated_sleeves")
        viewer_retention_ventilated_sleeves();
    else if (mode == "dovetail_gates")
        viewer_retention_dovetail_gates();
    else if (mode == "friction_sleeve") viewer_retention_friction_sleeve();
}

// Separate, assembled exports used to build the colored browser model.
module viewer_mount() {
    if (splitter_model == "sics") sics_one_piece_mock();
    else one_piece_mount();
}

module viewer_mount_without_green_tray() {
    if (splitter_model == "sics") sics_one_piece_mock_without_green_tray();
    else one_piece_mount_without_green_tray();
}

module viewer_splitter_floor() {
    if (splitter_model == "tplink")
        translate([ear_width, 0, 0])
            splitter_transform()
                linear_extrude(height = base_thickness)
                    splitter_tray_floor_2d();
}

module viewer_splitter_side_walls() {
    if (splitter_model == "tplink")
        translate([ear_width, 0, 0])
            splitter_transform() splitter_side_walls_local();
}

module viewer_splitter_end_stops() {
    if (splitter_model == "tplink")
        translate([ear_width, 0, 0])
            splitter_transform() splitter_end_stops_local();
}

module viewer_green_tray_standard() {
    translate([ear_width, 0, 0]) green_tray();
}

module viewer_green_tray_friction() {
    translate([ear_width, 0, 0]) green_tray_friction_raised_local();
}

module viewer_green_tray_friction_raised() {
    translate([ear_width, 0, 0]) green_tray_friction_raised_local();
}

module viewer_green_tray_friction_full() {
    translate([ear_width, 0, 0]) green_tray_friction_full_local();
}

module viewer_green_tray_friction_pads() {
    translate([ear_width, 0, 0]) green_tray_friction_pads_local();
}

module viewer_green_tray_friction_skeletal() {
    translate([ear_width, 0, 0]) green_tray_friction_skeletal_local();
}

module viewer_insert() {
    // The lens and its cosmetic veneer are symmetric, so they stay in the
    // same coordinates even when the far-right layout mirrors the actuator.
    translate([ear_width, 0, 0]) union() {
        translate([led_window_x, 0, led_window_z])
            led_insert();

        // Viewer-only exact-size front skin. The printable insert keeps its
        // fit clearance, but this coplanar veneer lets an opaque-white lens
        // disappear into the panel visually.
        translate([led_window_x, 0, led_window_z])
            extrude_y(0, 0.04)
                rounded_rect_2d(led_window_w, led_window_h,
                                led_window_h / 2);
    }
}

module viewer_shutter_closed() {
    translate([ear_width, 0, 0])
        led_cartridge_transform()
            led_shutter(led_shutter_closed_z);
}

module viewer_shutter_open() {
    translate([ear_width, 0, 0])
        led_cartridge_transform()
            led_shutter(led_shutter_open_z);
}

module viewer_shutter_retainer() {
    translate([ear_width, 0, 0])
        led_cartridge_transform()
            led_shutter_retainer();
}

module viewer_status_led(index) {
    // Preview-only emissive lens on the window surface. Keeping this thin disc
    // outside the diffuser and Green mockup avoids intersecting transparent
    // meshes, which made the lights disappear in some WebGL renderers.
    // Left-to-right: white power, green activity, yellow system health.
    translate([ear_width + led_status_x[index], -0.05, led_status_z])
        rotate([-90, 0, 0]) cylinder(h = 0.05, d = 3.2, $fn = 32);
}

module viewer_logo() {
    translate([ear_width, 0, 0]) face_logo_inlay();
}

module viewer_green() {
    translate([ear_width + green_x, green_y, green_device_z])
        green_device_mock_local();
}

module viewer_splitter() {
    translate([ear_width, 0, 0]) {
        if (splitter_model == "sics")
            sics_transform()
                translate([0, 0, base_thickness])
                    linear_extrude(height = sics_h)
                        rounded_rect_2d(sics_w, sics_d, 3.0);
        else
            splitter_transform()
                translate([0, 0, base_thickness])
                    beveled_rounded_box(
                        splitter_w, splitter_d, splitter_h, 4.0,
                        lower_bevel_h = splitter_lower_bevel_h,
                        upper_bevel_h = splitter_upper_bevel_h,
                        lower_inset_x = splitter_lower_bevel_inset,
                        lower_inset_y =
                            splitter_upper_end_bevel_inset,
                        upper_inset = splitter_upper_bevel_inset,
                        upper_inset_y =
                            splitter_upper_end_bevel_inset);
    }
}

module assembly(include_mockups = false) {
    color("white") {
        if (viewer_retention_preview == "hybrid_clips"
            || viewer_retention_preview == "ventilated_sleeves"
            || viewer_retention_preview == "dovetail_gates") {
            if (splitter_model == "sics")
                sics_one_piece_mock_without_green_tray();
            else
                one_piece_mount_without_green_tray();
            if (viewer_retention_preview == "hybrid_clips"
                && splitter_model == "tplink")
                translate([ear_width, 0, 0])
                    splitter_transform()
                        union() {
                            linear_extrude(height = base_thickness)
                                splitter_tray_floor_2d();
                            splitter_end_stops_local();
                        }
        } else if (splitter_model == "sics")
            sics_one_piece_mock();
        else
            one_piece_mount();
        if (green_tray_style == "standard"
            && viewer_retention_preview != "hybrid_clips"
            && viewer_retention_preview != "ventilated_sleeves"
            && viewer_retention_preview != "dovetail_gates")
            translate([ear_width, 0, 0]) installed_green_spacers();
    }

    // The production default is a bare opening; alternate exports may add a
    // translucent insert or the full shutter cartridge.
    if (led_shutter_enabled || led_window_insert_enabled)
        color([0.55, 0.82, 0.68, 0.35])
            viewer_insert();

    // The physical cartridge is shown in its open position by default. The
    // bare-aperture edition has no lens, moving blade, rear cartridge, or
    // actuator.
    if (led_shutter_enabled)
        color("white") {
            viewer_shutter_open();
            viewer_shutter_retainer();
        }

    // Illustrative front-light preview; the browser viewer animates the
    // green activity and yellow health indicators independently.
    color([1.0, 1.0, 1.0, 1.0]) viewer_status_led(0);
    color([0.15, 1.0, 0.42, 1.0]) viewer_status_led(1);
    color([1.0, 0.72, 0.08, 1.0]) viewer_status_led(2);

    if (viewer_retention_preview != "")
        color([0.13, 0.65, 0.86, 1.0])
            viewer_retention_selected(viewer_retention_preview);

    if (face_logo_enabled)
        color([0.08, 0.09, 0.10, 1.0])
            translate([ear_width, 0, 0]) face_logo_inlay();

    if (include_mockups)
        translate([ear_width, 0, 0]) mockups();
}

assert(hybrid_green_catch_tip_t <= hybrid_green_catch_nose_t,
       "Green catch tip cannot be thicker than its shoulder");
assert(hybrid_green_catch_tip_bevel <= hybrid_green_catch_flat,
       "Green catch lead-in bevel must fit within the bearing land");
assert(hybrid_green_catch_flat > hybrid_green_top_overlap,
       "Green bearing land must begin outside the modeled top edge");
assert(abs(hybrid_green_catch_flat
           - (hybrid_green_top_overlap + 0.20)) < 0.001,
       "Green bearing land must begin 0.20 mm outside the modeled top edge");
assert(abs(hybrid_green_clip_reach
           - (green_cover_top_inset + hybrid_green_cover_clearance
              + hybrid_green_top_overlap)) < 0.001,
       "Green reach must preserve the requested top overlap");
assert(green_device_z + green_h + hybrid_green_clip_clearance
           + hybrid_green_top_ramp_h <= rack_unit_pitch,
       "Green hybrid catch exceeds the nominal 1U pitch");
assert(abs(splitter_lower_bevel_h + splitter_flat_side_h
           + splitter_upper_bevel_h - splitter_h) < 0.001,
       "TP-Link measured vertical profile must equal its total height");
assert(abs(splitter_lower_bevel_h - splitter_upper_bevel_h) < 0.001,
       "TP-Link upper and lower bevels must remain symmetric");
assert(abs(splitter_lower_bevel_inset
           - splitter_upper_bevel_inset) < 0.001,
       "TP-Link upper and lower plateau widths must remain symmetric");
assert(splitter_lower_bevel_h > 0 && splitter_upper_bevel_h > 0
           && splitter_flat_side_h > 0,
       "TP-Link measured vertical profile segments must be positive");
assert(splitter_lower_bevel_h < splitter_friction_grip_h,
       "TP-Link cradle grip must extend above the lower bevel");
assert(abs(splitter_top_flat_d
           + 2 * splitter_upper_end_bevel_inset - splitter_d) < 0.001,
       "TP-Link measured top plateau must fit its published full length");
assert(abs(splitter_top_flat_w
           + 2 * splitter_upper_bevel_inset - splitter_w) < 0.001,
       "TP-Link measured top plateau must fit its measured full width");
assert(hybrid_splitter_clip_center_offset
           + hybrid_splitter_clip_len / 2
           <= splitter_top_flat_d / 2,
       "TP-Link catches must stay within the measured top plateau");
assert(hybrid_splitter_tower_t >= 1.20,
       "TP-Link rigid catch towers need at least three 0.4 mm lines");
assert(hybrid_splitter_catch_tip_t <= hybrid_splitter_catch_nose_t,
       "TP-Link catch tip cannot be thicker than its shoulder");
assert(hybrid_splitter_catch_tip_bevel
           <= hybrid_splitter_catch_flat,
       "TP-Link catch lead-in bevel must fit within the bearing land");
assert(hybrid_splitter_catch_flat > hybrid_splitter_top_overlap,
       "TP-Link bearing land must begin outside the modeled top edge");
assert(splitter_upper_bevel_inset
           > hybrid_splitter_catch_flat - hybrid_splitter_top_overlap,
       "TP-Link top inset must exceed the bevel-following land margin");
assert(abs(hybrid_splitter_catch_flat
           - (hybrid_splitter_top_overlap + 0.20)) < 0.001,
       "TP-Link bearing land must begin 0.20 mm outside the modeled top edge");
assert(abs(hybrid_splitter_clip_reach
           - (splitter_upper_bevel_inset
              - splitter_friction_interference
              + hybrid_splitter_top_overlap)) < 0.001,
       "TP-Link reach must preserve the requested top overlap");
assert(abs(hybrid_splitter_clip_clearance) < 0.001,
       "TP-Link friction catches target zero nominal top gap");
assert(splitter_device_z + splitter_h + hybrid_splitter_clip_clearance
           + hybrid_splitter_catch_nose_t <= rack_height,
       "TP-Link hybrid catch exceeds the 1U panel envelope");
assert(green_device_z + green_h - sleeve_green_vertical_interference
           + sleeve_roof_t <= rack_height,
       "Green sleeve roof exceeds the 1U panel outline");
assert(splitter_device_z + splitter_h + sleeve_roof_t <= rack_height,
       "TP-Link sleeve roof exceeds the 1U panel envelope");
assert(sleeve_green_frame_t >= 2.20,
       "Green rounded side frames need at least 2.20 mm thickness");
assert(sleeve_green_frame_open_h
           < green_device_z + green_h - sleeve_green_vertical_interference
             + sleeve_roof_t
             - (unified_deck_z0 - 0.20),
       "Green capsule vents must fit inside the side-frame height");
assert(sleeve_splitter_frame_open_h
           < base_thickness + splitter_h + sleeve_roof_t
             - (base_thickness - 0.20),
       "TP-Link capsule vents must fit inside the side-frame height");
assert(sleeve_green_interference >= 0
           && sleeve_green_interference <= 0.20,
       "Green sleeve interference is outside the coupon-scale range");
assert(dovetail_head_w > dovetail_neck_w,
       "Dovetail head must remain wider than its rear throat");
assert(dovetail_receiver_wall >= 1.20,
       "Dovetail receiver needs at least three 0.4 mm perimeter lines");
assert(dovetail_lock_clearance >= 0
           && dovetail_lock_clearance < dovetail_running_clearance,
       "Dovetail lock zone must be tighter than the sliding section");
assert(dovetail_lock_h + dovetail_top_lead_h
           < splitter_h + sleeve_roof_t - dovetail_bottom_stop_h,
       "Dovetail taper and lead-in must fit the shorter TP-Link gate");
assert(abs(unified_deck_z0 + base_thickness - green_device_z) < 0.001,
       "Unified raised deck must finish at the Green seating plane");
assert(abs(splitter_device_z - green_device_z) < 0.001,
       "Green and TP-Link bottoms must share the unified deck height");
assert(device_layout == "side_by_side"
       || device_layout == "stacked_center",
       str("Unknown device_layout: ", device_layout));
assert(!stacked_center_layout || !front_ethernet_enabled,
       "Centered stacked layout supports rear Ethernet entry only");
assert(!stacked_center_layout
       || abs(green_x + green_w / 2 - core_width / 2) < 0.001,
       "Centered stacked Green must remain centered on the rack panel");
assert(!stacked_center_layout
       || abs(stacked_splitter_output_x - splitter_d / 2
              - core_width / 2) < 0.001,
       "Centered stacked TP-Link must remain centered behind the Green");

assert(!(front_ethernet_enabled
         && front_keystone_side == "far_right"
         && (part == "core" || part == "x2d_plate")),
       "The HA-right Ethernet edition is one-piece-only; its keystone occupies the detachable right-ear joint zone.");

assert(green_tray_style == "friction_raised"
       || green_tray_style == "friction_pads"
       || green_tray_style == "standard"
       || green_tray_style == "friction_full"
       || green_tray_style == "friction_skeletal",
       str("Unknown green_tray_style: ", green_tray_style));

if (part == "assembly_preview") {
    assembly(true);
} else if (part == "assembly") {
    assembly(false);
} else if (part == "one_piece") {
    one_piece_mount();
} else if (part == "one_piece_logo_inlay") {
    one_piece_logo_inlay();
} else if (part == "x2d_plate") {
    x2d_plate();
} else if (part == "core") {
    core();
} else if (part == "logo_inlay") {
    face_logo_inlay();
} else if (part == "left_ear") {
    // Export face-down for reliable printing.
    left_ear_print();
} else if (part == "right_ear") {
    // Move to the origin and export face-down.
    right_ear_print();
} else if (part == "led_insert") {
    // Export front-face-down.
    led_insert_print();
} else if (part == "led_shutter") {
    led_shutter_print();
} else if (part == "led_shutter_retainer") {
    led_shutter_retainer_print();
} else if (part == "led_shutter_kit") {
    led_shutter_kit();
} else if (part == "led_fixed_window_kit") {
    led_fixed_window_kit();
} else if (part == "green_spacer") {
    green_spacer();
} else if (part == "green_spacers_4x") {
    green_spacers_4x();
} else if (part == "fit_test") {
    fit_test();
} else if (part == "friction_fit_coupon") {
    friction_fit_coupon();
} else if (part == "green_hybrid_clip_coupon") {
    green_hybrid_clip_coupon();
} else if (part == "splitter_fit_coupon") {
    splitter_fit_coupon();
} else if (part == "splitter_hybrid_clip_coupon") {
    splitter_hybrid_clip_coupon();
} else if (part == "hybrid_clip_coupon") {
    hybrid_clip_coupon();
} else if (part == "green_vent_frame_coupon") {
    green_vent_frame_coupon();
} else if (part == "splitter_vent_frame_coupon") {
    splitter_vent_frame_coupon();
} else if (part == "vent_frame_coupon") {
    vent_frame_coupon();
} else if (part == "dovetail_rail_coupon") {
    dovetail_rail_coupon();
} else if (part == "green_dovetail_gate") {
    green_dovetail_gate_local();
} else if (part == "splitter_dovetail_gate") {
    splitter_dovetail_gate_local();
} else if (part == "keystone_fit_test") {
    keystone_fit_test();
} else if (part == "viewer_mount") {
    viewer_mount();
} else if (part == "viewer_mount_without_green_tray") {
    viewer_mount_without_green_tray();
} else if (part == "viewer_splitter_floor") {
    viewer_splitter_floor();
} else if (part == "viewer_splitter_side_walls") {
    viewer_splitter_side_walls();
} else if (part == "viewer_splitter_end_stops") {
    viewer_splitter_end_stops();
} else if (part == "viewer_green_tray_standard") {
    viewer_green_tray_standard();
} else if (part == "viewer_green_tray_friction") {
    viewer_green_tray_friction();
} else if (part == "viewer_green_tray_friction_raised") {
    viewer_green_tray_friction_raised();
} else if (part == "viewer_green_tray_friction_full") {
    viewer_green_tray_friction_full();
} else if (part == "viewer_green_tray_friction_pads") {
    viewer_green_tray_friction_pads();
} else if (part == "viewer_green_tray_friction_skeletal") {
    viewer_green_tray_friction_skeletal();
} else if (part == "viewer_insert") {
    viewer_insert();
} else if (part == "viewer_shutter_open") {
    viewer_shutter_open();
} else if (part == "viewer_shutter_closed") {
    viewer_shutter_closed();
} else if (part == "viewer_shutter_retainer") {
    viewer_shutter_retainer();
} else if (part == "viewer_logo") {
    viewer_logo();
} else if (part == "viewer_green") {
    viewer_green();
} else if (part == "viewer_splitter") {
    viewer_splitter();
} else if (part == "viewer_ports") {
    viewer_ports();
} else if (part == "viewer_green_ports") {
    viewer_green_ports();
} else if (part == "viewer_splitter_ports") {
    viewer_splitter_ports();
} else if (part == "viewer_keystone_ports") {
    viewer_keystone_ports();
} else if (part == "viewer_data_cables") {
    viewer_data_cables();
} else if (part == "viewer_internal_data_cable") {
    viewer_internal_data_cable();
} else if (part == "viewer_input_data_cable") {
    viewer_input_data_cable();
} else if (part == "viewer_dc_cable") {
    viewer_dc_cable();
} else if (part == "viewer_fasteners") {
    viewer_fasteners();
} else if (part == "viewer_retention_factory_screws") {
    viewer_retention_factory_screws();
} else if (part == "viewer_retention_slide_latch") {
    viewer_retention_slide_latch();
} else if (part == "viewer_retention_corner_gate") {
    viewer_retention_corner_gate();
} else if (part == "viewer_retention_sled_gate") {
    viewer_retention_sled_gate();
} else if (part == "viewer_retention_padded_rails") {
    viewer_retention_padded_rails();
} else if (part == "viewer_retention_captive_strap") {
    viewer_retention_captive_strap();
} else if (part == "viewer_retention_zip_ties") {
    viewer_retention_zip_ties();
} else if (part == "viewer_retention_x_cage") {
    viewer_retention_x_cage();
} else if (part == "viewer_retention_hybrid_clips") {
    viewer_retention_hybrid_clips();
} else if (part == "viewer_retention_ventilated_sleeves") {
    viewer_retention_ventilated_sleeves();
} else if (part == "viewer_retention_dovetail_gates") {
    viewer_retention_dovetail_gates();
} else if (part == "viewer_retention_friction_sleeve") {
    viewer_retention_friction_sleeve();
} else if (part == "viewer_enclosure_airframe") {
    viewer_enclosure_airframe();
} else if (part == "viewer_rulers") {
    viewer_rulers();
} else if (part == "viewer_led_power") {
    viewer_status_led(0);
} else if (part == "viewer_led_activity") {
    viewer_status_led(1);
} else if (part == "viewer_led_health") {
    viewer_status_led(2);
}
