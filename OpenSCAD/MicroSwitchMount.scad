include <RoundRect.scad>

$fn=50;
inch = 25.4;

topLength = 30.0;
bottomLength = 40.0;
width = 28.0;
height = 6.0;  // A big cutout so that a #3-48 1/2" screw is hidden.
cutout = 4.0;
slotSeparation = 16.0;
smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ. For #6-32 holes
tinyR = 0.112 * inch * 1.05 / 2;   // For #3-48 holes

// slot - A rounded slot framed by two cylinders of diameter w a distance l apart.
//  It is assumed that this is mostly used for subtraction. 
//  The drop makes it extend below the xy plane for robust subtraction.
module slot(l, w, h, drop)
{
    translate([l/2,0,-drop])
        cylinder(r=w/2,h=h+drop);
    translate([-l/2,0,-drop])
        cylinder(r=w/2,h=h+drop);
    translate([0,0,(h-drop)/2])
        cube([l, w, h+drop], center=true);
}

module hole(r, h, drop)
{
    translate([0,0,-drop])
    cylinder(r=r,h=h+drop);
}

difference()
{
    union()
    {
      translate([(bottomLength-topLength)/2,0,0])
      roundRect(topLength,width,height,4,0);
      roundRect(bottomLength,width,height-cutout,4,0);
    }
    translate([(bottomLength-topLength)/2,8,0])
      slot(topLength-10,2*smallR,height+0.2,0.1);
    translate([(bottomLength-topLength)/2,-8,0])
      slot(topLength-10,2*smallR,height+0.2,0.1);
    
    translate([-bottomLength/2+5,5,0])
      hole(tinyR, height+0.2, 0.1);
    translate([-bottomLength/2+5,-5,0])
      hole(tinyR, height+0.2, 0.1);
    
}