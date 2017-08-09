thickness = 5;
heigth = 20;
length = 28;
mount_platform_height = 5; 

module mount() {
  union() {
    translate([0,0,-mount_platform_height])
      linear_extrude(mount_platform_height)
        polygon([
          [0,-5],
          [length,-5],
          [length,0],
          [0,length],
          [-5,length],
          [-5,0],
        ]);
    translate([0,-thickness,0])
      rotate([-90,-90,0])
        linear_extrude(thickness)
          polygon([
            [0,0],
            [heigth,0],
            [0, length],
          ]);
    translate([0,0,0])
      rotate([0,-90,0])
        linear_extrude(thickness)
          polygon([
            [0,0],
            [heigth,0],
            [0, length],
          ]);
    linear_extrude(heigth)
      polygon([
        [0,-5],
        [0,0],
        [-5,0],
      ]);
  }
}

module mobo_mount(dep) {
  wid = 17;
  union() {
    mount();
    translate([wid,dep,thickness])
      cylinder($fn = 32, h=10,d=3,center=true);
    translate([wid,dep,thickness/2])
      cylinder($fn = 32, h=5, d=9, d2=6, center=true);
    translate([wid,dep,-thickness/2])
      cylinder($fn = 32, h=5, d=9, center=true);
  }
}

module left_mobo_mount() {
  dep = 11;
  mobo_mount(dep);
}

module right_mobo_mount() {
  dep = 7;
  mobo_mount(dep);
}
