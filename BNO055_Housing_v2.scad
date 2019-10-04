$fn = 50;
include <tetrix_holes.scad>


difference()
{
    import("BNO055_Housing_v1.stl");
    translate([-4,0,0])
    union()
    {
        translate([16,0,0])
        rotate([0,0,-90])
            littleHoles(1);
        translate([-16,0,0])
            littleHoles(2);
    }
}
height = 3;
translate([23,12,-height])
cylinder(r1=3,r2=3,h=height);
translate([-23,12,-height])
cylinder(r1=3,r2=3,h=height);
translate([23,-12,-height])
cylinder(r1=3,r2=3,h=height);
translate([-23,-12,-height])
cylinder(r1=3,r2=3,h=height);