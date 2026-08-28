#!/usr/bin/env python3
"""Build colored comparison GLBs and refresh the offline HTML viewer.

The default invocation rebuilds the full comparison viewer. Use
``--html-only`` when only the HTML/JavaScript or generated metadata changed,
or one or more ``--variant`` arguments to rebuild selected GLBs while reusing
the other existing GLBs.
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import re
import shutil
import tempfile
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
VIEWER = ROOT / "viewer"

FRICTION_SUPPORT_OPTIONS = [
    {
        "id": "full",
        "label": "Full honeycomb",
        "filename": "viewer_green_tray_friction_full.stl",
        "material_name": "Green tray friction — full honeycomb",
        "roughness": 0.62,
        "note": (
            "The continuous raised honeycomb/perimeter deck supports the "
            "whole underside. This remains available as the higher-material "
            "compatibility comparison."
        ),
    },
    {
        "id": "pads",
        "label": "Four pads",
        "filename": "viewer_green_tray_friction_pads.stl",
        "material_name": "Green tray friction — four pads",
        "roughness": 0.62,
        "note": (
            "The original 3 mm honeycomb floor stays low while four broad "
            "lands at the factory mounting locations carry the Green at its "
            "normal height. This is the selected production support."
        ),
    },
    {
        "id": "skeletal",
        "label": "Open frame",
        "filename": "viewer_green_tray_friction_skeletal.stl",
        "material_name": "Green tray friction — open frame",
        "roughness": 0.62,
        "note": (
            "An exact perimeter, two crossbars, a center spine, and four "
            "support lands replace the full floor for the most open, "
            "lowest-material comparison."
        ),
    },
]

FRICTION_SUPPORT_PARTS = [
    (
        option["filename"],
        option["material_name"],
        (237, 240, 245, 0),
        option["roughness"],
        None,
    )
    for option in FRICTION_SUPPORT_OPTIONS
]

PARTS = [
    (
        "viewer_mount_without_green_tray.stl",
        "White rack mount",
        (237, 240, 245, 255),
        0.72,
        None,
    ),
    (
        "viewer_splitter_side_walls.stl",
        "TP-Link cradle side walls",
        (237, 240, 245, 255),
        0.72,
        None,
    ),
    (
        "viewer_green_tray_standard.stl",
        "Green tray — standard",
        (237, 240, 245, 255),
        0.72,
        None,
    ),
    *FRICTION_SUPPORT_PARTS,
    (
        "viewer_enclosure_airframe.stl",
        "Optional protection — ventilated 1U chassis",
        (237, 240, 245, 0),
        0.72,
        None,
    ),
    ("viewer_insert.stl", "LED window insert", (140, 209, 173, 90), 0.45, None),
    ("viewer_shutter_open.stl", "LED shutter — open", (237, 240, 245, 255), 0.72, None),
    ("viewer_shutter_closed.stl", "LED shutter — closed", (237, 240, 245, 0), 0.72, None),
    ("viewer_shutter_retainer.stl", "LED shutter retainer", (237, 240, 245, 255), 0.72, None),
    ("viewer_logo.stl", "Home Assistant logo", (237, 240, 245, 255), 0.72, None),
    ("viewer_green.stl", "Home Assistant Green", (41, 199, 122, 118), 0.58, None),
    ("viewer_splitter.stl", "TP-Link TL-PD30G-M2", (248, 248, 248, 255), 0.62, None),
    (
        "viewer_green_ports.stl",
        "Home Assistant Green connector faces",
        (18, 20, 23, 255),
        0.48,
        None,
    ),
    (
        "viewer_splitter_ports.stl",
        "PoE splitter connector faces",
        (18, 20, 23, 255),
        0.48,
        None,
    ),
    (
        "viewer_keystone_ports.stl",
        "Front keystone coupler",
        (18, 20, 23, 255),
        0.48,
        None,
    ),
    ("viewer_internal_data_cable.stl", "Internal Ethernet cable", (31, 112, 218, 255), 0.58, None),
    ("viewer_input_data_cable.stl", "Incoming PoE cable", (31, 112, 218, 255), 0.58, None),
    ("viewer_dc_cable.stl", "DC cable", (20, 20, 20, 255), 0.62, None),
    ("viewer_rulers.stl", "10 mm dimension rulers", (230, 151, 36, 210), 0.50, None),
    (
        "viewer_led_power.stl",
        "Status LED — power",
        (255, 255, 244, 255),
        0.22,
        (1.0, 1.0, 0.88),
    ),
    (
        "viewer_led_activity.stl",
        "Status LED — activity",
        (37, 255, 118, 255),
        0.22,
        (0.10, 1.0, 0.34),
    ),
    (
        "viewer_led_health.stl",
        "Status LED — health",
        (255, 196, 35, 255),
        0.22,
        (1.0, 0.52, 0.04),
    ),
]

RETENTION_OPTIONS = [
    {
        "id": "factory_screws",
        "label": "Current M3 screws",
        "short_label": "M3 screws",
        "filename": "viewer_retention_factory_screws.stl",
        "material_name": "Green retention — current M3 screws",
        "color": (110, 115, 122, 0),
        "highlight": (105, 115, 130, 255),
        "roughness": 0.42,
        "printable": True,
        "note": (
            "The best-documented baseline: four M3×25 screws and locating "
            "spacers use the Green's factory bottom holes. Strongest and "
            "least tolerance-sensitive, but this mount still needs a physical "
            "fit test and removal needs a hex key."
        ),
    },
    {
        "id": "slide_latch",
        "label": "Slide rails + rear latch (earlier engineering recommendation)",
        "short_label": "Slide + latch",
        "filename": "viewer_retention_slide_latch.stl",
        "material_name": "Green retention — segmented rails + rear latch",
        "color": (34, 166, 220, 255),
        "highlight": (34, 166, 220, 255),
        "roughness": 0.58,
        "printable": False,
        "note": (
            "Earlier engineering recommendation: four short lower-edge shoes "
            "guide the Green into place; two "
            "rear thumb latches provide positive retention. Best balance of "
            "airflow, serviceability, strength, and material, pending a "
            "caliper/coupon check of the lower-base ledge."
        ),
    },
    {
        "id": "corner_gate",
        "label": "Corner cups + captive rear gate",
        "short_label": "Corner gate",
        "filename": "viewer_retention_corner_gate.stl",
        "material_name": "Green retention — corner cups + rear gate",
        "color": (245, 158, 11, 0),
        "highlight": (245, 158, 11, 255),
        "roughness": 0.58,
        "printable": False,
        "note": (
            "Four low corner cups locate the enclosure and a captive low "
            "rear gate blocks withdrawal. More tolerant than lip-fitting "
            "rails, but adds a separate moving part."
        ),
    },
    {
        "id": "sled_gate",
        "label": "Separate removable sled + rear gate",
        "short_label": "Removable sled",
        "filename": "viewer_retention_sled_gate.stl",
        "material_name": "Green retention — separate sled + rear gate",
        "color": (139, 92, 246, 0),
        "highlight": (139, 92, 246, 255),
        "roughness": 0.58,
        "printable": False,
        "note": (
            "The Green rides in an open U-frame that slides out as a unit. "
            "It is robust and replaceable, while costing the most parts and "
            "filament of the screwless concepts."
        ),
    },
    {
        "id": "padded_rails",
        "label": "Rigid rails + TPU anti-rattle pads",
        "short_label": "TPU pads",
        "filename": "viewer_retention_padded_rails.stl",
        "material_name": "Green retention — rails + TPU pads",
        "color": (124, 58, 237, 0),
        "highlight": (124, 58, 237, 255),
        "roughness": 0.75,
        "printable": False,
        "note": (
            "Small compliant pads preload the Green against rigid rails and "
            "hard stops. Excellent for eliminating rattle, but it still "
            "needs a positive latch for dependable uplift retention."
        ),
    },
    {
        "id": "captive_strap",
        "label": "Captive TPU strap",
        "short_label": "Captive strap",
        "filename": "viewer_retention_captive_strap.stl",
        "material_name": "Green retention — captive strap",
        "color": (168, 85, 247, 0),
        "highlight": (168, 85, 247, 255),
        "roughness": 0.78,
        "printable": False,
        "note": (
            "A hinged TPU strap stays attached when open, so there is no "
            "loose cover or clip. It is tolerant and secure, but consumes "
            "most of the roughly 2 mm remaining 1U clearance."
        ),
    },
    {
        "id": "x_cage",
        "label": "X-brace cage + removable rear cap",
        "short_label": "X-brace cage",
        "filename": "viewer_retention_x_cage.stl",
        "material_name": "Green retention — X-brace cage + rear cap",
        "color": (14, 116, 144, 0),
        "highlight": (14, 116, 144, 255),
        "roughness": 0.60,
        "printable": False,
        "note": (
            "Inspired by MakerWorld 590818: the Green slides into a full "
            "open cage, diagonal top braces prevent lift, and a separate "
            "rear frame closes the sleeve. Very secure, but heavier and less "
            "open; one user reported thin truss nodes breaking."
        ),
    },
    {
        "id": "hybrid_clips",
        "label": "Hybrid top clips · Green + TP-Link",
        "short_label": "Hybrid clips",
        "filename": "viewer_retention_hybrid_clips.stl",
        "material_name": "Device retention — hybrid top clips",
        "color": (37, 99, 235, 0),
        "highlight": (37, 99, 235, 255),
        "roughness": 0.56,
        "printable": False,
        "note": (
            "Community-informed prototype: smooth one-piece catches overlap "
            "the Green's clear top by 0.8 mm. The TP-Link uses matched 0.8 mm "
            "catches grown directly from its mini side walls; relief slots "
            "let the accessible wall tongue flex. The lower guides account for "
            "the Green's measured 109.54 mm base, its published 112 mm cover "
            "envelope, and the TP-Link's lower bevel. Existing low stops take "
            "fore/aft loads. Print the combined two-device clip coupon before "
            "production."
        ),
    },
    {
        "id": "friction_sleeve",
        "label": "Integrated raised-tray friction fit",
        "short_label": "Tray friction fit",
        "filename": "viewer_green_tray_friction_full.stl",
        "material_name": "Green tray friction — full honeycomb",
        "color": (16, 185, 129, 0),
        "highlight": (16, 185, 129, 255),
        "roughness": 0.62,
        "printable": True,
        "note": (
            "Selected production retention: smooth continuous side walls and "
            "shallow front/rear stops are built into the tray and hold the "
            "Green with a close interference fit. A 3 mm lead-in chamfer "
            "guides insertion without localized ribs, tabs, or clips. The "
            "support remains fused into the tray at the normal LED height, "
            "with Four pads selected and full-honeycomb/open-frame variants "
            "available for comparison. There is no separate sleeve to print. "
            "Print the fit coupon before the full plate and check for surface "
            "scuffing and long-term PETG relaxation."
        ),
    },
]

RETENTION_PARTS = [
    (
        option["filename"],
        option["material_name"],
        option["color"],
        option["roughness"],
        None,
    )
    for option in RETENTION_OPTIONS
    if option["id"] != "friction_sleeve"
]

SHUTTER_PART_FILENAMES = {
    "viewer_insert.stl",
    "viewer_shutter_open.stl",
    "viewer_shutter_closed.stl",
    "viewer_shutter_retainer.stl",
}

NO_SHUTTER_FILE_OVERRIDES = {
    "viewer_mount_without_green_tray.stl": (
        "viewer_mount_without_green_tray_no_shutter.stl"
    ),
}

SHARED_PART_FILENAMES = {
    "viewer_green_tray_standard.stl",
    *(option["filename"] for option in FRICTION_SUPPORT_OPTIONS),
}

# Unlike the other retention studies, the hybrid overlay contains TP-Link
# catches as well as Green geometry. Its splitter coordinates therefore follow
# each layout's setback and cannot be shared across Compact/Balanced/etc.
VARIANT_RETENTION_FILENAMES = {
    "viewer_retention_hybrid_clips.stl",
}

SHUTTER_CONFIGURATION = "shutter"
NO_SHUTTER_CONFIGURATION = "no_shutter"
SHUTTER_CONFIGURATIONS = (SHUTTER_CONFIGURATION, NO_SHUTTER_CONFIGURATION)

VARIANTS = [
    {
        "id": "compact",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Compact",
        "setback": "35 mm splitter setback",
        "dimensions": "254 W × 43 H × 120 D mm",
        "note": (
            "Collision-aware mockup keeps cable meshes out of the panel, but "
            "it can do so only by tightening the RJ45 bend to about 3.7 mm "
            "and the DC bend to about 7.6 mm. Orange cables flag those "
            "bend-radius violations; this is not a production choice."
        ),
    },
    {
        "id": "balanced",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Balanced",
        "setback": "47.5 mm splitter setback",
        "dimensions": "254 W × 43 H × 131.2 D mm",
        "note": (
            "The DC route clears at its full 10 mm radius. The orange Ethernet "
            "route clears the panel only at about 16.2 mm rather than the "
            "published 21 mm target, so treat this as a slim-cable test fit."
        ),
    },
    {
        "id": "cable_friendly",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Cable-friendly",
        "setback": "60 mm splitter setback",
        "dimensions": "254 W × 43 H × 143.7 D mm",
        "note": (
            "Current printable and straight-cable baseline. Separate X/Z "
            "lanes keep both jumpers clear of the panel, devices, and each "
            "other while preserving the full 21 mm RJ45 and 10 mm DC bends."
        ),
    },
    {
        "id": "front_ethernet_right",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Front Ethernet — center gap",
        "setback": "60 mm splitter setback · centered gap keystone",
        "dimensions": "254 W × 43 H × 143.7 D mm printed mount",
        "note": (
            "Compact front-entry edition: the vertically centered keystone "
            "sits in the device gap. Layered "
            "LAN/DC/PoE routes preserve their modeled bend radii without "
            "increasing printed depth. Use 0.4 m minimum / 0.5 m preferred "
            "for both Ethernet jumpers; a 350 mm DC lead is safer than 300 mm."
        ),
    },
    {
        "id": "front_ethernet_far_right",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Front Ethernet — HA right",
        "setback": "60 mm splitter setback · jack right of HA Green",
        "dimensions": "254 W × 43 H × 143.7 D mm · one-piece only",
        "note": (
            "The vertically centered keystone sits on the physical right side "
            "of the Home Assistant Green. With shutter hardware installed, "
            "the flush actuator moves to the window's left side. The incoming "
            "PoE jumper keeps a full 21 mm bend radius; use 0.4 m minimum / "
            "0.5 m preferred. This edition is one-piece only because the jack "
            "occupies the detachable right-ear joint zone."
        ),
    },
    {
        "id": "front_ethernet_left",
        "device": "tplink",
        "device_name": "TP-Link TL-PD30G-M2",
        "label": "Front Ethernet — left",
        "setback": "89 mm splitter setback · centered left keystone",
        "dimensions": "254 W × 43 H × 172.7 D mm printed mount",
        "note": (
            "Alternate front-entry edition with the vertically centered jack "
            "in the left face area. The splitter moves 29 mm rearward so an "
            "ordinary straight plug can rise over it with at least the modeled "
            "21 mm bend radius. The cable envelope reaches about 218.3 mm. "
            "Use 0.4 m minimum / 0.5 m preferred for the front PoE jumper."
        ),
    },
    {
        "id": "sics_angled",
        "device": "sics",
        "device_name": "SICSOLINK SL-FLQ-POE48K",
        "label": "SICSOLINK rear-angle",
        "setback": "40° rear-input placement",
        "dimensions": "254 W × 43 H × 202 D mm mount",
        "note": (
            "Cable-valid comparison for the seller-stated 180 mm captive "
            "leads. The visible LAN/DC routes consume about 165–170 mm, "
            "leaving roughly 10–15 mm tolerance; a tighter direct route was "
            "previously estimated at 125–130 mm. Its PoE input points "
            "diagonally rear-left. Viewer mockup only—not a current printable "
            "export."
        ),
    },
]

DEFAULT_VARIANT = "cable_friendly"
PRODUCTION_VARIANT = "cable_friendly"


def load_mesh(path: Path) -> Any:
    import trimesh

    loaded = trimesh.load(path, force="mesh", process=False)
    if not isinstance(loaded, trimesh.Trimesh):
        raise TypeError(f"Expected a mesh from {path}, got {type(loaded)!r}")
    loaded.units = "mm"
    return loaded


Part = tuple[
    str,
    str,
    tuple[int, ...],
    float,
    tuple[float, float, float] | None,
    Any,
]


def load_variants(
    required_variant_retention: set[str] | None = None,
) -> dict[str, dict[str, list[Part]]]:
    loaded: dict[str, dict[str, list[Part]]] = {}
    for variant in VARIANTS:
        variant_dir = VIEWER / "variants" / variant["id"]
        configurations: dict[str, list[Part]] = {}
        for configuration in SHUTTER_CONFIGURATIONS:
            loaded_parts: list[Part] = []
            for filename, base_name, base_color, roughness, emissive in PARTS:
                if configuration == NO_SHUTTER_CONFIGURATION \
                        and filename in SHUTTER_PART_FILENAMES:
                    continue
                if filename == "viewer_keystone_ports.stl" \
                        and not variant["id"].startswith("front_ethernet_"):
                    continue
                if filename == "viewer_splitter_side_walls.stl" \
                        and variant["device"] != "tplink":
                    continue

                source_filename = (
                    NO_SHUTTER_FILE_OVERRIDES.get(filename, filename)
                    if configuration == NO_SHUTTER_CONFIGURATION
                    else filename
                )
                name = base_name
                color = base_color
                if filename == "viewer_splitter.stl" and variant["device"] == "sics":
                    name = "SICSOLINK SL-FLQ-POE48K"
                if variant["id"].startswith("front_ethernet_") \
                        and filename == "viewer_input_data_cable.stl":
                    name = "Front keystone → TP-Link PoE jumper"
                if variant["id"] in {"compact", "balanced"} \
                        and filename == "viewer_internal_data_cable.stl":
                    name = "Ethernet cable — bend-radius warning"
                    color = (232, 119, 34, 190)
                if variant["id"] == "compact" \
                        and filename == "viewer_dc_cable.stl":
                    name = "DC cable — bend-radius warning"
                    color = (232, 119, 34, 190)
                source_path = (
                    VIEWER / source_filename
                    if filename in SHARED_PART_FILENAMES
                    else variant_dir / source_filename
                )
                loaded_parts.append(
                    (source_filename, name, color, roughness, emissive,
                     load_mesh(source_path))
                )
            for filename, name, color, roughness, emissive in RETENTION_PARTS:
                if filename in VARIANT_RETENTION_FILENAMES:
                    variant_path = variant_dir / filename
                    if variant_path.is_file():
                        source_path = variant_path
                    elif required_variant_retention is not None \
                            and variant["id"] in required_variant_retention:
                        raise FileNotFoundError(
                            "Missing variant-specific retention mesh: "
                            f"{variant_path}"
                        )
                    else:
                        # Partial viewer rebuilds reuse existing GLBs for
                        # unselected variants. Their raw meshes are loaded only
                        # to preserve the common scene transform, so the legacy
                        # cable-friendly overlay is an acceptable fallback.
                        source_path = VIEWER / filename
                else:
                    source_path = VIEWER / filename
                loaded_parts.append(
                    (filename, name, color, roughness, emissive,
                     load_mesh(source_path))
                )
            configurations[configuration] = loaded_parts
        loaded[variant["id"]] = configurations
    return loaded


def common_transform(variants: dict[str, dict[str, list[Part]]]) -> Any:
    import numpy as np
    import trimesh

    bounds = np.array(
        [
            mesh.bounds
            for configurations in variants.values()
            for raw in configurations.values()
            for *_, mesh in raw
        ]
    )
    minimum = bounds[:, 0, :].min(axis=0)
    maximum = bounds[:, 1, :].max(axis=0)
    center = (minimum + maximum) / 2.0

    # OpenSCAD is Z-up. model-viewer/glTF is Y-up; center and rotate -90° X.
    translate = trimesh.transformations.translation_matrix(-center)
    rotate = trimesh.transformations.rotation_matrix(np.radians(-90.0), [1, 0, 0])
    return rotate @ translate


def build_variant(raw: list[Part], transform: Any, title: str) -> bytes:
    import numpy as np
    import trimesh

    scene = trimesh.Scene(base_frame="world")
    for _filename, name, rgba, roughness, emissive, mesh in raw:
        mesh.apply_transform(transform)
        material = trimesh.visual.material.PBRMaterial(
            name=name,
            baseColorFactor=np.asarray(rgba, dtype=np.uint8),
            emissiveFactor=(
                None if emissive is None else np.asarray(emissive, dtype=float)
            ),
            metallicFactor=0.03,
            roughnessFactor=roughness,
            alphaMode="BLEND" if rgba[3] < 255 else "OPAQUE",
            doubleSided=True,
        )
        mesh.visual = trimesh.visual.TextureVisuals(material=material)
        scene.add_geometry(mesh, node_name=name, geom_name=name)

    scene.metadata["title"] = title
    exported = scene.export(file_type="glb")
    if not isinstance(exported, bytes):
        raise TypeError(f"Expected GLB bytes, got {type(exported)!r}")
    return exported


def glb_path(variant_id: str, configuration: str) -> Path:
    filename_suffix = "" if configuration == SHUTTER_CONFIGURATION else "-no_shutter"
    return VIEWER / f"home-assistant-green-rack-{variant_id}{filename_suffix}.glb"


def atomic_write_bytes(path: Path, data: bytes) -> None:
    """Replace a generated binary without exposing a partially written file."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary.write(data)
            temporary_name = temporary.name
        os.chmod(temporary_name, 0o644)
        os.replace(temporary_name, path)
    finally:
        if temporary_name is not None:
            try:
                Path(temporary_name).unlink()
            except FileNotFoundError:
                pass


def atomic_write_text(path: Path, text: str) -> None:
    """Replace generated text without exposing a partially written file."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary.write(text)
            temporary_name = temporary.name
        os.chmod(temporary_name, 0o644)
        os.replace(temporary_name, path)
    finally:
        if temporary_name is not None:
            try:
                Path(temporary_name).unlink()
            except FileNotFoundError:
                pass


def load_existing_glbs() -> dict[str, dict[str, bytes]]:
    """Load already-built GLBs for a fast HTML-only or partial refresh."""
    glbs: dict[str, dict[str, bytes]] = {}
    missing: list[Path] = []
    for variant in VARIANTS:
        variant_id = variant["id"]
        glbs[variant_id] = {}
        for configuration in SHUTTER_CONFIGURATIONS:
            path = glb_path(variant_id, configuration)
            if not path.is_file():
                missing.append(path)
                continue
            glbs[variant_id][configuration] = path.read_bytes()

    if missing:
        relative = "\n  ".join(str(path.relative_to(ROOT)) for path in missing)
        raise FileNotFoundError(
            "Incremental viewer build needs existing GLBs. Missing:\n  "
            f"{relative}\nRun `scripts/build.sh viewer` or the full build first."
        )
    return glbs


def build_glbs(selected_variants: set[str]) -> dict[str, dict[str, bytes]]:
    """Build selected GLBs and reuse existing files for unselected variants."""
    raw_variants = load_variants(selected_variants)
    transform = common_transform(raw_variants)
    all_variant_ids = {variant["id"] for variant in VARIANTS}
    glbs = (
        {}
        if selected_variants == all_variant_ids
        else load_existing_glbs()
    )

    for variant in VARIANTS:
        variant_id = variant["id"]
        if variant_id not in selected_variants:
            continue
        glbs[variant_id] = {}
        for configuration in SHUTTER_CONFIGURATIONS:
            configuration_label = (
                "with captive shutter"
                if configuration == SHUTTER_CONFIGURATION
                else "without shutter hardware"
            )
            glb = build_variant(
                raw_variants[variant_id][configuration],
                transform,
                (
                    f"Home Assistant Green rack mount — {variant['label']} "
                    f"placement, {configuration_label}"
                ),
            )
            output_path = glb_path(variant_id, configuration)
            atomic_write_bytes(output_path, glb)
            glbs[variant_id][configuration] = glb
            print(f"Wrote {output_path.relative_to(ROOT)} ({len(glb):,} bytes)")

    # The unqualified standalone preview follows the selected production
    # layout and open-window/no-shutter front. Keep an explicitly named
    # shutter comparison without making it look canonical.
    preview_path = VIEWER / "home-assistant-green-rack-preview.glb"
    atomic_write_bytes(
        preview_path,
        glbs[PRODUCTION_VARIANT][NO_SHUTTER_CONFIGURATION],
    )
    preview_no_shutter_path = (
        VIEWER / "home-assistant-green-rack-preview-no_shutter.glb"
    )
    atomic_write_bytes(
        preview_no_shutter_path,
        glbs[PRODUCTION_VARIANT][NO_SHUTTER_CONFIGURATION]
    )
    atomic_write_bytes(
        VIEWER / "home-assistant-green-rack-preview-with_shutter.glb",
        glbs[PRODUCTION_VARIANT][SHUTTER_CONFIGURATION],
    )
    # Backward-compatible alias follows the legacy center-gap (`right`) edition.
    atomic_write_bytes(
        VIEWER / "home-assistant-green-rack-front_ethernet.glb",
        glbs["front_ethernet_right"][SHUTTER_CONFIGURATION]
    )
    atomic_write_bytes(
        VIEWER / "home-assistant-green-rack-front_ethernet-no_shutter.glb",
        glbs["front_ethernet_right"][NO_SHUTTER_CONFIGURATION]
    )
    return glbs


def refresh_html(glbs: dict[str, dict[str, bytes]]) -> None:
    """Embed GLBs and generated option metadata in the offline HTML viewer."""

    embedded_models = {}
    for variant in VARIANTS:
        variant_id = variant["id"]
        embedded_models[variant_id] = {
            **variant,
            "filename": f"home-assistant-green-rack-{variant_id}.glb",
            "no_shutter_filename": (
                f"home-assistant-green-rack-{variant_id}-no_shutter.glb"
            ),
            "src": (
                "data:model/gltf-binary;base64,"
                + base64.b64encode(
                    glbs[variant_id][SHUTTER_CONFIGURATION]
                ).decode("ascii")
            ),
            "no_shutter_src": (
                "data:model/gltf-binary;base64,"
                + base64.b64encode(
                    glbs[variant_id][NO_SHUTTER_CONFIGURATION]
                ).decode("ascii")
            ),
        }

    html_path = VIEWER / "interactive_viewer.html"
    html = html_path.read_text(encoding="utf-8")
    # MODEL_VARIANTS already contains the selected startup GLB. Do not embed
    # the same multi-megabyte data URI a second time on <model-viewer>; the
    # startup selectVariant() call assigns it before interaction begins.
    html, src_count = re.subn(
        r'(<model-viewer id="rack") src="data:model/gltf-binary;base64,[^"]+"',
        r"\1",
        html,
        count=1,
    )
    if src_count > 1:
        raise RuntimeError("Found multiple primary embedded GLBs in the viewer")

    payload = json.dumps(embedded_models, separators=(",", ":"))
    html, payload_count = re.subn(
        r"const MODEL_VARIANTS = /\* MODEL_VARIANTS_START \*/.*?"
        r"/\* MODEL_VARIANTS_END \*/;",
        lambda _match: (
            f"const MODEL_VARIANTS = /* MODEL_VARIANTS_START */ {payload} "
            "/* MODEL_VARIANTS_END */;"
        ),
        html,
        count=1,
        flags=re.DOTALL,
    )
    if payload_count != 1:
        raise RuntimeError("Could not locate the generated variant-data block")

    retention_payload = json.dumps(
        {
            option["id"]: {
                key: value
                for key, value in option.items()
                if key not in {"filename", "color", "highlight"}
            }
            | {
                "highlight": [channel / 255 for channel in option["highlight"]],
            }
            for option in RETENTION_OPTIONS
        },
        separators=(",", ":"),
    )
    html, retention_count = re.subn(
        r"const RETENTION_OPTIONS = /\* RETENTION_OPTIONS_START \*/.*?"
        r"/\* RETENTION_OPTIONS_END \*/;",
        lambda _match: (
            f"const RETENTION_OPTIONS = /* RETENTION_OPTIONS_START */ "
            f"{retention_payload} /* RETENTION_OPTIONS_END */;"
        ),
        html,
        count=1,
        flags=re.DOTALL,
    )
    if retention_count != 1:
        raise RuntimeError("Could not locate the generated retention-data block")

    friction_support_payload = json.dumps(
        {
            option["id"]: {
                key: value
                for key, value in option.items()
                if key != "filename"
            }
            for option in FRICTION_SUPPORT_OPTIONS
        },
        separators=(",", ":"),
    )
    html, friction_support_count = re.subn(
        r"const FRICTION_SUPPORT_OPTIONS = "
        r"/\* FRICTION_SUPPORT_OPTIONS_START \*/.*?"
        r"/\* FRICTION_SUPPORT_OPTIONS_END \*/;",
        lambda _match: (
            "const FRICTION_SUPPORT_OPTIONS = "
            f"/* FRICTION_SUPPORT_OPTIONS_START */ {friction_support_payload} "
            "/* FRICTION_SUPPORT_OPTIONS_END */;"
        ),
        html,
        count=1,
        flags=re.DOTALL,
    )
    if friction_support_count != 1:
        raise RuntimeError(
            "Could not locate the generated friction-support-data block"
        )

    atomic_write_text(html_path, html)
    # Remove artifacts from the retired zero-standoff paired-model approach.
    # The raised friction deck now shares the normal Green/LED coordinates.
    for path in VIEWER.glob("home-assistant-green-rack-*-friction-seat*.glb"):
        path.unlink()
    for variant in VARIANTS:
        shutil.rmtree(
            VIEWER / "variants" / variant["id"] / "friction_seat",
            ignore_errors=True,
        )
    print(f"Refreshed {html_path.relative_to(ROOT)} with {len(VARIANTS)} mockups")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--html-only",
        action="store_true",
        help=(
            "reuse existing GLBs and only refresh the embedded HTML/payload; "
            "does not require NumPy or trimesh"
        ),
    )
    parser.add_argument(
        "--variant",
        action="append",
        choices=[variant["id"] for variant in VARIANTS],
        help=(
            "rebuild only this variant's shutter and no-shutter GLBs; may be "
            "repeated, and existing GLBs are reused for other variants"
        ),
    )
    args = parser.parse_args()
    if args.html_only and args.variant:
        parser.error("--html-only cannot be combined with --variant")
    return args


def main() -> None:
    args = parse_args()
    all_variant_ids = {variant["id"] for variant in VARIANTS}
    if args.html_only:
        glbs = load_existing_glbs()
    else:
        glbs = build_glbs(set(args.variant or all_variant_ids))
        print("Updated compatibility GLB aliases")
    refresh_html(glbs)


if __name__ == "__main__":
    main()
