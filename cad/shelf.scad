// obj
wid=227.62;
dep=114.30;
hei=44.45;

// mount lip
lip_wid_back=18;
lip_dep_pos=6;
lip_dep=dep-lip_dep_pos;
lip_guard=6.5;
lip_decline_dep=25;

// screw holes
dia=6;
bot_pos=3;
sep_dist=32;
screw_hei=lip_dep_pos+0.1; // figure out why we need this 0.1

// body
body_platform=6.5;
body_wid=wid-lip_wid_back-lip_guard;
body_dep=dep;
body_hei=hei-body_platform;

// vents
vent_wid=55;
vent_hei=14;

module screw_hole(sd) {
  translate([-wid/2+lip_wid_back/2,dep/2-lip_dep_pos/2,bot_pos+dia/2+sd])
    rotate([90,,])
      cylinder($fn = 24, h=screw_hei,d=dia,center=true);
}

module vent(x,y) {
  translate([-body_wid/x,body_dep/y,0])
    linear_extrude(body_platform)
      polygon([
        [-vent_wid/2, -vent_hei/2],
        [-vent_wid/2, vent_hei/2],
        [vent_wid/2, vent_hei/2],
        [vent_wid/2, -vent_hei/2],
      ]);
}

difference() {
  // whole shelf
  linear_extrude(hei)
    polygon([
      [-wid/2, -dep/2],
      [-wid/2, dep/2],
      [wid/2, dep/2],
      [wid/2, -dep/2],
    ]);
  
  // lip
  linear_extrude(hei)
    translate([-wid/2+lip_wid_back/2,-lip_dep_pos/2,0])
      polygon([
        [-lip_wid_back/2, -lip_dep/2],
        [-lip_wid_back/2, lip_dep/2],
        [lip_wid_back/2, lip_dep/2],
        [lip_wid_back/2, -lip_dep/2],
      ]);

  // screw holes
  screw_hole(sd=0);
  screw_hole(sd=sep_dist);

  // body
  translate([(lip_wid_back+lip_guard)/2,dep/2-body_dep/2,body_platform])
    linear_extrude(body_hei)
      polygon([
        [-body_wid/2, -body_dep/2],
        [-body_wid/2, body_dep/2],
        [body_wid/2, body_dep/2],
        [body_wid/2, -body_dep/2],
      ]);

  // arm gradient
  translate([-wid/2+lip_guard+lip_wid_back+0.1,-dep/2,hei])
    rotate([-90,0,90])
      linear_extrude(lip_guard+0.1)
        polygon([
          [0,0],
          [body_dep - lip_decline_dep,0],
          [0, hei - body_platform],
        ]);

  // vents
  vent(4,4);
  vent(4,body_dep);
  vent(4,-4);
  vent(-4,4);
  vent(-4,body_dep);
  vent(-4,-4);
}

