include <shelf.scad>

module bolt_shaft() {
  rotate([90,,])
    cylinder($fn = 64, h=latch_hei*2,d=latch_dia-0.1,center=true);
}

module bolt_top() {
  length = 3;
  translate([0,latch_hei+length/2,0])
    rotate([90,,])
      difference() {
        cylinder($fn = 64, h=length,d=latch_outter_dia,d2=latch_outter_dia/1.3,center=true);
        y=latch_outter_dia/2-latch_dia/2;
        translate([0,-latch_dia/2-y/2,-y])
          linear_extrude(length)
            block(latch_outter_dia, latch_outter_dia/2-latch_dia/2);
      }
}

module bolt() {
  bolt_shaft();
  bolt_top();
}
