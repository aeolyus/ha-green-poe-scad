#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
viewer_build_jobs="${VIEWER_BUILD_JOBS:-4}"

cd "$project_dir"
read -r OPENSCAD_SUPPORTS_BACKEND OPENSCAD_SUPPORTS_EXPORT_FORMAT \
  < <(python3 scripts/openscad_export.py --features)
export OPENSCAD_SUPPORTS_BACKEND OPENSCAD_SUPPORTS_EXPORT_FORMAT
python3 scripts/openscad_export.py --check
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest scripts/test_openscad_export.py
if ! [[ "$viewer_build_jobs" =~ ^[1-9][0-9]*$ ]]; then
  echo "VIEWER_BUILD_JOBS must be a positive integer" >&2
  exit 1
fi

run_openscad() {
  python3 scripts/openscad_export.py "$@"
}

mkdir -p exports viewer renders
rm -rf viewer/variants
rm -f viewer/viewer_insert_no_shutter.stl
# Remove superseded names so a full rebuild cannot leave stale shutter/logo
# files looking like production artifacts in a regenerated package.
rm -f exports/core_no_shutter.* \
      exports/one_piece_no_shutter.* \
      exports/x2d_plate_no_shutter.* \
      exports/assembly_no_shutter.* \
      exports/logo_inlay.stl \
      exports/one_piece_logo_inlay.stl \
      exports/green_spacer.stl \
      exports/green_spacers_4x.* \
      exports/led_shutter.stl \
      exports/led_shutter_retainer.stl \
      exports/led_shutter_kit.* \
      exports/led_insert.stl \
      exports/led_fixed_window_kit.* \
      exports/led_insert_no_shutter.stl \
      exports/one_piece_rear_cable_friendly_friction_pads_no_shutter_flat_face.* \
      exports/*_front_ethernet*_no_shutter.* \
      exports/logo_inlay_front_ethernet*.stl \
      exports/*_logo_inlay_front_ethernet*.stl \
      exports/led_shutter_kit_front_ethernet_far_right.* \
      exports/core_front_ethernet_far_right* \
      exports/x2d_plate_front_ethernet_far_right*
rm -f renders/front_ethernet_far_right_no_shutter.png

# Canonical production files inherit the SCAD defaults without overrides:
# cable-friendly rear entry, unified raised Green friction deck, plain face,
# open LED aperture with no lens or shutter, and no chassis.
canonical_stl_parts=(
  core
  assembly
  one_piece
  x2d_plate
  left_ear
  right_ear
  fit_test
  friction_fit_coupon
  splitter_fit_coupon
)
for part_name in "${canonical_stl_parts[@]}"; do
  run_openscad -o "exports/${part_name}.stl" \
    -D "part=\"${part_name}\"" ha_green_rack.scad
done
# Physically validated rounded-cage release candidate. These targets are
# already faceplate-down and intentionally omit the optional dovetail gates.
run_openscad --backend=CGAL \
  -o exports/one_piece_rear_cable_friendly_vent_frame_no_dovetail.stl \
  -D 'part="one_piece_ventilated_sleeves_print"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/x2d_plate_rear_cable_friendly_vent_frame_no_dovetail.stl \
  -D 'part="x2d_plate_ventilated_sleeves"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/one_piece_rear_cable_friendly_vent_frame_dovetail_ready.stl \
  -D 'part="one_piece_dovetail_ready_print"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/dovetail_gates_optional_plate.stl \
  -D 'part="dovetail_gates_plate"' ha_green_rack.scad
for part_name in green_hybrid_clip_coupon splitter_hybrid_clip_coupon hybrid_clip_coupon green_vent_frame_coupon splitter_vent_frame_coupon vent_frame_coupon dovetail_rail_coupon; do
  # Force CGAL for these fit-critical coupons. Some Manifold STL exports can
  # retain zero-volume sliver components even when their visible shell looks
  # closed; CGAL removes those artifacts before slicing.
  run_openscad --backend=CGAL -o "exports/${part_name}.stl" \
    -D "part=\"${part_name}\"" ha_green_rack.scad
done
cp exports/one_piece.stl \
   exports/one_piece_rear_cable_friendly_friction_raised_no_shutter_flat_face.stl

# Optional translucent insert for users who prefer a covered LED window. The
# production plate itself remains a bare aperture.
run_openscad -o exports/led_insert_optional.stl \
  -D 'part="led_insert"' -D 'led_window_insert_enabled=true' \
  ha_green_rack.scad
run_openscad -o exports/led_fixed_window_kit_optional.stl \
  -D 'part="led_fixed_window_kit"' -D 'led_window_insert_enabled=true' \
  ha_green_rack.scad
run_openscad -o exports/led_fixed_window_kit_optional.3mf \
  -D 'part="led_fixed_window_kit"' -D 'led_window_insert_enabled=true' \
  ha_green_rack.scad

# Clearly named legacy screw-tray fallback. These exports retain the final
# plain, open-aperture face while replacing only the Green tray and adding its
# four locating spacers.
for part_name in core assembly one_piece x2d_plate; do
  run_openscad -o "exports/${part_name}_legacy_screw_tray.stl" \
    -D "part=\"${part_name}\"" \
    -D 'green_tray_style="standard"' ha_green_rack.scad
done
run_openscad -o exports/green_spacer_legacy_screw_tray.stl \
  -D 'part="green_spacer"' -D 'green_tray_style="standard"' \
  ha_green_rack.scad
run_openscad -o exports/green_spacers_4x_legacy_screw_tray.stl \
  -D 'part="green_spacers_4x"' -D 'green_tray_style="standard"' \
  ha_green_rack.scad

# Optional historical front treatments. Each matching mount is explicit so
# the logo inlays and shutter pieces cannot be mistaken for canonical parts.
for part_name in core assembly one_piece x2d_plate; do
  run_openscad -o "exports/${part_name}_with_logo.stl" \
    -D "part=\"${part_name}\"" \
    -D 'face_logo_enabled=true' ha_green_rack.scad
  run_openscad -o "exports/${part_name}_with_shutter.stl" \
    -D "part=\"${part_name}\"" \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
done
run_openscad -o exports/logo_inlay_optional.stl \
  -D 'part="logo_inlay"' -D 'face_logo_enabled=true' ha_green_rack.scad
run_openscad -o exports/one_piece_logo_inlay_optional.stl \
  -D 'part="one_piece_logo_inlay"' -D 'face_logo_enabled=true' \
  ha_green_rack.scad
run_openscad -o exports/led_insert_with_shutter.stl \
  -D 'part="led_insert"' -D 'led_shutter_enabled=true' ha_green_rack.scad
run_openscad -o exports/led_shutter_optional.stl \
  -D 'part="led_shutter"' -D 'led_shutter_enabled=true' ha_green_rack.scad
run_openscad -o exports/led_shutter_retainer_optional.stl \
  -D 'part="led_shutter_retainer"' -D 'led_shutter_enabled=true' \
  ha_green_rack.scad
run_openscad -o exports/led_shutter_kit_optional.stl \
  -D 'part="led_shutter_kit"' -D 'led_shutter_enabled=true' \
  ha_green_rack.scad

# Optional front-Ethernet comparisons retain all other production defaults.
# The right-keystone layout stays
# shallow; the left-keystone layout moves the splitter rearward to preserve
# straight-plug bend clearance.
for front_spec in "right:60" "left:89"; do
  IFS=: read -r front_side front_y <<< "$front_spec"
  for part_name in core assembly one_piece x2d_plate; do
    run_openscad \
      -o "exports/${part_name}_front_ethernet_${front_side}.stl" \
      -D "part=\"${part_name}\"" \
      -D 'front_ethernet_enabled=true' \
      -D "front_keystone_side=\"${front_side}\"" \
      -D "splitter_y_override=${front_y}" ha_green_rack.scad
    run_openscad \
      -o "exports/${part_name}_front_ethernet_${front_side}_with_shutter.stl" \
      -D "part=\"${part_name}\"" \
      -D 'front_ethernet_enabled=true' \
      -D "front_keystone_side=\"${front_side}\"" \
      -D "splitter_y_override=${front_y}" \
      -D 'led_shutter_enabled=true' ha_green_rack.scad
  done
done

# The true HA-right jack occupies the detachable right-ear joint zone, so it
# is intentionally exported only as a one-piece mount/reference assembly.
for part_name in assembly one_piece; do
  run_openscad \
    -o "exports/${part_name}_front_ethernet_far_right.stl" \
    -D "part=\"${part_name}\"" \
    -D 'front_ethernet_enabled=true' \
    -D 'front_keystone_side="far_right"' \
    -D 'splitter_y_override=60' ha_green_rack.scad
  run_openscad \
    -o "exports/${part_name}_front_ethernet_far_right_with_shutter.stl" \
    -D "part=\"${part_name}\"" \
    -D 'front_ethernet_enabled=true' \
    -D 'front_keystone_side="far_right"' \
    -D 'splitter_y_override=60' \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
done
run_openscad \
  -o exports/led_shutter_kit_front_ethernet_far_right_optional.stl \
  -D 'part="led_shutter_kit"' \
  -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' \
  -D 'led_shutter_enabled=true' ha_green_rack.scad

# Backward-compatible unqualified front files follow the legacy center-gap
# layout (`front_keystone_side="right"`), not the physical HA-right layout.
for part_name in core assembly one_piece x2d_plate; do
  cp "exports/${part_name}_front_ethernet_right.stl" \
     "exports/${part_name}_front_ethernet.stl"
done

run_openscad -o exports/keystone_fit_test.stl \
  -D 'part="keystone_fit_test"' ha_green_rack.scad

for part_name in x2d_plate one_piece; do
  # Manifold currently leaves zero-area triangle fragments in these large
  # multi-feature 3MFs even when the corresponding STL fallback is clean.
  # Force CGAL so the downloadable production meshes remain watertight.
  run_openscad --backend=CGAL -o "exports/${part_name}.3mf" \
    -D "part=\"${part_name}\"" ha_green_rack.scad
done
run_openscad --backend=CGAL \
  -o exports/one_piece_rear_cable_friendly_vent_frame_no_dovetail.3mf \
  -D 'part="one_piece_ventilated_sleeves_print"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/x2d_plate_rear_cable_friendly_vent_frame_no_dovetail.3mf \
  -D 'part="x2d_plate_ventilated_sleeves"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/one_piece_rear_cable_friendly_vent_frame_dovetail_ready.3mf \
  -D 'part="one_piece_dovetail_ready_print"' ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/dovetail_gates_optional_plate.3mf \
  -D 'part="dovetail_gates_plate"' ha_green_rack.scad
for part_name in fit_test friction_fit_coupon splitter_fit_coupon; do
  run_openscad -o "exports/${part_name}.3mf" \
    -D "part=\"${part_name}\"" ha_green_rack.scad
done
for part_name in green_hybrid_clip_coupon splitter_hybrid_clip_coupon hybrid_clip_coupon green_vent_frame_coupon splitter_vent_frame_coupon vent_frame_coupon dovetail_rail_coupon; do
  # These fit-critical gauges contain short walls or catch faces. CGAL avoids
  # the degenerate facets that some Manifold 3MF exports retain at those seams.
  run_openscad --backend=CGAL -o "exports/${part_name}.3mf" \
    -D "part=\"${part_name}\"" ha_green_rack.scad
done
cp exports/one_piece.3mf \
   exports/one_piece_rear_cable_friendly_friction_raised_no_shutter_flat_face.3mf
for part_name in x2d_plate one_piece; do
  run_openscad --backend=CGAL \
    -o "exports/${part_name}_legacy_screw_tray.3mf" \
    -D "part=\"${part_name}\"" \
    -D 'green_tray_style="standard"' ha_green_rack.scad
  run_openscad --backend=CGAL -o "exports/${part_name}_with_logo.3mf" \
    -D "part=\"${part_name}\"" \
    -D 'face_logo_enabled=true' ha_green_rack.scad
  run_openscad --backend=CGAL -o "exports/${part_name}_with_shutter.3mf" \
    -D "part=\"${part_name}\"" \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
done
run_openscad -o exports/green_spacers_4x_legacy_screw_tray.3mf \
  -D 'part="green_spacers_4x"' -D 'green_tray_style="standard"' \
  ha_green_rack.scad
run_openscad -o exports/led_shutter_kit_optional.3mf \
  -D 'part="led_shutter_kit"' -D 'led_shutter_enabled=true' \
  ha_green_rack.scad
for front_spec in "right:60" "left:89"; do
  IFS=: read -r front_side front_y <<< "$front_spec"
  run_openscad --backend=CGAL \
    -o "exports/one_piece_front_ethernet_${front_side}.3mf" \
    -D 'part="one_piece"' -D 'front_ethernet_enabled=true' \
    -D "front_keystone_side=\"${front_side}\"" \
    -D "splitter_y_override=${front_y}" ha_green_rack.scad
  run_openscad --backend=CGAL \
    -o "exports/x2d_plate_front_ethernet_${front_side}.3mf" \
    -D 'part="x2d_plate"' -D 'front_ethernet_enabled=true' \
    -D "front_keystone_side=\"${front_side}\"" \
    -D "splitter_y_override=${front_y}" ha_green_rack.scad
  run_openscad \
    -o "exports/one_piece_front_ethernet_${front_side}_with_shutter.3mf" \
    -D 'part="one_piece"' -D 'front_ethernet_enabled=true' \
    -D "front_keystone_side=\"${front_side}\"" \
    -D "splitter_y_override=${front_y}" \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
  run_openscad \
    -o "exports/x2d_plate_front_ethernet_${front_side}_with_shutter.3mf" \
    -D 'part="x2d_plate"' -D 'front_ethernet_enabled=true' \
    -D "front_keystone_side=\"${front_side}\"" \
    -D "splitter_y_override=${front_y}" \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
done
run_openscad --backend=CGAL \
  -o exports/one_piece_front_ethernet_far_right.3mf \
  -D 'part="one_piece"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' -D 'splitter_y_override=60' \
  ha_green_rack.scad
run_openscad --backend=CGAL \
  -o exports/one_piece_front_ethernet_far_right_with_shutter.3mf \
  -D 'part="one_piece"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' -D 'splitter_y_override=60' \
  -D 'led_shutter_enabled=true' ha_green_rack.scad
run_openscad \
  -o exports/led_shutter_kit_front_ethernet_far_right_optional.3mf \
  -D 'part="led_shutter_kit"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' \
  -D 'led_shutter_enabled=true' ha_green_rack.scad
cp exports/one_piece_front_ethernet_right.3mf \
   exports/one_piece_front_ethernet.3mf
cp exports/x2d_plate_front_ethernet_right.3mf \
   exports/x2d_plate_front_ethernet.3mf
run_openscad -o exports/keystone_fit_test.3mf \
  -D 'part="keystone_fit_test"' ha_green_rack.scad
run_openscad -o viewer/assembly_preview.3mf \
  -D 'part="assembly_preview"' ha_green_rack.scad

for part_name in mount mount_without_green_tray splitter_floor splitter_end_stops splitter_side_walls green_tray_standard green_tray_friction green_tray_friction_raised green_tray_friction_full green_tray_friction_pads green_tray_friction_skeletal insert shutter_open shutter_closed shutter_retainer logo green splitter ports green_ports splitter_ports internal_data_cable input_data_cable dc_cable fasteners rulers led_power led_activity led_health; do
  run_openscad -o "viewer/viewer_${part_name}.stl" \
    -D "part=\"viewer_${part_name}\"" \
    -D 'led_shutter_enabled=true' ha_green_rack.scad
done

# Green-only retention concepts use the same device coordinates in every
# layout. The mixed Green + TP-Link concepts are built per variant below
# because their splitter geometry follows the layout-specific setback.
for retention_name in factory_screws slide_latch corner_gate sled_gate padded_rails captive_strap x_cage friction_sleeve; do
  run_openscad \
    -o "viewer/viewer_retention_${retention_name}.stl" \
    -D "part=\"viewer_retention_${retention_name}\"" ha_green_rack.scad
done
for part_name in mount; do
  run_openscad -o "viewer/viewer_${part_name}_no_shutter.stl" \
    -D "part=\"viewer_${part_name}\"" \
    -D 'led_shutter_enabled=false' ha_green_rack.scad
done

# Viewer comparison layouts. The far-right Ethernet edition is one-piece-only;
# SICSOLINK remains viewer-only.
viewer_variants=(
  "compact:tplink:35:false:right:side_by_side"
  "balanced:tplink:47.5:false:right:side_by_side"
  "cable_friendly:tplink:60:false:right:side_by_side"
  "stacked_center:tplink:145.56875:false:right:stacked_center"
  "front_ethernet_right:tplink:60:true:right:side_by_side"
  "front_ethernet_far_right:tplink:60:true:far_right:side_by_side"
  "front_ethernet_left:tplink:89:true:left:side_by_side"
  "sics_angled:sics:60:false:right:side_by_side"
)

build_viewer_variant() {
  local variant_spec="$1"
  local variant_id variant_model variant_y variant_front variant_side variant_layout
  local variant_dir part_name
  IFS=: read -r variant_id variant_model variant_y variant_front variant_side variant_layout \
    <<< "$variant_spec"
  variant_dir="viewer/variants/${variant_id}"
  mkdir -p "$variant_dir"

  for part_name in mount_without_green_tray enclosure_airframe insert shutter_open shutter_closed shutter_retainer logo green splitter green_ports splitter_ports internal_data_cable input_data_cable dc_cable rulers led_power led_activity led_health retention_hybrid_clips; do
    run_openscad -o "${variant_dir}/viewer_${part_name}.stl" \
      -D "part=\"viewer_${part_name}\"" \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "device_layout=\"${variant_layout}\"" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=true' ha_green_rack.scad
  done

  if [[ "$variant_model" == "tplink" ]]; then
    for part_name in splitter_floor splitter_end_stops splitter_side_walls retention_ventilated_sleeves; do
      run_openscad -o "${variant_dir}/viewer_${part_name}.stl" \
        -D "part=\"viewer_${part_name}\"" \
        -D "splitter_model=\"${variant_model}\"" \
        -D "splitter_y_override=${variant_y}" \
        -D "device_layout=\"${variant_layout}\"" \
        -D "front_ethernet_enabled=${variant_front}" \
        -D "front_keystone_side=\"${variant_side}\"" \
        -D 'led_shutter_enabled=true' ha_green_rack.scad
    done
  fi

  if [[ "$variant_model" == "tplink" && "$variant_layout" == "side_by_side" ]]; then
    run_openscad -o "${variant_dir}/viewer_retention_dovetail_gates.stl" \
      -D 'part="viewer_retention_dovetail_gates"' \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "device_layout=\"${variant_layout}\"" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=true' ha_green_rack.scad
  fi

  if [[ "$variant_front" == "true" ]]; then
    run_openscad -o "${variant_dir}/viewer_keystone_ports.stl" \
      -D 'part="viewer_keystone_ports"' \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "device_layout=\"${variant_layout}\"" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=true' ha_green_rack.scad
  fi

  for part_name in mount_without_green_tray; do
    run_openscad \
      -o "${variant_dir}/viewer_${part_name}_no_shutter.stl" \
      -D "part=\"viewer_${part_name}\"" \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "device_layout=\"${variant_layout}\"" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=false' ha_green_rack.scad
  done

  if [[ "$variant_layout" == "stacked_center" ]]; then
    for part_name in green_tray_standard green_tray_friction green_tray_friction_raised green_tray_friction_full green_tray_friction_pads green_tray_friction_skeletal; do
      run_openscad -o "${variant_dir}/viewer_${part_name}.stl" \
        -D "part=\"viewer_${part_name}\"" \
        -D "device_layout=\"${variant_layout}\"" ha_green_rack.scad
    done
    for part_name in factory_screws slide_latch corner_gate sled_gate padded_rails captive_strap x_cage; do
      run_openscad -o "${variant_dir}/viewer_retention_${part_name}.stl" \
        -D "part=\"viewer_retention_${part_name}\"" \
        -D "device_layout=\"${variant_layout}\"" \
        -D "splitter_y_override=${variant_y}" ha_green_rack.scad
    done
  fi

}

variant_pids=()
variant_failed=0
cleanup_variant_jobs() {
  local status="$?"
  trap - EXIT INT TERM
  for variant_pid in "${variant_pids[@]}"; do
    kill "$variant_pid" 2>/dev/null || true
  done
  for variant_pid in "${variant_pids[@]}"; do
    wait "$variant_pid" 2>/dev/null || true
  done
  exit "$status"
}
wait_first_variant_job() {
  local variant_pid="${variant_pids[0]}"
  if ! wait "$variant_pid"; then
    variant_failed=1
  fi
  variant_pids=("${variant_pids[@]:1}")
}
trap cleanup_variant_jobs EXIT INT TERM

for variant_spec in "${viewer_variants[@]}"; do
  build_viewer_variant "$variant_spec" &
  variant_pids+=("$!")
  if (( ${#variant_pids[@]} >= viewer_build_jobs )); then
    wait_first_variant_job
  fi
done
while (( ${#variant_pids[@]} > 0 )); do
  wait_first_variant_job
done
variant_pids=()
trap - EXIT INT TERM
if (( variant_failed != 0 )); then
  echo "One or more viewer-variant builds failed" >&2
  exit 1
fi

# Backward-compatible standalone alias follows the production cable-friendly
# layout. GLB assembly uses the variant-local files instead.
cp viewer/variants/cable_friendly/viewer_retention_hybrid_clips.stl \
   viewer/viewer_retention_hybrid_clips.stl
cp viewer/variants/cable_friendly/viewer_retention_ventilated_sleeves.stl \
   viewer/viewer_retention_ventilated_sleeves.stl
cp viewer/variants/cable_friendly/viewer_retention_dovetail_gates.stl \
   viewer/viewer_retention_dovetail_gates.stl

render_common=(--viewall --autocenter --projection=perspective \
  --colorscheme=Tomorrow -D 'part="assembly_preview"')

run_openscad -o renders/assembly_preview.png --imgsize=1600,1000 \
  "${render_common[@]}" ha_green_rack.scad
run_openscad -o renders/front.png --imgsize=1600,900 \
  --camera=0,0,0,90,0,0,500 "${render_common[@]}" ha_green_rack.scad
run_openscad -o renders/rear.png --imgsize=1600,900 \
  --camera=0,0,0,90,0,180,500 "${render_common[@]}" ha_green_rack.scad
run_openscad -o renders/top.png --imgsize=1600,1000 \
  --camera=0,0,0,0,0,0,500 "${render_common[@]}" ha_green_rack.scad
run_openscad -o renders/x2d_plate.png --imgsize=1600,1200 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  --camera=0,0,0,0,0,0,500 -D 'part="x2d_plate"' ha_green_rack.scad
run_openscad -o renders/sicsolink_angled.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  -D 'part="assembly_preview"' -D 'splitter_model="sics"' ha_green_rack.scad
run_openscad -o renders/sicsolink_angled_top.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  --camera=0,0,0,0,0,0,500 \
  -D 'part="assembly_preview"' -D 'splitter_model="sics"' ha_green_rack.scad
run_openscad -o renders/front_ethernet_right.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  -D 'part="assembly_preview"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="right"' -D 'splitter_y_override=60' \
  ha_green_rack.scad
run_openscad -o renders/front_ethernet_left.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  -D 'part="assembly_preview"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="left"' -D 'splitter_y_override=89' \
  ha_green_rack.scad
run_openscad -o renders/front_ethernet_far_right.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  -D 'part="assembly_preview"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' -D 'splitter_y_override=60' \
  ha_green_rack.scad
run_openscad \
  -o renders/front_ethernet_far_right_with_shutter.png --imgsize=1600,1000 \
  --viewall --autocenter --projection=perspective --colorscheme=Tomorrow \
  -D 'part="assembly_preview"' -D 'front_ethernet_enabled=true' \
  -D 'front_keystone_side="far_right"' -D 'splitter_y_override=60' \
  -D 'led_shutter_enabled=true' ha_green_rack.scad
cp renders/front_ethernet_right.png renders/front_ethernet.png

cp renders/front.png renders/front_detail.png
cp renders/rear.png renders/rear_detail.png
cp renders/top.png renders/top_detail.png

python3 scripts/build_viewer.py
