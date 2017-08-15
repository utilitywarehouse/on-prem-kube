include <lib/shelf.scad>

right_shelf();
left_shelf();

// wedges
translate([wid/2, 0, body_platform+20])
  wedge();
translate([wid/2, dep/4, body_platform+20])
  wedge();
translate([wid/2, -dep/4, body_platform+20])
  wedge();
