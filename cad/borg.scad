include <lib/shelf.scad>
include <lib/bolts.scad>

latch_hei = 10;

// 1
difference() {
  union() {
    shelf_block();
    latches(latch_hei/2);
  }
  latches(-latch_hei/2);
  indents(1);
}

// 2
translate([wid+10,0,0]) mirror([1,0,0])
  difference() {
    union() {
      shelf_block();
      latches(-latch_hei/2);
      indents(0);
    }
    latches(latch_hei/2);
  }

translate([wid/2+5,dep/4,20])
  bolt();
translate([wid/2+5,0,20])
  bolt();
translate([wid/2+5,-dep/4,20])
  bolt();
