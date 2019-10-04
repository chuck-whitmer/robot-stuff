drillDepth = 15;

module RevHoles(nholes)
{
    smallR = 3.3/2; // Nominal M3
    largeR = 9.9/2; // Nominal 9.0 mm
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

module RevSlots(nholes, angle)
{
    smallR = 3.3/2; // Nominal M3
    largeR = 9.9/2; // Nominal 9.0 mm
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

module RevLittleHoles(nholes)
{
    smallR = 3.3/2; // Nominal M3
    offset = 8;
    
    angle = 360/nholes;
    for (i=[0:nholes-1])
    {
        translate([offset*sin(i*angle),offset*cos(i*angle),-drillDepth/2])
        cylinder(r=smallR,h=drillDepth);
    }
}

module RevLittleHoles2(nholes, ntotal)
{
    smallR = 3.3/2; // Nominal M3
    offset = 8;
    
    angle = 360/nholes;
    for (i=[0:ntotal-1])
    {
        translate([offset*sin(i*angle),offset*cos(i*angle),-drillDepth/2])
        cylinder(r=smallR,h=drillDepth);
    }
}

