in = 25.4;
$fn = 50;

use <tetrix_holes.scad>

thickness = 0.18*in;

difference()
{
linear_extrude(thickness)
    offset(2)
    square([56,24],center=true);
    translate([16,0])
    littleHoles(2);
    translate([-16,0])
    littleHoles(2);
}