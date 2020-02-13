use <gobilda.scad>
use <NexusMecanum.scad>
use <TimingBeltPulley.scad>
use <tetrix_holes.scad>

in = 25.4;
detail = false;
turquoise = [0.25,0.9,0.95];
redish = [0.9,0.3,0.2];
printedPartColor = redish;

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
			translate([0,0,-25/2])
			  cylinder(r=13/2+0.2,h=25);
		}
        scale(1.02)          // As demonstrated by printing PETG on Prusa.
		GobildaRexShaft(80);
	}
}

module wheelHub(insertDiameter,$fn=30)
{
    adj=1.02;
    ir = insertDiameter/2/adj;
	difference()
	{
		union()
		{
			cylinder(r=13/2+0.2,h=9);
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
        scale(adj)
		GobildaRexShaft(80);
	}
}

module dualBlockShim()
{
    linear_extrude(2.5,convexity=3)
    difference()
    {
        square([38,12]);
        translate([3,4])
        circle(2,$fn=40);
        translate([35,4])
        circle(2,$fn=40);
    }
}

module axleAssembly()
{
    translate([-52,0,0])
    GobildaRexShaft(104);
    translate([-6,0,0])
    rotate([0,90,0])
    GobildaFaceThruHolePillowBlock();
    translate([-30,0,0])
    rotate([0,-90,0])
    GobildaFaceThruHolePillowBlock();
    color(printedPartColor)
    {
    translate([-18,0,0])
    pulley24($fn=20);
    translate([-(9+12+24),0,0])
    rotate([0,90,0])
    wheelHub(18);
    translate([-(12+24+50+9),0,0])
    rotate([0,-90,0])
    wheelHub(21.8);
    }
}

wholeAssembly = 1;
shim = 2;

//toDraw = shim;
toDraw = wholeAssembly;

if (toDraw == wholeAssembly)
{


//#SizingBox();

//translate([0,0,90])
//TetrixChannel(416);

// Low Channels
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

// Wheels
wheelOffsetX = 240/2+24+30+9;
translate([wheelOffsetX,7*24,50])
rotate([0,60,90])
NexusMecanum();
translate([wheelOffsetX,-7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();
translate([-wheelOffsetX,7*24,50])
rotate([0,0,90])
mirror([1,0,0])
NexusMecanum();
translate([-wheelOffsetX,-7*24,50])
rotate([0,60,90])
NexusMecanum();

// Cross Beams
translate([0,24,50])
GobildaChannel(9,detail);
translate([0,96,50])
GobildaChannel(9,detail);

// Axles
translate([-5*24+6,-7*24,50])
    axleAssembly();
translate([-5*24+6,7*24,50])
    axleAssembly();
translate([5*24-6,7*24,50])
rotate([0,180,0])
    axleAssembly();
translate([5*24-6,-7*24,50])
rotate([0,180,0])
    axleAssembly();
    
translate([-120,0,50])
rotate([90,90,0])
GobildaCornerPatternMount();    
translate([120,0,50])
rotate([90,-90,0])
GobildaCornerPatternMount();    
}
else if (toDraw == shim)
{
    dualBlockShim();
}