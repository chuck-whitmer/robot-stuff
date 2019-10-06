$fn = 50;
include <tetrix_holes.scad>

inch = 25.4;
postHeight = 16;

module post(height)
{
    difference()
    {
        cylinder(r=3,h=height);
        translate([0,0,2])
        cylinder(r=1.5,h=height);
    }
}
    
difference()
{
    union()
    {
        translate([0.6*inch,0.5*inch,0])
        post(postHeight);
        translate([-0.6*inch,0.5*inch,0])
        post(postHeight);
        translate([0.6*inch,-0.5*inch,0])
        post(postHeight);
        translate([-0.6*inch,-0.5*inch,0])
        post(postHeight);
        translate([0,0,1.5])
        {
            cube([1.2*inch+6,1.0*inch,3],center=true);
            cube([1.2*inch,1.0*inch+6,3],center=true);
        }
    }
    littleHoles(4);
}