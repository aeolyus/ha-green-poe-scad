// Regression fixture: any exported geometry is an intersection between the
// side-by-side cage bridge and a modeled cable/plug envelope.
//
// Example:
//   openscad -o /tmp/bridge-cable-collision.stl \
//     -D 'part="__validation_only__"' \
//     scripts/bridge_cable_collision.scad

include <../ha_green_rack.scad>

intersection() {
    translate([ear_width, 0, 0]) union() {
        device_bridges();
        splitter_corner_l_ties_local();
        if (unified_roof_layout)
            unified_roof_cross_bridges_local();
    }
    union() {
        viewer_internal_data_cable();
        viewer_input_data_cable();
        viewer_dc_cable();
    }
}
