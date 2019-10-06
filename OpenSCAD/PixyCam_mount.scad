$fn = 50;
include <tetrix_holes.scad>

inch = 25.4;
postHeight = 0.75*inch + 3.0;;

module post(height)
{
    difference()
    {
        cylinder(r=0.125*inch,h=height);
        translate([0,0,2])
        cylinder(r=1.2,h=height);
    }
}
    
//import("Pixy_cover.stl");

difference()
{
    union()
    {
        translate([-(2.120/2-0.125)*inch,(2.000/2-0.125)*inch,0])
        post(postHeight);
        translate([(2.120/2-0.125)*inch,(2.000/2-0.125)*inch,0])
        post(postHeight);
        translate([-(2.120/2-0.125)*inch,-(2.000/2-0.570)*inch,0])
        post(postHeight);
        translate([-(2.120/2-0.650)*inch,-(2.000/2-0.125)*inch,0])
        post(postHeight);
        translate([(2.120/2-0.650)*inch,-(2.000/2-0.125)*inch,0])
        post(postHeight);
        
        translate([-2.120/2*inch,-(2.000/2-0.570)*inch,0])
        cube([2,((2.000/2-0.125)+(2.000/2-0.570))*inch,postHeight]);
        
        translate([2.120/2*inch-2,-(2.000/2-0.570)*inch,0])
        cube([2,((2.000/2-0.125)+(2.000/2-0.570))*inch,postHeight]);
        
        translate([-(2.120-2*0.650)/2*inch,-(2.000/2)*inch,0])
        cube([(2.120-2*0.650)*inch,2,postHeight]);
        
        translate([-2.120/2*inch+3,-2.0*inch/2+3,0])
        minkowski()
        {
        cube([2.120*inch-6,2.0*inch-6,1]);
            cylinder(r=3,h=1);
        }
    }
    littleHoles(4);
        
        translate([-(2.120/2-0.125)*inch+1.3,1.0*inch-10,postHeight-0.6*inch+0.1])
        cube([0.125*inch-1.0,10,0.7*inch]);
}