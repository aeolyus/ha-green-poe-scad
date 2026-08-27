#!/usr/bin/env python3
"""Atomic OpenSCAD exporter with validated Manifold-to-CGAL fallback.

STL exports use the fast Manifold backend when the selected OpenSCAD build
supports it. The resulting binary STL is accepted only when every triangle is
finite and every undirected edge is used exactly twice with opposite winding.
If export or validation fails, the same command is retried with CGAL.

Other output formats are passed through unchanged, but still use a temporary
file in the destination directory so a failed render cannot replace a known
good artifact.
"""

from __future__ import annotations

import math
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from typing import Iterable, Sequence


def select_engine() -> str:
    configured = os.environ.get("OPENSCAD_ENGINE_BIN") or os.environ.get(
        "OPENSCAD_BIN"
    )
    if configured:
        return configured
    return shutil.which("openscad-unstable") or shutil.which("openscad") or ""


def find_output(arguments: Sequence[str]) -> tuple[int, Path]:
    for index, argument in enumerate(arguments):
        if argument in {"-o", "--o"}:
            if index + 1 >= len(arguments):
                raise ValueError(f"{argument} requires an output path")
            return index + 1, Path(arguments[index + 1])
        if argument.startswith("--o="):
            return index, Path(argument.split("=", 1)[1])
    raise ValueError("OpenSCAD arguments must include -o OUTPUT")


def replace_output(
    arguments: Sequence[str], output_index: int, output: Path
) -> list[str]:
    updated = list(arguments)
    if updated[output_index].startswith("--o="):
        updated[output_index] = f"--o={output}"
    else:
        updated[output_index] = str(output)
    return updated


def without_controlled_options(arguments: Sequence[str]) -> list[str]:
    """Remove backend/format flags which this wrapper owns for STL output."""
    cleaned: list[str] = []
    skip_next = False
    for argument in arguments:
        if skip_next:
            skip_next = False
            continue
        if argument in {"--backend", "--export-format"}:
            skip_next = True
            continue
        if argument.startswith("--backend=") or argument.startswith(
            "--export-format="
        ):
            continue
        cleaned.append(argument)
    return cleaned


def engine_features(engine: str) -> tuple[bool, bool]:
    completed = subprocess.run(
        [engine, "--help"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        check=False,
    )
    help_text = completed.stdout
    return "--backend" in help_text, "--export-format" in help_text


def temporary_path(destination: Path, label: str) -> Path:
    destination.parent.mkdir(parents=True, exist_ok=True)
    descriptor, raw_path = tempfile.mkstemp(
        prefix=f".{destination.stem}.{label}.",
        suffix=destination.suffix,
        dir=destination.parent,
    )
    os.close(descriptor)
    candidate = Path(raw_path)
    candidate.unlink()
    return candidate


def run_export(engine: str, arguments: Sequence[str], label: str) -> tuple[int, float]:
    started = time.monotonic()
    completed = subprocess.run([engine, *arguments], check=False)
    elapsed = time.monotonic() - started
    if completed.returncode != 0:
        print(
            f"[openscad] {label} export failed after {elapsed:.2f}s "
            f"(exit {completed.returncode})",
            file=sys.stderr,
        )
    return completed.returncode, elapsed


Vertex = tuple[float, float, float]
Triangle = tuple[Vertex, Vertex, Vertex]


def normalized_vertex(values: Iterable[float]) -> Vertex:
    vertex = tuple(0.0 if value == 0.0 else float(value) for value in values)
    if len(vertex) != 3 or not all(math.isfinite(value) for value in vertex):
        raise ValueError("non-finite vertex")
    return vertex  # type: ignore[return-value]


def binary_triangles(data: bytes) -> list[Triangle] | None:
    if len(data) < 84:
        return None
    triangle_count = struct.unpack_from("<I", data, 80)[0]
    if len(data) != 84 + triangle_count * 50:
        return None
    triangles: list[Triangle] = []
    record = struct.Struct("<12fH")
    offset = 84
    for _ in range(triangle_count):
        values = record.unpack_from(data, offset)
        triangles.append(
            (
                normalized_vertex(values[3:6]),
                normalized_vertex(values[6:9]),
                normalized_vertex(values[9:12]),
            )
        )
        offset += record.size
    return triangles


def ascii_triangles(data: bytes) -> list[Triangle]:
    vertices: list[Vertex] = []
    try:
        text = data.decode("ascii")
    except UnicodeDecodeError as error:
        raise ValueError("not a binary or ASCII STL") from error
    for line in text.splitlines():
        fields = line.split()
        if fields and fields[0].lower() == "vertex" and len(fields) == 4:
            vertices.append(normalized_vertex(float(value) for value in fields[1:]))
    if not vertices or len(vertices) % 3:
        raise ValueError("ASCII STL has an invalid vertex count")
    return [
        (vertices[index], vertices[index + 1], vertices[index + 2])
        for index in range(0, len(vertices), 3)
    ]


def validate_stl(path: Path) -> tuple[bool, str]:
    try:
        data = path.read_bytes()
        triangles = binary_triangles(data)
        if triangles is None:
            triangles = ascii_triangles(data)
        if not triangles:
            raise ValueError("STL contains no triangles")

        edge_counts: dict[tuple[Vertex, Vertex], list[int]] = {}
        signed_volume_times_six = 0.0
        for first, second, third in triangles:
            if first == second or second == third or third == first:
                raise ValueError("STL contains a degenerate triangle")
            signed_volume_times_six += (
                first[0] * (second[1] * third[2] - second[2] * third[1])
                - first[1] * (second[0] * third[2] - second[2] * third[0])
                + first[2] * (second[0] * third[1] - second[1] * third[0])
            )
            for start, end in (
                (first, second),
                (second, third),
                (third, first),
            ):
                if start < end:
                    key = (start, end)
                    direction = 1
                else:
                    key = (end, start)
                    direction = -1
                use = edge_counts.setdefault(key, [0, 0])
                use[0] += 1
                use[1] += direction

        boundary_edges = sum(use[0] == 1 for use in edge_counts.values())
        overused_edges = sum(use[0] > 2 for use in edge_counts.values())
        winding_edges = sum(
            use[0] == 2 and use[1] != 0 for use in edge_counts.values()
        )
        if boundary_edges or overused_edges or winding_edges:
            return False, (
                f"{len(triangles)} triangles; {boundary_edges} boundary, "
                f"{overused_edges} over-shared, {winding_edges} winding edges"
            )
        if abs(signed_volume_times_six) < 1e-12:
            return False, f"{len(triangles)} triangles; zero signed volume"
        return True, f"{len(triangles)} triangles; closed 2-manifold"
    except (OSError, ValueError, struct.error) as error:
        return False, str(error)


def atomic_passthrough(
    engine: str, arguments: Sequence[str], output_index: int, destination: Path
) -> int:
    candidate = temporary_path(destination, "render")
    try:
        return_code, elapsed = run_export(
            engine,
            replace_output(arguments, output_index, candidate),
            "OpenSCAD",
        )
        if return_code != 0 or not candidate.is_file() or candidate.stat().st_size == 0:
            return return_code or 1
        os.replace(candidate, destination)
        print(f"[openscad] wrote {destination} atomically in {elapsed:.2f}s")
        return 0
    finally:
        candidate.unlink(missing_ok=True)


def validated_stl_export(
    engine: str,
    arguments: Sequence[str],
    destination: Path,
    supports_backend: bool,
    supports_export_format: bool,
) -> int:
    controlled = without_controlled_options(arguments)
    controlled_output_index, _ = find_output(controlled)
    format_arguments = ["--export-format", "binstl"] if supports_export_format else []
    backends = ["Manifold", "CGAL"] if supports_backend else ["CGAL"]

    for backend in backends:
        candidate = temporary_path(destination, backend.lower())
        try:
            backend_arguments = (
                ["--backend", backend] if supports_backend else []
            )
            command_arguments = [
                *backend_arguments,
                *format_arguments,
                *replace_output(controlled, controlled_output_index, candidate),
            ]
            return_code, elapsed = run_export(engine, command_arguments, backend)
            if return_code == 0 and candidate.is_file():
                valid, detail = validate_stl(candidate)
            else:
                valid, detail = False, "no usable STL produced"
            if valid:
                os.replace(candidate, destination)
                print(
                    f"[openscad] {backend} accepted in {elapsed:.2f}s: "
                    f"{destination} ({detail})"
                )
                return 0
            if backend == "Manifold":
                print(
                    f"[openscad] Manifold rejected for {destination}: {detail}; "
                    "retrying with CGAL",
                    file=sys.stderr,
                )
            else:
                print(
                    f"[openscad] CGAL rejected for {destination}: {detail}",
                    file=sys.stderr,
                )
        finally:
            candidate.unlink(missing_ok=True)
    return 1


def main() -> int:
    engine = select_engine()
    if len(sys.argv) == 2 and sys.argv[1] == "--check":
        if not engine or not shutil.which(engine):
            print(
                "OpenSCAD not found. Set OPENSCAD_BIN or install "
                "openscad-unstable/openscad.",
                file=sys.stderr,
            )
            return 1
        supports_backend, supports_export_format = engine_features(engine)
        mode = "Manifold with CGAL fallback" if supports_backend else "legacy CGAL"
        output_format = "binary STL" if supports_export_format else "native STL"
        print(f"OpenSCAD: {engine} ({mode}, {output_format})")
        return 0

    if not engine or not shutil.which(engine):
        print(
            "OpenSCAD not found. Set OPENSCAD_BIN or install "
            "openscad-unstable/openscad.",
            file=sys.stderr,
        )
        return 127
    arguments = sys.argv[1:]
    try:
        output_index, destination = find_output(arguments)
    except ValueError as error:
        print(f"openscad_export.py: {error}", file=sys.stderr)
        return 2

    supports_backend, supports_export_format = engine_features(engine)
    if destination.suffix.lower() != ".stl":
        return atomic_passthrough(engine, arguments, output_index, destination)
    return validated_stl_export(
        engine,
        arguments,
        destination,
        supports_backend,
        supports_export_format,
    )


if __name__ == "__main__":
    raise SystemExit(main())
