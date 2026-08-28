// Validation helper: any exported geometry is a collision between a dovetail
// gate and its cage at the requested vertical insertion offset.
//
// Example:
//   openscad -o /tmp/collision.stl \
//     -D 'part="__validation_only__"' \
//     -D 'test_device="green"' -D 'slide_lift=5' \
//     scripts/dovetail_slide_collision.scad

include <../ha_green_rack.scad>

test_device = is_undef(test_device) ? "green" : test_device;
slide_lift = is_undef(slide_lift) ? 0 : slide_lift;
test_target = is_undef(test_target) ? "cage" : test_target;

if (test_device == "green" && test_target == "cage") {
    intersection() {
        green_dovetail_cage_local();
        translate([0, 0, slide_lift])
            green_dovetail_gate_local();
    }
} else if (test_device == "splitter" && test_target == "cage") {
    intersection() {
        splitter_dovetail_cage_local();
        translate([0, 0, slide_lift])
            splitter_dovetail_gate_local();
    }
} else if (test_device == "green" && test_target == "ports") {
    intersection() {
        viewer_green_ports(false);
        translate([0, 0, slide_lift])
            green_dovetail_gate_local();
    }
} else if (test_device == "splitter" && test_target == "ports") {
    intersection() {
        viewer_splitter_ports(false);
        splitter_transform()
            translate([0, 0, slide_lift])
                splitter_dovetail_gate_local();
    }
}
