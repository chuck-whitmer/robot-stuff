$fn=100;

inch = 25.4;
hubDiam1 = 58.30;
hubDiam2 = 1.125*inch - 0.02*inch;
hubDiam3 = 0.75*inch - 0.02*inch;

screwHoleDiam = 7/32*inch;
screwRadius = 1.875/2*inch;

difference()
{
    union()
    {
        cylinder(h=6.0, r=hubDiam1/2);  // Was 7
        cylinder(h=8.0, r=hubDiam2/2);   // Was 9
        cylinder(h=10, r=hubDiam3/2); // was 19.10
    }
    union()
    {
        translate([0,0,-1])
        hexagonalPrism(0.515*inch,50);
        for (i=[0:2])
        {
            rotate([0,0,120*i])
            translate([screwRadius,0,-1])
            cylinder(r=screwHoleDiam/2,h=10);
        }
        for (i=[0:2])
        {
            rotate([0,0,120*i+60])
            translate([hubDiam1/2+3,0,-1])
            cylinder(r=14,h=10);
        }
    }
}

module hexagon(w)
{
    s = w/sqrt(3);
    polygon([[-s/2,w/2],[s/2,w/2],[s,0],[s/2,-w/2],[-s/2,-w/2],[-s,0]]);
}

module hexagonalPrism(w,h)
{
    linear_extrude(height=h)
    hexagon(w);
}
