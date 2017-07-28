include <shelf.scad>

ridge_len = 0.2;
bolt_len = latch_hei*2 + ridge_len;

module bolt_shaft() {
  rotate([90,,])
    cylinder($fn = 64, h=bolt_len,d=latch_dia-0.1,center=true);
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

module ridge() {
  lip_size = 0.2;
  translate([0,-latch_hei-ridge_len,0])
    scale([1,1,1-lip_size/2])
      rotate([90,,])
        cylinder($fn = 64, h=0.2,d=latch_dia+lip_size,,center=true);
}

module cut() {
  translate([0,-latch_hei-ridge_len,-2])
    linear_extrude(4)
      block(latch_dia/4, latch_dia*2);
}

module bolt() {
  difference() {
    union() {
      bolt_shaft();
      bolt_top();
      ridge();
    }
    cut();
  }
}
