$fn = 20;

brightSilver=0.9*[1,1,1];

module gbLittleHoles()
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
        translate([i[0],i[1],-0.1])
        cylinder(r=2,h=5);
    }
}

module gbBigHoles(detail)
{
    translate([24,24,-0.1])
    cylinder(r=7,h=5);
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
            translate([i[0],i[1],-0.1])
            cylinder(r=2,h=5);
        }
        translate([22,8,-0.1])
        cube([4,16-d2,5]);
        translate([22,24+d2,-0.1])
        cube([4,16-d2,5]);
    }
}

module gbPlate(nholes,detail)
{
    length = 24*(nholes+1);
    translate([-length/2,-24,0])
    {
        difference()
        {
            cube([length,48,2.5]);
            if (detail)
            {
                for (i=[0:nholes])
                {
                    translate([24*i,0,0])
                    gbLittleHoles();
                }
            }
            for (i=[0:nholes-1])
            {
                translate([24*i,0,0])
                gbBigHoles(detail);
            }
        }
    }
}

module GobildaChannel(nholes,detail=false)
{
	color(brightSilver)
	{
		translate([0,0,24-2.5])
		gbPlate(nholes,detail);
		translate([0,24,0])
		rotate([90,0,0])
		gbPlate(nholes,detail);
		translate([0,-24,0])
		rotate([-90,0,0])
		gbPlate(nholes,detail);
	}
}

module GobildaLowChannel(nholes,detail=false)
{
	color(brightSilver)
	{
		translate([0,0,6-2.5])
		gbPlate(nholes,detail);
		length = 24*(nholes+1);
		translate([-length/2,0,0])
		difference()
		{
			union()
			{
				translate([0,-24,-6])
				cube([length,2.5,12]);
				translate([0,24-2.5,-6])
				cube([length,2.5,12]);
			}
			if (detail)
			for (i=[1:3*nholes+2])
			{
				translate([8*i,0,-2])
				rotate([90,0,0])
				translate([0,0,-25])
				cylinder(r=2,h=50);
			}
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

//GobildaLowChannel(3);
//GobildaChannel(3);
//GobildaRexShaft(104);
GobildaFaceThruHolePillowBlock();



