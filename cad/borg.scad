include <lib/shelf.scad>
include <lib/mounts.scad>

latch_hei = 10;
shelves_sep_dist = 20;
mobo_wid = 243;
mobo_dep = 306;
mobo_edge_trans = -wid/2 + lip_wid_back + 15;
right_mobo_edge_trans = (lip_wid_back + 15 + mobo_wid) - wid;

psu_wid = 150;
psu_dep = 140;
psu_len = 85;

internal_rack_len = 450;

module right_shelf() {
  difference() {
    union() {
      shelf_block();
      translate([wid/2-right_mobo_edge_trans, dep/2-10, body_platform+mount_platform_height])
        rotate([0,0,-90])
          right_mobo_mount();
      // PSU mounts
      translate([psu_wid/2, dep/2-10, body_platform+mount_platform_height])
        rotate([0,0,180])
          mount();
      translate([-psu_wid/2, dep/2-10, body_platform+mount_platform_height])
        rotate([0,0,-90])
          mount();
      translate([psu_wid/2, dep/2-10-psu_dep, body_platform+mount_platform_height])
        rotate([0,0,90])
          mount();
      translate([-psu_wid/2, dep/2-10-psu_dep, body_platform+mount_platform_height])
        rotate([0,0,0])
          mount();
    }
    indents(1);
  }
}

module left_shelf() {
  translate([wid+shelves_sep_dist,0,0]) mirror([1,0,0])
    difference() {
      union() {
        shelf_block();
        indents(0);
        translate([mobo_edge_trans, dep/2-10, body_platform+mount_platform_height])
          rotate([0,0,-90])
            left_mobo_mount();
        // rear mount
        translate([0, -dep/2+5, body_platform])
          linear_extrude(mount_platform_height)
            block(20, 10);
      }
    }
}

right_shelf();
left_shelf();
