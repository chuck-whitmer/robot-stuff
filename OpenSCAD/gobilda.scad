$fn = 20;

brightSilver=0.9*[1,1,1];

module gbLittleHolesFlat()
{
    d1 = 12*sqrt(2)/2;
    d2 = 16*sqrt(2)/2;
    drillList = [
      [8,8],[8,16],[8,32],[8,40],
      [16,8],[16,16],[16,32],[16,40],
      [24-d1,24+d1],[24-d1,24-d1],
      [d1,24+d1],[d1,24-d1],
      [12,24],[24-d2,24],[d2,24]
    ];
    for (i=drillList)
    {
        translate([i[0],i[1]])
        circle(r=2);
    }
}

module gbBigHolesFlat(detail)
{
    translate([24,24])
    circle(r=7);
    if (detail)
    {
        d1 = 12*sqrt(2)/2;
        d2 = 16*sqrt(2)/2;
        drillList = [
          [24,40],[24,8],
          [24,24+d2],[24,24-d2]
        ];
        for (i=drillList)
        {
            translate([i[0],i[1]])
            circle(r=2);
        }
        translate([22,8])
        square([4,16-d2]);
        translate([22,24+d2])
        square([4,16-d2]);
    }
}

module gbPlateFromFlat(nholes,detail)
{
    length = 24*(nholes+1);
    linear_extrude(2.5,convexity=10)
    translate([-length/2,-24])
    {
        difference()
        {
            square([length,48]);
            if (detail)
            {
                for (i=[0:nholes])
                {
                    translate([24*i,0])
                    gbLittleHolesFlat();
                }
            }
            for (i=[0:nholes-1])
            {
                translate([24*i,0])
                gbBigHolesFlat(detail);
            }
        }
    }
}

module GobildaChannel(nholes,detail=false)
{
    length = 24*(nholes+1);
	color(brightSilver)
	{
        intersection()
        {
            union()
            {
                translate([0,0,24-2.5])
                gbPlateFromFlat(nholes,detail);
                translate([0,24,0])
                rotate([90,0,0])
                gbPlateFromFlat(nholes,detail);
                translate([0,-24,0])
                rotate([-90,0,0])
                gbPlateFromFlat(nholes,detail);
            }
            cube([length-0.3,47.7,47.7],center=true);
        }
	}
}

module gbLowSidePlate(nholes,detail)
{
    length = 24*(nholes+1);
    linear_extrude(2.5,convexity=10)
    difference()
    {
        square([length,12]);
        if (detail)
        {
			for (i=[1:3*nholes+2])
			{
				translate([8*i,4])
				circle(r=2);
			}
        }
    }
}

module GobildaLowChannel(nholes,detail=false)
{
    length = 24*(nholes+1);
	color(brightSilver)
	{
        intersection()
        {
            union()
            {
                translate([0,0,6-2.5])
                gbPlateFromFlat(nholes,detail);
                rotate([0,180,0])
                translate([-length/2,-24,6])
                rotate([-90,0,0])
                gbLowSidePlate(nholes,detail);
                translate([-length/2,24,-6])
                rotate([90,0,0])
                gbLowSidePlate(nholes,detail);
            }
            cube([length-0.3,47.7,11.7],center=true);
        }
	}
}

module hexagon(flatToFlat)
{
	d = flatToFlat/2/sin(60);
	p = [for (i=[0:5]) d*[cos(60*i),sin(60*i)]];
	polygon(p);
}

module GobildaRexShaft(length)
{
	rotate([0,90,0])
	translate([0,0,-length/2])
	difference()
	{
		intersection()
		{
			linear_extrude(length,convexity=1)
			hexagon(11);
			translate([0,0,-0.5])
			cylinder(r=6,h=length+1,$fn=96);
		}
		translate([0,0,-0.1])
		cylinder(r=3.3/2,h=10);
		translate([0,0,length-9.9])
		cylinder(r=3.3/2,h=10);
	}
}

module GobildaFaceThruHolePillowBlock()
{
	$fn=50;
	d = 16*sqrt(2);
	difference()
	{
		union()
		{
			linear_extrude(3,convexity=5)
			{
				for (theta=[45,135,225,315])
				  translate(d*[sin(theta),cos(theta)])
					square(8,center=true);
				for (theta=[45,135])
				  rotate(theta)
					square([8,2*d],center=true);
				circle(r=15);
			}
			cylinder(r=12,h=6);
		}
		for (theta=[45,135,225,315])
  		  translate([d*sin(theta),d*cos(theta),-0.1])
			cylinder(r=2,h=5);
		translate([0,0,-0.1])
		cylinder(r=10,h=7);
	}
	color(0.4*[1,1,1])
	difference()
	{
		translate([0,0,1])
		cylinder(r=10,h=5);
		cylinder(r=6,h=10);
	}
}

module patternPart()
{
    linear_extrude(6,convexity=4)
    translate([0,24])
    difference()
    {
        union()
        {
            translate([-16,-24])
            square([32,24]);
            circle(16);
        }
        circle(7);
        r1 = 16/sqrt(2);
        r2 = 12;
        for (theta=[45:45:360])
          translate(r1*[cos(theta),sin(theta)])
            circle(2);
        for (theta=[45:90:360])
          translate(r2*[cos(theta),sin(theta)])
            circle(2);
    }
}

module GobildaCornerPatternMount($fn=20)
{
    patternPart();
    rotate([-90,180,0])
    patternPart();
}

module GobildaDualBlockMount()
{
    rotate([180,0,0])
    translate([0,-8.5,-12])
    difference()
    {
        union()
        {
            translate([13,0,0])
            cube([6,8.5,12]);
            translate([-19,0,0])
            cube([6,8.5,12]);
            translate([-19,0,0])
            cube([38,3,8]);
        }
        translate([16,3,6])
        cylinder(r=2,h=6.1);
        translate([-16,3,6])
        cylinder(r=2,h=6.1);
        translate([16,2.5,4])
        rotate([-90,0,0])
        cylinder(r=2,h=6.1);
        translate([-16,2.5,4])
        rotate([-90,0,0])
        cylinder(r=2,h=6.1);
        for (x=[-8,0,8])
            translate([x,-0.1,4])
        rotate([-90,0,0])
        cylinder(r=2,h=6.1);
    }
}

module GobildaMotor435()
{
    $fn=40;
    rotate([0,-90,0])
    {
        color(0.4*[1,1,1])
        {
        cylinder(r=16,h=41.9);
        translate([0,0,41.8])
        cylinder(r=37.5/2,h=75);
        }
        color(0.9*[1,1,1])
        translate([0,0,-24])
        cylinder(r=3,h=24.1);
    }
}

module gbFlatBeam(nholes,h)
{
	length = nholes*8;
	linear_extrude(h,convexity=10)
	difference()
	{
		square([length,8]);
		for (i=[4:8:length])
			translate([i,4]) circle(2);
	}
}

module GobildaSquareBeam(nholes)
{
	difference()
	{
		translate([-nholes*4,-4,-4])
		intersection()
		{
			translate([0,0,-1])
			gbFlatBeam(nholes,10);
			rotate([90,0,0])
			translate([0,0,-9])	
			gbFlatBeam(nholes,10);
		}
		rotate([0,90,0])
		translate([0,0,nholes*4-10])
		cylinder(r=2,h=11);
		rotate([0,-90,0])
		translate([0,0,nholes*4-10])
		cylinder(r=2,h=11);
	}
}

module GobildaSpacer(od,length)
{
	id = (od==8) ? 6 : 4;
	color(brightSilver)
	linear_extrude(length,convexity=2)
	difference()
	{
		circle(od/2);
		circle(id/2);
	}
}

//GobildaLowChannel(5,detail=true);
//GobildaChannel(5,detail=true);
GobildaRexShaft(104);
//GobildaFaceThruHolePillowBlock();
//GobildaCornerPatternMount();
//GobildaDualBlockMount();
//GoBildaMotor435();
//GobildaSquareBeam(10);
//GobildaSpacer(6,10);