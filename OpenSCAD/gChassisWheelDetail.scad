use <gobilda.scad>
use <NexusMecanum.scad>
use <tetrix_holes.scad>
use <TimingBeltPulley.scad>

in = 25.4;
turquoise = [0.25,0.9,0.95];
redish = [0.9,0.3,0.2];
printedPartColor = redish;
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

module pulley24($fn=40)
{
	difference()
	{
		rotate([0,90,0])
		union()
		{
			HtdSimplePulley(24,9,$fn);
			translate([0,0,-21/2])
			  cylinder(r=13/2,h=21);
		}
		GobildaRexShaft(80);
	}
}

module wheelHub(insertDiameter,$fn=30)
{
    adj=0.99;
    ir = insertDiameter/2*adj;
	difference()
	{
		union()
		{
			cylinder(r=13/2,h=9);
			cylinder(r=30,h=4);
			translate([0,0,-5])
			cylinder(r=ir,h=6);
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

WholeAssembly = 1;
Pulley = 2;
Hub1 = 3;
Hub2 = 4;
TestPiece = 5;

toDraw = WholeAssembly;
//toDraw = Pulley;
//toDraw = TestPiece;
//toDraw = Hub1;
//toDraw = Hub2;

if (toDraw == WholeAssembly)
{
    //#SizingBox();

    M = 7;
    N = 9;
    inner = 24*(N+1)/2;

    // Low channels
    translate([inner+12,0,50])
    {
        rotate([90,0,90])
        translate([0,0,6])
        GobildaLowChannel(M,detail);
        rotate([90,0,270])
        translate([0,0,6])
        GobildaLowChannel(M,detail);
    }
    
    // Wheel
    translate([inner+25+6+24+9,-3*24,50])
    rotate([0,0,90])
    mirror([1,0,0])
    NexusMecanum();

    // Axle
    translate([52+inner-6.1,-3*24,50])
    GobildaRexShaft(104);

    // Pillow blocks
    translate([inner,-3*24,50])
    rotate([0,-90,0])
    GobildaFaceThruHolePillowBlock();
    translate([inner+24,-3*24,50])
    rotate([0,90,0])
    GobildaFaceThruHolePillowBlock();

    // Pulley
    color(printedPartColor)
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

    // Hubs
    color(printedPartColor)
    translate(
      [inner+lowChannels+pillowBlock+excess+wheel,-3*24,50])
    rotate([0,90,0])
    {
        wheelHub(18,$fn=30);
    }
    color(printedPartColor)
    translate(
      [inner+lowChannels+pillowBlock+excess,-3*24,50])
    rotate([0,-90,0])
    {
        wheelHub(21.8,$fn=30);
    }
}
else if (toDraw == Pulley)
{
    color(printedPartColor)
    rotate([0,-90,0])
    pulley24($fn=96);
}
else if (toDraw == Hub1)
{
    color(printedPartColor)
    wheelHub(18,$fn=60);
}
else if (toDraw == Hub2)
{
    color(printedPartColor)
    wheelHub(21.8,$fn=60);
}
else if (toDraw == TestPiece)
{
    color(printedPartColor)
    difference()
    {
        cylinder(r=15,h=7,$fn=50);
        rotate([0,90,0])
        GobildaRexShaft(40);
    }
    
}
