$fn = 50;
include <tetrix_holes.scad>

h1 = 2;
h2 = 5.6;

module spline(diameter,teeth,h)
{
    dTheta = 360/(2*teeth);
    rr = diameter/2 * [1 , 1-3.14/teeth];
    poly = [for (i=[0:2*teeth-1]) rr[i%2]*[cos(i*dTheta),sin(i*dTheta)]];
    linear_extrude(h,convexity=10)
    polygon(poly);
}


difference()
{
    union()
    {
        cylinder(r=8.6/2,h=h2);
        cylinder(r=14,h=h1);
    }
    // The spline!
    translate([0,0,1.9])
    spline(5.95,25,4); // 5.77 to 5.90 tight. (Last nearly usable.)
    // Horn screw hole.
    translate([0,0,-0.1])
    cylinder(r=3.7/2,h=4);
    // Tetrix mounting.
    littleHoles(2);
}


