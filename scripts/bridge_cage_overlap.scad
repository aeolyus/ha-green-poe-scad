// Regression fixture: the lower box bridges must overlap both rounded cage
// floors by real volume so a production export cannot contain loose shells.

include <../ha_green_rack.scad>

intersection() {
    device_bridges();
    retention_ventilated_sleeves_local();
}
