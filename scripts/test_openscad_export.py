#!/usr/bin/env python3
"""Regression tests for the desktop STL topology validator."""

from __future__ import annotations

from pathlib import Path
import struct
import tempfile
import unittest

try:
    from scripts.openscad_export import requested_backend, validate_stl
except ModuleNotFoundError:
    from openscad_export import requested_backend, validate_stl


Point = tuple[float, float, float]
Face = tuple[int, int, int]


def tetrahedron(offset: Point = (0, 0, 0), scale: float = 1.0,
                inward: bool = False) -> tuple[list[Point], list[Face]]:
    points = [
        (offset[0], offset[1], offset[2]),
        (offset[0] + scale, offset[1], offset[2]),
        (offset[0], offset[1] + scale, offset[2]),
        (offset[0], offset[1], offset[2] + scale),
    ]
    faces = [(0, 2, 1), (0, 1, 3), (0, 3, 2), (1, 2, 3)]
    if inward:
        faces = [(a, c, b) for a, b, c in faces]
    return points, faces


def combine(parts: list[tuple[list[Point], list[Face]]]) -> tuple[list[Point], list[Face]]:
    points: list[Point] = []
    faces: list[Face] = []
    for part_points, part_faces in parts:
        offset = len(points)
        points.extend(part_points)
        faces.extend((a + offset, b + offset, c + offset) for a, b, c in part_faces)
    return points, faces


def write_binary_stl(path: Path, points: list[Point], faces: list[Face]) -> None:
    payload = bytearray(84 + len(faces) * 50)
    struct.pack_into("<I", payload, 80, len(faces))
    for index, face in enumerate(faces):
        values = [0.0, 0.0, 0.0]
        for vertex in face:
            values.extend(points[vertex])
        values.append(0)
        struct.pack_into("<12fH", payload, 84 + index * 50, *values)
    path.write_bytes(payload)


class ValidatorTest(unittest.TestCase):
    def validate(self, parts: list[tuple[list[Point], list[Face]]]) -> tuple[bool, str]:
        points, faces = combine(parts)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "mesh.stl"
            write_binary_stl(path, points, faces)
            return validate_stl(path)

    def test_single_closed_shell(self) -> None:
        valid, detail = self.validate([tetrahedron()])
        self.assertTrue(valid, detail)

    def test_two_separate_positive_shells(self) -> None:
        valid, detail = self.validate([
            tetrahedron(), tetrahedron((3, 0, 0)),
        ])
        self.assertTrue(valid, detail)
        self.assertIn("2 component", detail)

    def test_rejects_detached_inward_shell(self) -> None:
        valid, detail = self.validate([
            tetrahedron(scale=3), tetrahedron((5, 0, 0), inward=True),
        ])
        self.assertFalse(valid)
        self.assertIn("detached inward-wound", detail)

    def test_allows_nested_inward_cavity(self) -> None:
        valid, detail = self.validate([
            tetrahedron(scale=4), tetrahedron((0.5, 0.5, 0.5), 0.5, True),
        ])
        self.assertTrue(valid, detail)

    def test_rejects_point_touching_shells(self) -> None:
        first = tetrahedron()
        second = tetrahedron((-1, 0, 0))
        # The first shell's origin and the second shell's +X vertex coincide,
        # while all edges remain independent.
        points, faces = combine([first, second])
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bow-tie.stl"
            write_binary_stl(path, points, faces)
            valid, detail = validate_stl(path)
        self.assertFalse(valid)
        self.assertIn("vertex fan", detail)

    def test_rejects_numerically_thin_closed_shell(self) -> None:
        points = [
            (0, 0, 0),
            (1e-8, 0, 0),
            (0, 1, 0),
            (0, 0, 1),
        ]
        faces = [(0, 2, 1), (0, 1, 3), (0, 3, 2), (1, 2, 3)]
        valid, detail = self.validate([(points, faces)])
        self.assertFalse(valid)
        self.assertIn("zero-thickness", detail)

    def test_reads_explicit_backend(self) -> None:
        self.assertEqual(requested_backend(["--backend=CGAL"]), "CGAL")
        self.assertEqual(
            requested_backend(["--backend", "Manifold", "-o", "x.stl"]),
            "Manifold",
        )
        self.assertIsNone(requested_backend(["-o", "x.stl"]))


if __name__ == "__main__":
    unittest.main()
