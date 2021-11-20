use <gobilda.scad>
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

module armPully($fn=40)
{
    fn = $fn;
    drillList=[[8,8],[8,-8],[-8,-8],[-8,8]];
	difference()
	{
		HtdSimplePulley(29,6,fn);
		rotate([0,90,0])
        scale(1.02)          // As demonstrated by printing PETG on Prusa.
		GobildaRexShaft(80);
        translate([0,0,-10])
        linear_extrude(20,convexity=10)
        for(pos=drillList)
        {
            translate(pos)
            circle(r=2.1);
        }
	}
}

module motorPully($fn=40)
{
    fn = $fn;
    drillList=[[0,8],[0,-8],[-8,0],[8,0]];
	difference()
	{
		HtdSimplePulley(29,6,fn);
        scale(1.02)          // As demonstrated by printing PETG on Prusa.
		translate([0,0,-10])
        cylinder(r=4,h=20);
        translate([0,0,-10])
        linear_extrude(20,convexity=10)
        for(pos=drillList)
        {
            translate(pos)
            circle(r=1.9);
        }
	}
}

//armPully(100);
motorPully(100);