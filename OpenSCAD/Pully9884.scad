use <gobilda.scad>
use <TimingBeltPulley.scad>
use <Tetrix.scad>
use <Rev.scad>

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

armPully(100);
//motorPully(100);