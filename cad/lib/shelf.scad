// Print Area: 280 mm x 280 mm x 250 mm (11.02 in x 11.02 in x 9.8 in)
// 
// screw to screw: 463
// sts horiz: 30

include <mounts.scad>

rack_wid = 225;
dep=270;
hei=45;

// mount lip
lip_wid_back=18;
lip_dep_pos=6;
lip_dep=dep-lip_dep_pos;
lip_guard=6.5;

// screw holes
dia=6;
bot_pos=3;
sep_dist=30;
screw_hei=lip_dep_pos+0.1; // figure out why we need this 0.1

// shelf body
wid = rack_wid + lip_wid_back;

// body
body_platform=6.5;
body_wid=wid-lip_wid_back-lip_guard;
body_dep=dep;

// vents
vent_wid=55;
vent_hei=14;

shelves_sep_dist = 20;
mobo_wid = 243;
mobo_dep = 306;
mobo_edge_trans = -wid/2 + lip_wid_back + 15;
right_mobo_edge_trans = (lip_wid_back + 15 + mobo_wid) - wid;

psu_wid = 150;
psu_dep = 140;
psu_len = 85;

internal_rack_len = 450;

padding = 1;

module block(x,y) {
  polygon([
    [-x/2, -y/2],
    [-x/2, y/2],
    [x/2, y/2],
    [x/2, -y/2],
  ]);
}

module arch(x) {
  difference() {
    linear_extrude(5)
      block(x, 20);
    translate([0, 5, 1])
      rotate([0,90,0])
        cylinder($fn = 32, h=x+2,d=5,center=true);
    translate([0, -5, 1])
      rotate([0,90,0])
        cylinder($fn = 32, h=x+2,d=5,center=true);
    linear_extrude()
      block(x+2, 10);
  }
}

module wedge() {
  difference() {
    linear_extrude(5)
      block(20, 20);
    arch(20);
    // cut the bottom to allow fit
    linear_extrude(0.2)
      block(20, 20);
  }
}

module screw_hole(sd) {
  tx = -wid/2+lip_wid_back/2;
  ty = dep/2-lip_dep_pos/2;
  tz = bot_pos+dia/2+sd;
  translate([tx,ty,tz])
    rotate([90,,])
      cylinder($fn = 24, h=screw_hei,d=dia,center=true);
}

module vent(x,y) {
  translate([-body_wid/x,body_dep/y,0])
    linear_extrude()
      block(vent_wid, vent_hei);
}

module shelf_block() {
  union() {
    difference() {
      // whole shelf
      linear_extrude(hei)
        block(wid,dep);

      // lip
      linear_extrude()
        translate([-wid/2+lip_wid_back/2,-lip_dep_pos/2,],0)
          block(lip_wid_back+padding, lip_dep+padding);

      // arm gradient
      translate([-wid/2,lip_dep/2-lip_dep_pos/2,hei])
        rotate([180,-90,0])
          linear_extrude()
            polygon([
              [0, 0],
              [padding, 0],
              [padding, lip_dep + padding],
              [0, lip_dep + padding],
              [-hei+body_platform, lip_dep],
            ]);

      // screw holes
      screw_hole(sd=0);
      screw_hole(sd=sep_dist);

      // body
      translate([(lip_wid_back+lip_guard)/2,dep/2-body_dep/2,body_platform])
        linear_extrude()
          block(body_wid+padding, body_dep+100);

      // vents
      vent(4,6);
      vent(4,3);
      vent(4,-3);
      vent(4,-6);

      vent(-4,6);
      vent(-4,3);
      vent(-4,-3);
      vent(-4,-6);
    }
    // arches
    translate([wid/2-5, 0, body_platform])
      arch(10);
    translate([wid/2-5, dep/4, body_platform])
      arch(10);
    translate([wid/2-5, -dep/4, body_platform])
      arch(10);
  }
}

module right_shelf() {
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
}

module left_shelf() {
  translate([wid+shelves_sep_dist,0,0]) mirror([1,0,0])
    union() {
      shelf_block();
      translate([mobo_edge_trans, dep/2-10, body_platform+mount_platform_height])
        rotate([0,0,-90])
          left_mobo_mount();
      // rear mount
      translate([0, -dep/2+5, body_platform])
        linear_extrude(mount_platform_height)
          block(20, 10);
    }
}
