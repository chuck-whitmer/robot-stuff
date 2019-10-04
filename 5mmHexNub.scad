include <tetrix_holes.scad>
include <hexagon.scad>
include <RoundRect.scad>

$fn=50;

width = 20.0;
height = 7.0;
hexWidth = 5.15; // On Prusa, 5.1 is way tight, 5.2 slides easily.

difference()
{
    roundRect(width,width,height,4,0);
    
    rotate([0,0,45])
    littleHoles(4);
    translate([0,0,-.1])
    hexagonalPrism(hexWidth,20);
}
