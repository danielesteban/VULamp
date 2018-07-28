/********** PARAMETRIC VALUES **********/

BOARD = 48;
RADIUS = 60;
HEIGHT = 50;
$fn = 64;

/********** RENDER **********/

color("Yellow") {
  difference() {
    // base
    union() {
      base(RADIUS, 4);
      translate([0, 0, 4])
      base(RADIUS - 2, 2);
    }
    // board
    translate([0, 0, 5])
    cube([BOARD, BOARD, 6], center = true);
  }
  difference() {
    rotate([-16, 0, 0]) {
      // supports
      for (direction = [-1, 1])
      translate([(RADIUS - 16) * direction, 0, 0])
      support(8, HEIGHT, 2, direction);
      // ring
      translate([0, -4, HEIGHT - 8])
      ring(8, 16, RADIUS - 12, 2);
    }
    // cut out bottom
    translate([0, 0, -8])
    base(RADIUS + 20, 8);
  }
  // board holders
  for (i = [-1,1])
  translate([BOARD / 2 * i, 0, 6])
  scale([1, 1, 0.5])
  rotate([90, 0, 0])
  cylinder(r = 2, h = 8, center = true);
  // cover
  translate([0, 0, 6])
  cover((BOARD / 2) + 16, 2);
  // wire holder
  translate([0, RADIUS * 0.7, 6])
  rotate([90, 0, 0])
  difference() {
    cylinder(r = 6, h = 4, center = true);
    cylinder(r = 4, h = 6, center = true);
  }
}

/********** MODULES **********/

module base(radius, height) {
  translate([0, 0, height * 0.5])
  cylinder(r = radius, h = height, center = true);
}

module support(size, height, wall, direction) {
  translate([size * 0.5 * direction, 0, height * 0.5])
  difference() {
    // Shell
    cube([size + wall * 2, size + wall * 2, height + wall * 2], center = true);
    // Make it hollow
    cube([size, size, height], center = true);
    // Cut side window
    translate([wall * -direction, 0, 0])
    cube([size + wall * 2, size, height], center = true);
    // led strip window
    translate([0, size * -1 + wall * 2, height * 0.5 - size])
    cube([size, size + wall * 2, size * 2], center = true);
  }
}

module ring(width, height, radius, wall) {
  difference() {
    rotate_extrude()
    translate([radius, 0, 0])
    square([width + wall * 2, height + wall * 2], center = true);
    rotate_extrude()
    translate([radius, 0, 0])
    square([width, height], center = true);
    translate([0, radius, 0])
    cube([radius * 3, radius * 2, radius * 2], center = true);
  }
}

module cover(radius, wall) {
  scale([1, 1, 0.7])
  difference() {
    // Shell
    sphere(r = radius);
    // Hollow it
    sphere(r = radius - wall);
    // Cut bottom
    translate([0, 0, radius * -1])
    cube([radius * 2, radius * 2, radius * 2], center = true);
    // Wires
    translate([0, radius * 0.1, radius * 0.25])
    rotate([0, 90, 0])
    cylinder(r = radius * 0.1, h = radius * 2, center = true);
    // Vents
    translate([0, 0, radius * 0.2]) {
      for (i = [1.65, -1.85])
      translate([0, radius * i, 0])
      rotate([90, 0, 0])
      scale([0.8, 1, 1])
      cylinder(r = radius, h = radius * 2, center = true);
    }
  }
}
