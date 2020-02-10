use <gobilda.scad>
use <NexusMecanum.scad>
use <tetrix_holes.scad>

in = 25.4;
detail = false;

module SizingBox()
{
    outerSize = 18.25*in;
    difference()
    {
        translate([-outerSize/2,-outerSize/2,0])
        cube([outerSize,outerSize,6*in]);
        translate([-9*in,-9*in,-0.1])
        cube([18*in,18*in,18*in]);
    }
}

#SizingBox();

M = 7;
N = 9;
inner = 24*(N+1)/2;


translate([inner+12,0,50])
{
    rotate([90,0,90])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
    rotate([90,0,270])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
}
translate([inner+30+6+24+5,-3*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();

translate([52+inner-6,-3*24,50])
GobildaRexShaft(104);

//translate([0,0,50+24+16])
//rotate([180,0,180])
//TetrixChannel(416);

