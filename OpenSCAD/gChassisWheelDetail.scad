use <gobilda.scad>
use <NexusMecanum.scad>
use <tetrix_holes.scad>
use <TimingBeltPulley.scad>

in = 25.4;
turquoise = [0.25,0.9,0.95];
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

module pulley24()
{
	difference()
	{
		rotate([0,90,0])
		union()
		{
			HtdSimplePulley(24,9);
			translate([0,0,-21/2])
			  cylinder(r=13/2,h=21);
		}
		GobildaRexShaft(80);
	}
}

module wheelHub()
{
	difference()
	{
		union()
		{
			cylinder(r=13/2,h=9);
			cylinder(r=30,h=4);
			translate([0,0,-5])
			cylinder(r=17/2,h=6);
		}
		for (theta=[60,180,300])
		{
			rr = 38;
			translate([rr*sin(theta),rr*cos(theta),-0.1])
			cylinder(r=20.5,h=10);
		}
		for (theta=[0,120,240])
		{
			rr = 47.5/2;
			translate([rr*sin(theta),rr*cos(theta),-0.1])
			cylinder(r=2.5,h=10);
		}
		rotate([0,90,0])
		GobildaRexShaft(80);
	}
}

//#SizingBox();

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
translate([inner+25+6+24+9,-3*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();

translate([52+inner-6.1,-3*24,50])
GobildaRexShaft(104);

translate([inner,-3*24,50])
rotate([0,-90,0])
GobildaFaceThruHolePillowBlock();
translate([inner+24,-3*24,50])
rotate([0,90,0])
GobildaFaceThruHolePillowBlock();

color(turquoise)
translate([inner+12,-3*24,50])
{
	pulley24();
}

axle = 104;
pillowBlock = 6;
lowChannels = 24;
wheel = 50;

// Do the math on the wheel hubs.
excess = (axle - 2*pillowBlock - lowChannels - wheel)/2;
echo("Excess axle ",excess," on each end");

color(turquoise)
translate(
  [inner+lowChannels+pillowBlock+excess+wheel,-3*24,50])
rotate([0,90,0])
{
	wheelHub();
}
color(turquoise)
translate(
  [inner+lowChannels+pillowBlock+excess,-3*24,50])
rotate([0,-90,0])
{
	wheelHub();
}




//translate([0,0,50+24+16])
//rotate([180,0,180])
//TetrixChannel(416);

