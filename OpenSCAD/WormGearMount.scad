in = 25.4;
$fn = 50;

use <TimingBeltPulley.scad>
use <tetrix_holes.scad>

module andyMarkGearBox(n)
{
    assert(n==1,"Multiple stage boxes not implemented");
    
    sx = (1.840-0.680)*in;
    sy = 1.5*in;
    sz = 1.5*in;
    xFace = (0.945-0.680)*in;
    r632 = 0.107*in/2;
    mountDepth = 0.190*in;
    xRearFace = -sx+xFace;
    // The box
    color("orange")
    difference()
    {
        translate([-sx+xFace,-sy/2,0])
        cube([sx,1.5*in,1.5*in]);
        translate([0,16,-0.1])
        cylinder(r=r632,h=mountDepth);
        translate([0,-16,-0.1])
        cylinder(r=r632,h=mountDepth);
        translate([-16,16,-0.1])
        cylinder(r=r632,h=mountDepth);
        translate([-16,-16,-0.1])
        cylinder(r=r632,h=mountDepth);
    }
    // The face mount cylinder
    hFaceMount = (0.680-0.315)*in;
    rM3 = 0.098*in/2;
    color("silver")
    translate([xFace,0,sz/2])
    rotate([0,90,0])
    difference()
    {
        cylinder(r=1.360*in/2,h=hFaceMount);
        for (i=[0:3])
            rotate([0,0,90*i+45])
            translate([14,0,hFaceMount-0.25*in+0.1])
            cylinder(r=rM3,h=0.250*in);
    }
    xFaceMount = xFace + hFaceMount;
    // The nub
    color("silver")
    translate([xFaceMount+1,0,sz/2])
    rotate([0,90,0])
    difference()
    {
        union()
        {
            linear_extrude(7)
            intersection()
            {
                square(0.75*in,center=true);
                circle(r=0.840*in/2);
            }
            cylinder(r=4,h=10);
        }
        for (i=[0:3])
            rotate([0,0,90*i+45])
            translate([8,0,0])
            cylinder(r=r632,h=8);
        cylinder(r=3,h=11);
    }
    // The motor
    // 57 18 37.5
    translate([xRearFace,0,sz/2])
    rotate([0,-90,0])
    {
        color("silver")
        cylinder(r=37.5/2,h=57);
        color("black")
        translate([0,0,57])
        cylinder(r=37.5/2,h=18);
    }
    
}

module goBildaWormGear()
{
    ss = 16*sqrt(2)/2; // Screw circle radius. This is 11.31 not 12!
    od = (24+2)*1.5; // 24 tooth MOD 1.5
    color("gold")
        translate([0,0,-4.5])
    difference()
    {
        cylinder(r=od/2,h=9);
        translate([0,0,3])
        cylinder(r=31/2,h=9);
        translate([0,0,-0.5])
        cylinder(r=14/2,h=9);
        for (i=[0:7])
        {
            // Drill the holes which are kind of oval.
            // They are compatible with a 16mm square AND a 12mm radius circle.
            rotate([0,0,45*i])
            {
                translate([12,0,-0.5])
                cylinder(r=2,h=9);
                translate([ss,0,-0.5])
                cylinder(r=2,h=9);
            }
        }
    }
}

module axle(diameter,length)
{
    r = diameter/2;
    s = 1.1*diameter;
    color("silver")
    rotate([0,-90,0])
    translate([0,0,-length/2])
    intersection()
    {
        translate([-s/2,-0.4*s,-0.5])
        cube([s,s,length+1]);
        cylinder(r=r,h=length);
    }
}

module goBildaWormScrew()
{
    color("silver")
    difference()
    {
        rotate([0,-90,0])
        translate([0,0,-39/2])
        cylinder(r=15/2,h=39);
        axle(6,40);
    }
}

module goBildaHyperHub()
{
    ss = 16*sqrt(2)/2; // Screw circle radius. This is 11.31 not 12!
    
    color("silver")  
    {
        difference()
        {
            union()
            {
                cylinder(r=22/2,h=20);
                translate([0,0,-1])
                cylinder(r=14/2,h=2);
                for (i=[0:3])
                    rotate([0,0,90*i])
                    translate([ss,0,0])
                    cylinder(r=4,h=12);
            }
            for (i=[0:3])
                rotate([0,0,90*i])
                translate([ss,0,-1])
                cylinder(r=3.5/2,h=7);
            rotate([0,90,45])
            axle(6,42);
            rotate([0,0,-45])
            translate([0,-25/2,4])
            cube([1.5,25,25]);
        }
    }
}

module wormGearAssembly()
{
    translate([0,0,-1.5])
    goBildaHyperHub();
    translate([0,24,0])
    goBildaWormScrew();
    goBildaWormGear();
}

function plateMountDy(plateThickness,plateGap)
    = plateGap/2 + plateThickness;

module Nub()
{
    s = 0.625*in;
    color("grey")
    intersection()
    {
        difference()
        {
            translate([-s/2,-s/2,0])
            cube([s,s,6]);
            translate([0,0,-10])
            {
                cylinder(r=3,h=20);
                for (i=[0:3])
                {
                    rotate([0,0,45+90*i])
                    translate([8,0,0])
                    cylinder(r=2,h=20);
                }
            }
        }
        s1 = 1.16*s;
        rotate([0,0,45])
        translate([-s1/2,-s1/2,-5])
        cube([s1,s1,20]);
    }
}

// hexagon - A 2D hexagon with flat to flat diameter w. Flats are parallel to x axis.

module hexagon(w)
{
    s = w/sqrt(3);
    polygon([[-s/2,w/2],[s/2,w/2],[s,0],[s/2,-w/2],[-s/2,-w/2],[-s,0]]);
}

lockNutHexFlat = 7.94 + 0.41;  // Flat to flat diameter for 5/16" nut = 7.94 mm.
                        // On Prusa this came out as a 7.5 opening.
lockNutHeight = 4.6;                 

module ToolConnector(shift,plateThickness,rotation)
{
    color("DarkTurquoise")
    {
    pd32 = HtdPulleyDiameter(32,9);
    pipOffset = (pd32+12)/4;
    echo(rotation);
    rotate([90,0,0])
    {
        difference()
        {  
            translate([0,0,-plateThickness/2])
            {
                union()
                {
                    linear_extrude(plateThickness)
                    hull()
                    {
                        circle(r=pd32/2-3);
                        translate([-shift,0])
                        {
                            
                            circle(r=14);
                        }
                    }
                    if (abs(rotation)==90)
                    {
                        linear_extrude(plateThickness+3)
                        translate([-shift,0])
                        {
                            difference()
                            {
                                translate([-2,0])
                                offset(4)
                                square([16,20],center=true);
                                translate([0,8])
                                hexagon(lockNutHexFlat);
                                translate([0,-8])
                                hexagon(lockNutHexFlat);
                            }
                        }
                    }
                }
            }
            translate([-shift,0,0])
            holes(4);
            translate([0,0,-5])
            {
                cylinder(r=4,h=10);
            }
        }
        rPip = 2;
        translate([0,0,plateThickness/2-rPip/2])
        rotate([0,0,rotation])
        {
            translate([0,pipOffset,0])
            sphere(r=rPip);
            translate([-pipOffset,0,0])
            sphere(r=rPip);
            translate([0,-pipOffset,0])
            sphere(r=rPip);
        }
    }
}
}

module bearing(bearingID,bearingOD,bearingH)
{
    bearingLittleR = 0.5;
    difference()
    { 
        rotate_extrude()
        {
            square([bearingOD/2-bearingLittleR,bearingH]);
            translate([0,bearingLittleR])
            square([bearingOD/2,bearingH-2*bearingLittleR]);
            translate([bearingOD/2-bearingLittleR,bearingLittleR])
            circle(r=bearingLittleR);
            translate([bearingOD/2-bearingLittleR,bearingH-bearingLittleR])
            circle(r=bearingLittleR);
        }
        translate([0,0,-0.1])
        cylinder(r=bearingID/2,h=bearingH+0.2);
    }
}

module axleHolder()
{
    color("DarkTurquoise")
    {
        thickness = 4.5;
        rotate([90,0,0])
        {
            rotate([90,0,0])
            translate([0,0,-thickness/2])
            difference()
            {
                linear_extrude(thickness)
                {
                    translate([0,23]) // 23 being 39-16, where 39 
                                      // is the offset of the Robot Connector.
                    circle(r=14);
                    translate([-14,0])
                    square([28,23]);
                }
                bearingDiameterAdjust = 0.3; // First print at 12 gave a hole of 11.6mm
                translate([0,23,-0.2])
                {
                    bearing(6,12+bearingDiameterAdjust,thickness+0.4);
                    cylinder(r=4,h=thickness+0.4);
                }
            }
            difference()
            {
                linear_extrude(thickness)
                offset(2)
                square(24,center=true);
                littleHoles(2);
            }
        }
    }
}

// Outside of the worm gear
module axleHolder2()
{
    color("DarkTurquoise")
    {
        thickness = 4.5;
        leftOffset = 18;
        rotate([90,0,0])
        {
            rotate([90,0,0])
            translate([0,0,-thickness/2+leftOffset])
            difference()
            {
                linear_extrude(thickness)
                {
                    translate([0,23]) // 23 being 39-16, where 39 
                                      // is the offset of the Robot Connector.
                    circle(r=14);
                    translate([-14,0])
                    square([28,23]);
                }
                bearingDiameterAdjust = 0.3; // First print at 12 gave a hole of 11.6mm
                translate([0,23,-0.2])
                {
                    bearing(6,12+bearingDiameterAdjust,thickness+0.4);
                    cylinder(r=4,h=thickness+0.4);
                }
            }
            rotate([90,0,0])
            translate([0,0,-thickness/2])
            difference()
            {
                linear_extrude(thickness)
                {
                    translate([0,23]) // 23 being 39-16, where 39 
                                      // is the offset of the Robot Connector.
                    circle(r=14);
                    translate([-14,0])
                    square([28,23]);
                }
                bearingDiameterAdjust = 0.3; // First print at 12 gave a hole of 11.6mm
                translate([0,23,-0.2])
                {
                    bearing(6,12+bearingDiameterAdjust,thickness+0.4);
                    cylinder(r=4,h=thickness+0.4);
                }
            }
            difference()
            {
                padLen = 34;
                linear_extrude(thickness)
                offset(2)
                translate([-12,12-padLen])
                square([24,padLen]);
                littleHoles(2);
            }
        }
    }
}

// Below the worm screw
module axleHolder3()
{
    color("DarkTurquoise")
    {
        thickness = 4.5;
        bearingOffset = 8;  // 24 worm gear offset, less 16 for center
        bearingDiameterAdjust = 0.3; 
        rotate([90,0,0])
        {
            difference()
            {
                union()
                {
                    rotate([90,0,0])
                    translate([0,0,-thickness/2+12])
                    linear_extrude(thickness)
                    {
                        intersection()
                        {
                            translate([0,bearingOffset])
                            circle(r=14);
                            translate([-14,0])
                            square([28,28]);
                        }
                        translate([-14,0])
                        square([28,bearingOffset]);
                    }
                    difference()
                    {
                        linear_extrude(thickness)
                        offset(2)
                        translate([-12,-14])
                        square([24,26]);
                        littleHoles(1);
                        rotate(90)
                        littleHoles(2);
                    }
                }
                translate([0,-16.1,bearingOffset])
                {
                    rotate([-90,0,0])
                    {
                    bearing(6,12+bearingDiameterAdjust,thickness+2);
                    cylinder(r=4,h=thickness+2);
                    }
                }                
            }
        }
    }
}


PRUSA = 1;
TAZ = 2;

//-----------------//
printer = PRUSA;
//-----------------//

flange = 0.1*in;
plateGap = 0.1*in;
plateThickness = 4; // Matches the bearing.
bearingOD = 6;
bearingAdj = 0.1; // 0 too tight. 0.2 a tiny bit loose. (Rough settings.)
tubeAdj = (printer==PRUSA) ? 0.08 : (printer==TAZ) ? 0.10 : 0.0; // 0.13 for TAZ/slic3r
// 0.09 is a little loose for PRUSA/Simplify3D, but nice with slic3r.

justOneConnector = 0;
tetrixTest = 4;
axleHolder = 7;
axleHolder2 = 11;
axleHolder3 = 12;
wormGear = 8;
assembly = 9;
motor = 10;

//display = tetrixTest;
//display = justOneConnector;
//display = axleHolder;
//display = axleHolder2;
//display = axleHolder3;
//display = wormGear;
display = assembly;
//display = motor;

if (display == axleHolder)
{
    axleHolder();
}
else if (display == axleHolder2)
{
    axleHolder2();
}
else if (display == axleHolder3)
{
    axleHolder3();
}
else if (display == motor)
{
    andyMarkGearBox(1);
}
else if (display == wormGear)
{
    translate([0,0,-1.5])
    goBildaHyperHub();
    translate([0,24,0])
    goBildaWormScrew();
    goBildaWormGear();
}
else if (display == justOneConnector)
{

c0a = 1;
c0b = 2;

thisConnector = c0a;

dh3215 = HtdPulleyHeight(32,15);

    if (thisConnector == c0a)
    {
        plateThickness = 14-dh3215/2;
        rotate([-90,0,0])
        ToolConnector(39,plateThickness,90);
    }
    else if (thisConnector == c0b)
    {
        plateThickness = 14-dh3215/2;
        rotate([-90,0,0])
        ToolConnector(39,plateThickness,-90);
    }
}
else if (display == tetrixTest)
{
    TetrixChannel(96);
}
else if (display == assembly)
{
    rotate([180,0,90])
    TetrixChannel(96);
    translate([-5*32/2-16,0,0])
    TetrixChannel(5*32);
    translate([5*32/2+16,0,0])
    TetrixChannel(5*32);

    dh3215 = HtdPulleyHeight(32,15);
    plateThickness = 14-dh3215/2;
    translate([14,0,0])
    rotate([0,-90,-90])
    translate([39,-plateThickness/2,0])
        ToolConnector(39,plateThickness,90);
    translate([-14,0,0])
    rotate([0,-90,90])
    translate([39,-plateThickness/2,0])
        ToolConnector(39,plateThickness,-90);
    
    axleLen = 135;
    translate([-axleLen/2+32,0,39])
    axle(6,axleLen);
    
    translate([-64,24,37])
    rotate([0,90,0])
    axle(6,80);

    translate([-32,0,16])
    rotate([-90,0,90])
    axleHolder();

    translate([-3*32,0,16])
    rotate([-90,0,90])
    axleHolder2();
    
    translate([-64,16,0])
    rotate([180,0,0])
    axleHolder3();

    translate([-64,0,39])
    rotate([0,90,0])
    {
        wormGearAssembly();
        translate([7-2.5*32+8,24,0])
        rotate([90,0,0])
        translate([0,0,-0.75*in])
        andyMarkGearBox(1);
    }
    translate([-3.5*32,32,32+16])
    rotate([0,90,0])
    TetrixChannel(5*32);
    translate([-2.5*32,64,3.5*32])
    rotate([90,0,0])
    TetrixChannel(3*32);

}
