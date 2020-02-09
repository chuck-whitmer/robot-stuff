$fn = 50;

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

module gbBigHoles()
{
    translate([24,24,-0.1])
    cylinder(r=7,h=5);
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

module gbPlate(nholes)
{
    length = 24*(nholes+1);
    translate([-length/2,-24,0])
    {
        difference()
        {
            cube([length,48,2.5]);
            for (i=[0:nholes])
            {
                translate([24*i,0,0])
                gbLittleHoles();
            }
            for (i=[0:nholes-1])
            {
                translate([24*i,0,0])
                gbBigHoles();
            }
        }
    }
}

module GobildaChannel(nholes)
{
    translate([0,0,24-2.5])
    gbPlate(nholes);
    translate([0,24,0])
    rotate([90,0,0])
    gbPlate(nholes);
    translate([0,-24,0])
    rotate([-90,0,0])
    gbPlate(nholes);
}

module GobildaLowChannel(nholes)
{
    translate([0,0,6-2.5])
    gbPlate(nholes);
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
        for (i=[1:3*nholes+2])
        {
            translate([8*i,0,-2])
            rotate([90,0,0])
            translate([0,0,-25])
            cylinder(r=2,h=50);
        }
    }
}

GobildaLowChannel(3);



