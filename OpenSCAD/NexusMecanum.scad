$fn=50;

rollerMaxRadius = 19.45/2;
brightSilver = [0.9,0.9,0.9];

module roller()
{
    $fn = 200;
    R = 91.4; 
    r1 = rollerMaxRadius;
    a = 47/2;

    color("grey")
    rotate_extrude(angle=360,convexity=1)
    intersection()
    {
        translate([r1-R,0])
        circle(R);
        translate([0,-a])
        square(2*a);
    }
}

module bracketTab()
{
    d1 = 10.648;
    rotate([45,0,0])
    translate([50-rollerMaxRadius,-47/2,0])
    rotate([90,0,0])
    {
        linear_extrude(1)
        {
            difference()
            {
                intersection()
                {
                    union()
                    {
                        circle(r=5);
                        translate([-5,0])
                        square([10,2*d1]);
                        rotate(20)
                        translate([-5,0])
                        square([10,2*d1]);
                    }
                    square(2*d1,center=true);
                }
                circle(r=2);
            }
        }
        cylinder(r=2.5,h=3.5);
    }
}

module bracketFlat()
{
    z1 = -9.441;
    h2 = 50-rollerMaxRadius+5;
    r3=35;
    poly1 = [[0,0],[h2,0],[h2,10],
        [r3*cos(40),r3*sin(40)]];
    translate([0,-24,z1])
    rotate([90,0,0])
    linear_extrude(1)
    {
        polygon(poly1);
    }
}

module bracket()
{
    z1 = -9.441;
    h2 = 50-rollerMaxRadius+5;
    color(brightSilver)
    difference()
    {
        union()
        {
            for(i=[0:8])
            {
                rotate([0,i*360/9,0])
                {
                    bracketTab();
                    bracketFlat();
                    translate([0,-24.5,z1])
                    rotate([0,90,0])
                    cylinder(r=0.5,h=h2);
                }
            }
        }
        rotate([90,0,0])
        cylinder(r=12,h=59.5);
    }
}

module boundingCylinder()
{
    translate([0,-25,0])
    rotate([-90,0,0])
    cylinder(r=50,h=50);
}

//boundingCylinder(); // For debugging

module NexusMecanum()
{
    // Rollers
    for(i=[0:8])
    {
        rotate([0,i*360/9,0])
        translate([50-rollerMaxRadius,0,0])
        rotate([-45,0,0])
        roller();
    }

    difference()
    {
        union()
        {
            // Inner cylinder
            h1=48-0.1;
            color("white")
            difference()
            {
                translate([0,-h1/2,0])
                rotate([-90,0,0])
                cylinder(r=50-2*rollerMaxRadius-2,h=h1);
                translate([0,-h1,0])
                rotate([-90,0,0])
                cylinder(r=9,h=2*h1);
                rotate([90,0,0])
                cylinder(r=21.8/2,h=2*h1);
            }

            // Support bracket
            bracket();
            rotate([180,0,0])
            bracket();
        }
        h3 = 70;
        for (i=[0:5])
        {
            rotate([0,60*i,0])
            translate([47.5/2,0,0])
            rotate([-90,0,0])
            translate([0,0,-h3/2])
            cylinder(r=2.5,h=h3);
        }
    }
    color(0.8*[1,1,1])
    for (i=[0:2])
    {
        rotate([0,120*i,0])
        translate([47.5/2,-25,0])
        rotate([90,0,0])
        cylinder(r=4,h=4.9);
    }
    color(0.8*[1,1,1])
    for (i=[0:2])
    {
        rotate([0,120*i,0])
        translate([47.5/2,25,0])
        rotate([-90,0,0])
        cylinder(r=4,h=4.9);
    }
}