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

translate([0,0,90])
TetrixChannel(416);

translate([12+240/2,0,50])
{
    rotate([90,0,90])
    translate([0,0,6])
    GobildaLowChannel(15,detail);
    rotate([90,0,270])
    translate([0,0,6])
    GobildaLowChannel(15,detail);
}
translate([-(12+240/2),0,50])
{
    rotate([90,0,90])
    translate([0,0,6])
    GobildaLowChannel(15,detail);
    rotate([90,0,270])
    translate([0,0,6])
    GobildaLowChannel(15,detail);
}
translate([240/2+24+30+6,7*24,50])
rotate([0,0,90])
NexusMecanum();
translate([240/2+24+30+6,-7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();
translate([-(240/2+24+30+6),7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();
translate([-(240/2+24+30+6),-7*24,50])
rotate([0,0,90])
NexusMecanum();

translate([0,24,50])
GobildaChannel(9,detail);
translate([0,96,50])
GobildaChannel(9,detail);