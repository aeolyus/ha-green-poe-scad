#!/usr/bin/env python3
"""Prepare a lightweight, reproducible GitHub Pages copy of the project."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


MODEL_BLOCK = re.compile(
    r"(const MODEL_VARIANTS = /\* MODEL_VARIANTS_START \*/ )(.*?)"
    r"( /\* MODEL_VARIANTS_END \*/;)",
    re.DOTALL,
)


def externalize_viewer(root: Path) -> None:
    viewer = root / "viewer" / "interactive_viewer.html"
    html = viewer.read_text(encoding="utf-8")
    match = MODEL_BLOCK.search(html)
    if match is None:
        raise RuntimeError("Could not locate MODEL_VARIANTS in interactive viewer")

    variants = json.loads(match.group(2))
    for variant in variants.values():
        variant["src"] = variant["filename"]
        variant["no_shutter_src"] = variant["no_shutter_filename"]

    payload = json.dumps(variants, separators=(",", ":"))
    html = MODEL_BLOCK.sub(
        lambda found: f"{found.group(1)}{payload}{found.group(3)}",
        html,
        count=1,
    )
    viewer.write_text(html, encoding="utf-8")


def write_manifest(root: Path) -> None:
    manifest: dict[str, dict[str, int | str]] = {}
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        if (
            not path.is_file()
            or ".git" in relative.parts
            or "__pycache__" in relative.parts
            or path.name == "SITE_MANIFEST.json"
            or path.name == "interactive_viewer_offline.html"
            or path.suffix == ".pyc"
        ):
            continue
        data = path.read_bytes()
        manifest[relative.as_posix()] = {
            "bytes": len(data),
            "sha256": hashlib.sha256(data).hexdigest(),
        }
    (root / "SITE_MANIFEST.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path, help="Static-site repository root")
    args = parser.parse_args()
    root = args.root.resolve()
    externalize_viewer(root)
    write_manifest(root)
    print(f"Prepared static site at {root}")


if __name__ == "__main__":
    main()
