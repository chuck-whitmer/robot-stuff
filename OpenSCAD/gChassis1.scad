use <gobilda.scad>
use <NexusMecanum.scad>
use <TimingBeltPulley.scad>
use <Tetrix.scad>
use <Rev.scad>

in = 25.4;
detail = true;
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
    ir = insertDiameter/2;
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
        translate([-19,0])
    difference()
    {
        square([38,12]);
        translate([3,8])
        circle(2,$fn=40);
        translate([35,8])
        circle(2,$fn=40);
    }
}

module shimmedBlockMount()
{
    rotate([0,90,0])
    {
        translate([0,2.5,0])
        GobildaDualBlockMount();
        color(printedPartColor)
        translate([0,2.5,0])
        rotate([90,0,0])
        dualBlockShim();
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
wheelHubOnly = 3;

//toDraw = shim;
//toDraw = wholeAssembly;
toDraw = wheelHubOnly;
addOns = true;

if (toDraw == wholeAssembly)
{


    #SizingBox();

    //translate([0,0,90])
    //TetrixChannel(416);

    // Low Channels
    translate([12+240/2,0,50])
    {
        rotate([90,0,90])
        translate([0,0,6])
        GobildaLowChannel(15,detail); // left outer
        rotate([90,0,270])
        translate([0,0,6])
        GobildaLowChannel(15,detail);  // left inner
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
    NexusMecanum();  // left rear
    translate([wheelOffsetX,-7*24,50])
    rotate([0,0,90])
    mirror([1,0,0])
    NexusMecanum();  // left front
    translate([-wheelOffsetX,7*24,50])
    rotate([0,0,90])
    mirror([1,0,0])
    NexusMecanum();  // right rear
    translate([-wheelOffsetX,-7*24,50])
    rotate([0,60,90])
    NexusMecanum();  // right front

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
    
    // Corner Mounts
    translate([-120,0,50])
    rotate([90,90,0])
    GobildaCornerPatternMount();    
    translate([120,0,50])
    rotate([90,-90,0])
    GobildaCornerPatternMount();    
    
    // Block Mounts
    translate([-120,48,50])
    shimmedBlockMount();
    translate([-120,48+72,50])
    shimmedBlockMount();
    translate([-120,72,50])
    mirror([0,1,0])
    shimmedBlockMount();
    mirror([1,0,0])
    {
    translate([-120,48,50])
    shimmedBlockMount();
    translate([-120,48+72,50])
    shimmedBlockMount();
    translate([-120,72,50])
    mirror([0,1,0])
    shimmedBlockMount();
    }
    
    // Motors
    translate([120,24,50])
    GobildaMotor435();
    translate([120,96,50])
    GobildaMotor435();
    mirror([1,0,0])
    {
    translate([120,24,50])
    GobildaMotor435();
    translate([120,96,50])
    GobildaMotor435();
    }
    
    // Drive pullies
    translate([132,24,50])
    rotate([0,90,0])
    HtdSimplePulley(16,9);
    translate([132,96,50])
    rotate([0,90,0])
    HtdSimplePulley(16,9);
    mirror([1,0,0])
    {
    translate([132,24,50])
    rotate([0,90,0])
    HtdSimplePulley(16,9);
    translate([132,96,50])
    rotate([0,90,0])
    HtdSimplePulley(16,9);
    }
    
    // Timing Belt
    translate([132,0,50])
    {
		rotate([0,90,0])
		HtdTimingBelt(24,0,-7*24,16,0,24,9);
		rotate([0,90,0])
		HtdTimingBelt(16,0,96,24,0,168,9);
    }
    mirror([1,0,0])
    {
		translate([132,0,50])
		{
			rotate([0,90,0])
			HtdTimingBelt(24,0,-7*24,16,0,24,9);
			rotate([0,90,0])
			HtdTimingBelt(16,0,96,24,0,168,9);
		}
    }    
	if (addOns)
	{
//		translate([48,6*24,68])
//		GobildaLowChannel(3,detail);
		translate([0,136,66])
		GobildaSquareBeam(29);
		translate([-29*4,136,66])
		rotate([0,-90,0])
		GobildaSpacer(6,4);
		translate([29*4,136,66])
		rotate([0,90,0])
		GobildaSpacer(6,4);
		translate([16,136,70])
		GobildaSpacer(6,4);
		translate([16+88,136,70])
		GobildaSpacer(6,4);
		hubStandoff = 24;
		translate([16,136,70+4+13])
		GobildaSpacer(6,hubStandoff);
		translate([16+88,136,70+4+13])
		GobildaSpacer(6,hubStandoff);
		translate([16,8,70+4+13])
		GobildaSpacer(6,hubStandoff);
		translate([16+88,8,70+4+13])
		GobildaSpacer(6,hubStandoff);
		for (tx=[[128,128,74],[128,-128,74]])
		translate(tx)
		{
			TetrixInternalCConnector();
			translate([0,0,48])
			rotate([0,90,180])
			TetrixChannel(96,detail);
		}
		for (tx=[[-128,128,74],[-128,-128,74]])
		translate(tx)
		{
			TetrixInternalCConnector();
			translate([0,0,48])
			rotate([0,90,0])
			TetrixChannel(96,detail);
		}
		translate([128,0,186])
		rotate([-90,0,90])
		TetrixChannel(288,detail);
		translate([-128,0,186])
		rotate([90,0,90])
		TetrixChannel(288,detail);
		translate([0,4*32,186])
		TetrixChannel(288-64,detail);
		
		translate([88/2+16,128/2+8,50+24])
		rotate([0,0,90])
		RevExpansionHub();
		translate([88/2+16,128/2+8,50+24+hubStandoff+13])
		rotate([0,0,90])
		RevExpansionHub();
	}
	
}
else if (toDraw == shim)
{
    dualBlockShim();
}
else if (toDraw == wheelHubOnly)
{
    wheelHub(21.8,$fn=60);
}
