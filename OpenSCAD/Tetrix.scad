$fn = 20;

brightSilver=0.9*[1,1,1];

module txStarHoles(detail)
{
	r1 = 3.7/2;
	r2 = 8/2;
	d1 = 8/sqrt(2);
	smalls = [
		[-8,0],[-d1,d1],[0,8],[d1,d1],
		[8,0],[d1,-d1],[0,-8],[-d1,-d1]];
	if (detail)
	  for (loc=smalls) translate(loc) circle(r1);
	circle(r2);
}

module txSimpleHoles(detail)
{
	r1 = 3.7/2;
	r2 = 8/2;
	smalls = [
		[24,0],[32,8],
		[40,0],[32,-8]];
	if (detail)
	  for (loc=smalls) translate(loc) circle(r1);
	for (i=[16,32,48])
		translate([i,0])
	circle(r2);
}

module txPlate(length,detail)
{
	// Figure out the number of complete star patterns
	// on the plate. Lengths between standards must
	// have been trimmed.
	nStar = (length<=32) ? 1
		: (length<=96) ? 2
		: (length<=160) ? 3
		: (length<=288) ? 5
		: 7;
	
    linear_extrude(2,convexity=10)
    translate([-length/2,-16])
    {
        difference()
        {
            square([length,32]);
			for (i=[0:nStar-2])
  			  translate([64*i+16,16])
			{
				txStarHoles(detail);
				txSimpleHoles(detail);
			}
  			  translate([64*nStar-48,16])
				txStarHoles(detail);
        }
    }
}

module TetrixChannel(length,detail=false)
{
	color(brightSilver)
	{
        intersection()
        {
            union()
            {
                translate([0,0,14])
                txPlate(length,detail);
                translate([0,16,0])
                rotate([90,0,0])
                txPlate(length,detail);
                translate([0,-16,0])
                rotate([-90,0,0])
                txPlate(length,detail);
            }
            cube([length-0.3,31.7,31.7],center=true);
        }
	}
}

module txConnectorPlate1()
{
	linear_extrude(2,convexity=5)
	difference()
	{
		union()
		{
			circle(r=14);
			translate([-14,-16])
			square([28,16]);
		}
		txStarHoles(true);
	}
}

module txConnectorPlate2()
{
	linear_extrude(2,convexity=5)
	difference()
	{
		translate([-14,-14])
		square([28,28]);
		txStarHoles(true);
	}
}

module TetrixInternalCConnector()
{
	translate([0,14,0])
	rotate([90,0,0])
	translate([0,16,0])
	txConnectorPlate1();
	translate([0,-12,0])
	rotate([90,0,0])
	translate([0,16,0])
	txConnectorPlate1();
	txConnectorPlate2();
}

TetrixInternalCConnector();
//TetrixChannel(288,true);