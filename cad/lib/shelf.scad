// Print Area: 280 mm x 280 mm x 250 mm (11.02 in x 11.02 in x 9.8 in)
// 
// screw to screw: 463
// sts horiz: 30

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

// latches
latch_hei = 10;
latch_dia = 3;
latch_outter_dia = latch_dia + 3;

padding = 1;

module block(x,y) {
  polygon([
    [-x/2, -y/2],
    [-x/2, y/2],
    [x/2, y/2],
    [x/2, -y/2],
  ]);
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

module latch(ty) {
  tx = wid/2;
  tz = body_platform + latch_dia/2;
  difference() {
    translate([tx,ty,tz])
      rotate([90,,])
        cylinder($fn = 64, h=latch_hei,d=latch_outter_dia,center=true);

    translate([tx,ty,tz])
      rotate([90,,])
        cylinder($fn = 64, h=latch_hei+0.1,d=latch_dia,center=true);
  }
}

module latches(os) {
  latch(0+os);
  latch(body_dep/4+os);
  latch(-body_dep/4+os);
}

module indent(ty, convex) {
  l = 10;
  w = 3;
  d = 3;
  tx = wid/2-d*convex;
  tz = body_platform/2;
  translate([tx,ty,tz])
    rotate([0,90,0])
      linear_extrude(d)
        block(w,l);
}

module indents(concave) {
      indent(body_dep/8, concave);
      indent(-body_dep/8, concave);
}

module shelf_block() {
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
}
