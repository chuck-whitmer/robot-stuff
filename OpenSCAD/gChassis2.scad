use <gobilda.scad>
use <NexusMecanum.scad>

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

//#SizingBox();

M = 17;
N = 15;
leftInner = -24*(N+1)/2;


translate([leftInner-12,0,50])
{
    rotate([90,0,90])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
    rotate([90,0,270])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
}
translate([-(leftInner-12),0,50])
{
    rotate([90,0,90])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
    rotate([90,0,270])
    translate([0,0,6])
    GobildaLowChannel(M,detail);
}
translate([leftInner+30+6,7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();
translate([leftInner+30+6,-7*24,50])
rotate([0,0,90])
NexusMecanum();
translate([-(leftInner+30+6),7*24,50])
rotate([0,0,90])
NexusMecanum();
translate([-(leftInner+30+6),-7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();

translate([0,24,50])
GobildaChannel(N,detail);
translate([0,72,50])
GobildaChannel(N,detail);