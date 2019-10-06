include <tetrix_holes.scad>
include <RevMotionInterface_holes.scad>
include <RoundRect.scad>

$fn = 50;

difference()
{
    union()
    {
        roundRect(64,32,2,4,0);
    }
    
    {
        translate([-16,0,0])
            holes(4);
        translate([16,0,0])
          rotate([0,0,30])
            RevHoles(6);
    }
}