drillDepth = 15;

module holes(nholes)
{
    smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ.
    largeR = 8.8/2; // Nominal 8.0 mm.  8.8 works on TAZ.
    offset = 8;
    
    translate([0,0,-drillDepth/2])
    cylinder(r=largeR,h=drillDepth);
    
    if (nholes > 0)
    {
        angle = 360/nholes;
        for (i=[0:nholes-1])
        {
            translate([offset*sin(i*angle),offset*cos(i*angle),-drillDepth/2])
            cylinder(r=smallR,h=drillDepth);
        }
    }
}

module slots(nholes, angle)
{
    smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ.
    largeR = 8.8/2; // Nominal 8.0 mm.  8.8 works on TAZ.
    offset = 8;
    delta = 0.02;
    
    translate([0,0,-drillDepth/2])
    cylinder(r=largeR,h=drillDepth);

    
    if (nholes > 0)
    {
        theta = 360/nholes;
        for (i=[0:nholes-1])
        {
            translate([0,0,-drillDepth/2])
            rotate([0,0,i*theta])
            minkowski()
            {
                difference()
                {
                    cylinder(r=offset+delta, h=delta);
                    translate([0,0,-delta/2])
                    {
                        cylinder(r=offset-delta, h=2*delta);
                        rotate([0,0,-angle/2])
                        translate([0,-(offset+2*delta),0])
                        cube([offset+2*delta,2*(offset+2*delta),2*delta]);
                        rotate([0,0,angle/2-180])
                        translate([0,-(offset+2*delta),0])
                        cube([offset+2*delta,2*(offset+2*delta),2*delta]);
                    }
                }
                cylinder(r=smallR,h=drillDepth);
            }    
        }
    }
}

module littleHoles(nholes)
{
    smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ.
    offset = 8;
    
    angle = 360/nholes;
    for (i=[0:nholes-1])
    {
        translate([offset*sin(i*angle),offset*cos(i*angle),-drillDepth/2])
        cylinder(r=smallR,h=drillDepth);
    }
}

module littleHoles2(nholes, ntotal)
{
    smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ.
    offset = 8;
    
    angle = 360/nholes;
    for (i=[0:ntotal-1])
    {
        translate([offset*sin(i*angle),offset*cos(i*angle),-drillDepth/2])
        cylinder(r=smallR,h=drillDepth);
    }
}

