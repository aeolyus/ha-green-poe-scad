#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
viewer_build_jobs="${VIEWER_BUILD_JOBS:-4}"

cd "$project_dir"

variant_ids=(
  compact
  balanced
  cable_friendly
  front_ethernet_right
  front_ethernet_far_right
  front_ethernet_left
  sics_angled
)
retention_ids=(
  factory_screws
  slide_latch
  corner_gate
  sled_gate
  padded_rails
  captive_strap
  x_cage
  hybrid_clips
  friction_sleeve
)

usage() {
  cat <<'EOF'
Usage: scripts/build.sh TARGET [NAME ...]

Targets:
  html                 Refresh embedded HTML from existing GLBs (fastest).
  glb [VARIANT ...]    Rebuild colored GLBs from existing viewer STLs.
  viewer [VARIANT ...] Rebuild selected viewer STLs, GLBs, and HTML.
                       With no names, rebuild every viewer variant.
  retention [TYPE ...] Rebuild selected retention overlays, then all GLBs/HTML.
                       With no names, rebuild every retention overlay.
  full                 Rebuild canonical production assets and comparisons.
  help                 Show this message.

Set VIEWER_BUILD_JOBS to limit parallel OpenSCAD jobs (default: 4).
Set OPENSCAD_BIN to override the engine selected by openscad_export.py.
EOF
}

variant_spec() {
  case "$1" in
    compact) echo 'compact:tplink:35:false:right' ;;
    balanced) echo 'balanced:tplink:47.5:false:right' ;;
    cable_friendly) echo 'cable_friendly:tplink:60:false:right' ;;
    front_ethernet_right) echo 'front_ethernet_right:tplink:60:true:right' ;;
    front_ethernet_far_right) echo 'front_ethernet_far_right:tplink:60:true:far_right' ;;
    front_ethernet_left) echo 'front_ethernet_left:tplink:89:true:left' ;;
    sics_angled) echo 'sics_angled:sics:60:false:right' ;;
    *) return 1 ;;
  esac
}

retention_is_valid() {
  case "$1" in
    factory_screws|slide_latch|corner_gate|sled_gate|padded_rails|captive_strap|x_cage|hybrid_clips|friction_sleeve)
      return 0
      ;;
    *) return 1 ;;
  esac
}

require_openscad() {
  read -r OPENSCAD_SUPPORTS_BACKEND OPENSCAD_SUPPORTS_EXPORT_FORMAT \
    < <(python3 scripts/openscad_export.py --features)
  export OPENSCAD_SUPPORTS_BACKEND OPENSCAD_SUPPORTS_EXPORT_FORMAT
  if ! python3 scripts/openscad_export.py --check; then
    echo "Use the Nix command documented in README.md." >&2
    exit 1
  fi
  if ! [[ "$viewer_build_jobs" =~ ^[1-9][0-9]*$ ]]; then
    echo "VIEWER_BUILD_JOBS must be a positive integer" >&2
    exit 1
  fi
}

job_pids=()

cleanup_jobs() {
  local index pid
  for (( index=0; index<${#job_pids[@]}; index++ )); do
    pid="${job_pids[$index]}"
    kill "$pid" 2>/dev/null || true
  done
  for (( index=0; index<${#job_pids[@]}; index++ )); do
    pid="${job_pids[$index]}"
    wait "$pid" 2>/dev/null || true
  done
}

cleanup_on_exit() {
  local status="$?"
  trap - EXIT INT TERM
  cleanup_jobs
  exit "$status"
}

wait_first_job() {
  local pid="${job_pids[0]}"
  if ! wait "$pid"; then
    return 1
  fi
  job_pids=("${job_pids[@]:1}")
}

build_scad_atomic() {
  local output="$1"
  shift
  local temporary_output="${output%.stl}.tmp.$$.$RANDOM.stl"
  mkdir -p "$(dirname "$output")"
  if python3 scripts/openscad_export.py \
      -o "$temporary_output" "$@" ha_green_rack.scad; then
    mv "$temporary_output" "$output"
  else
    rm -f "$temporary_output"
    return 1
  fi
}

launch_scad() {
  build_scad_atomic "$@" &
  job_pids+=("$!")
  if (( ${#job_pids[@]} >= viewer_build_jobs )); then
    wait_first_job
  fi
}

finish_scad_jobs() {
  while (( ${#job_pids[@]} > 0 )); do
    wait_first_job
  done
}

build_variant_hybrid_overlay() {
  local requested_id="$1"
  local spec variant_id variant_model variant_y variant_front variant_side
  local variant_dir
  if ! spec="$(variant_spec "$requested_id")"; then
    echo "Unknown viewer variant: $requested_id" >&2
    usage >&2
    exit 2
  fi
  IFS=: read -r variant_id variant_model variant_y variant_front variant_side \
    <<< "$spec"
  variant_dir="viewer/variants/${variant_id}"
  mkdir -p "$variant_dir"

  launch_scad "${variant_dir}/viewer_retention_hybrid_clips.stl" \
    -D 'part="viewer_retention_hybrid_clips"' \
    -D "splitter_model=\"${variant_model}\"" \
    -D "splitter_y_override=${variant_y}" \
    -D "front_ethernet_enabled=${variant_front}" \
    -D "front_keystone_side=\"${variant_side}\""
}

build_viewer_variant() {
  local requested_id="$1"
  local spec variant_id variant_model variant_y variant_front variant_side
  local variant_dir part_name
  if ! spec="$(variant_spec "$requested_id")"; then
    echo "Unknown viewer variant: $requested_id" >&2
    usage >&2
    exit 2
  fi
  IFS=: read -r variant_id variant_model variant_y variant_front variant_side \
    <<< "$spec"
  variant_dir="viewer/variants/${variant_id}"
  mkdir -p "$variant_dir"

  for part_name in mount_without_green_tray enclosure_airframe insert shutter_open shutter_closed shutter_retainer logo green splitter green_ports splitter_ports internal_data_cable input_data_cable dc_cable rulers led_power led_activity led_health; do
    launch_scad "${variant_dir}/viewer_${part_name}.stl" \
      -D "part=\"viewer_${part_name}\"" \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=true'
  done

  if [[ "$variant_front" == "true" ]]; then
    launch_scad "${variant_dir}/viewer_keystone_ports.stl" \
      -D 'part="viewer_keystone_ports"' \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=true'
  fi

  for part_name in mount_without_green_tray; do
    launch_scad "${variant_dir}/viewer_${part_name}_no_shutter.stl" \
      -D "part=\"viewer_${part_name}\"" \
      -D "splitter_model=\"${variant_model}\"" \
      -D "splitter_y_override=${variant_y}" \
      -D "front_ethernet_enabled=${variant_front}" \
      -D "front_keystone_side=\"${variant_side}\"" \
      -D 'led_shutter_enabled=false'
  done

  build_variant_hybrid_overlay "$variant_id"
}

build_shared_viewer_trays() {
  launch_scad "viewer/viewer_green_tray_standard.stl" \
    -D 'part="viewer_green_tray_standard"'
  build_friction_tray_variants
}

build_friction_tray_variants() {
  local part_name
  for part_name in green_tray_friction green_tray_friction_full green_tray_friction_pads green_tray_friction_skeletal; do
    launch_scad "viewer/viewer_${part_name}.stl" \
      -D "part=\"viewer_${part_name}\""
  done
}

build_retention_overlay() {
  local retention_id="$1"
  local variant_id
  if ! retention_is_valid "$retention_id"; then
    echo "Unknown retention type: $retention_id" >&2
    usage >&2
    exit 2
  fi
  if [[ "$retention_id" == "friction_sleeve" ]]; then
    build_friction_tray_variants
  elif [[ "$retention_id" == "hybrid_clips" ]]; then
    for variant_id in "${variant_ids[@]}"; do
      build_variant_hybrid_overlay "$variant_id"
    done
  else
    launch_scad "viewer/viewer_retention_${retention_id}.stl" \
      -D "part=\"viewer_retention_${retention_id}\""
  fi
}

run_glb_build() {
  local viewer_args=()
  local variant_id
  for variant_id in "$@"; do
    if ! variant_spec "$variant_id" >/dev/null; then
      echo "Unknown viewer variant: $variant_id" >&2
      usage >&2
      exit 2
    fi
    viewer_args+=(--variant "$variant_id")
  done
  if (( ${#viewer_args[@]} > 0 )); then
    python3 scripts/build_viewer.py "${viewer_args[@]}"
  else
    python3 scripts/build_viewer.py
  fi
}

target="${1:-help}"
if (( $# > 0 )); then
  shift
fi

case "$target" in
  html)
    if (( $# != 0 )); then
      usage >&2
      exit 2
    fi
    python3 scripts/build_viewer.py --html-only
    ;;
  glb)
    run_glb_build "$@"
    ;;
  viewer)
    require_openscad
    selected_variants=("$@")
    if (( ${#selected_variants[@]} == 0 )); then
      selected_variants=("${variant_ids[@]}")
    fi
    trap cleanup_on_exit EXIT INT TERM
    build_shared_viewer_trays
    for variant_id in "${selected_variants[@]}"; do
      build_viewer_variant "$variant_id"
    done
    finish_scad_jobs
    job_pids=()
    trap - EXIT INT TERM
    for variant_id in "${selected_variants[@]}"; do
      if [[ "$variant_id" == "cable_friendly" ]]; then
        cp viewer/variants/cable_friendly/viewer_retention_hybrid_clips.stl \
           viewer/viewer_retention_hybrid_clips.stl
        break
      fi
    done
    run_glb_build "${selected_variants[@]}"
    ;;
  retention)
    require_openscad
    selected_retentions=("$@")
    if (( ${#selected_retentions[@]} == 0 )); then
      selected_retentions=("${retention_ids[@]}")
    fi
    trap cleanup_on_exit EXIT INT TERM
    for retention_id in "${selected_retentions[@]}"; do
      build_retention_overlay "$retention_id"
    done
    finish_scad_jobs
    job_pids=()
    trap - EXIT INT TERM
    for retention_id in "${selected_retentions[@]}"; do
      if [[ "$retention_id" == "hybrid_clips" ]]; then
        cp viewer/variants/cable_friendly/viewer_retention_hybrid_clips.stl \
           viewer/viewer_retention_hybrid_clips.stl
        break
      fi
    done
    run_glb_build
    ;;
  full)
    if (( $# != 0 )); then
      usage >&2
      exit 2
    fi
    exec bash scripts/build_assets.sh
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown build target: $target" >&2
    usage >&2
    exit 2
    ;;
esac
