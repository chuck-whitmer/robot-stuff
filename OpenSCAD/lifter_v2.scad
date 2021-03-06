in = 25.4;
$fn = 50;

use <TimingBeltPulley.scad>
use <tetrix_holes.scad>


function TubeWeight(id, od, length, density)
    = (3.14159*(od*od-id*id)*length*density);

module tube(id, od, length)
{
    translate([-length/2,0,0])
    rotate([0,90,0])
    difference()
    {
        cylinder(r=od/2,h=length);
        translate([0,0,-0.1])
        cylinder(r=id/2,h=length+0.2);
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

module CopyFourWays(dx,dy)
{
    translate([dx,dy,0])
        children();
    translate([dx,-dy,0])
    mirror([0,1,0])
        children();
    rotate([0,180,0])
    {
    translate([dx,dy,0])
        children();
    translate([dx,-dy,0])
    mirror([0,1,0])
        children();
    }
}

module Double(dy)
{
    translate([0,dy,0])
        children();
    translate([0,-dy,0])
        children();
}

module Boundary2D(dd)
{
    difference()
    {
        offset(dd) children();
        children();
    }
}

module HtdBelt(d1,x1,y1,d2,x2,y2,width)
{
    color("brown")
    translate([0,0,-width/2])
    linear_extrude(width)
    Boundary2D(2)
    hull()
    {
        translate([x1,y1])
        circle(r=d1/2-1);
        translate([x2,y2])
        circle(r=d2/2-1);
    }
}

function plateMountDy(plateThickness,plateGap)
    = plateGap/2 + plateThickness;

module connector(tubeOD,sheathWall,sheathLength,plateCenterX,plateCenterY,
    plateThickness,plateGap,bearingOD,pitchDiameter,flange,tubeAdj,bearingAdj,pipRotation,pipOffset)
{
    // The connector consists of a sheath and a roundish plate.
    // The connector is oriented along the X axis, and drops below.
    // The origin is at the right center of the sheath.

    rs = tubeOD/2+sheathWall; // sheath radius
    
    difference()
    {
        union()
        {
            // Construct the sheath.
            rotate([0,-90,0])
            cylinder(r=rs,h=sheathLength);
            
            // Construct the dome.
            zc = (plateCenterY != 0) ?            
            (plateThickness*plateThickness-rs*rs)/(2*plateThickness) // This is negative.
            : (plateThickness*plateThickness/4-rs*rs)/(plateThickness);
            intersection()
            {
                translate([zc,0,0])
                sphere(r=plateThickness-zc);
                translate([-sheathLength,0,0])
                rotate([0,90,0])
                cylinder(r=rs,h=2*sheathLength);
            }

            // Construct the plate.
            rotate([90,0,0])
            translate([0,0,plateGap/2])
            linear_extrude(plateThickness)
            difference()
            {
                union()
                {
                    a = plateGap/2 + plateThickness;
                    r = tubeOD/2 + sheathWall;
                    b = sqrt(r*r-a*a);
                    hull()
                    {
                        // The basic circle.
                        translate([plateCenterX,plateCenterY])
                        circle(r=pitchDiameter/2+flange);
                        // Attachment to the sheath.
                        translate([0,-b])
                        square([2,2*b]);
                    }
                    // Push the attachment into the sheath.
                    translate([-2,-b])
                    square([4,2*b]);
                }
                // Drill the bearing hole.
                translate([plateCenterX,plateCenterY])
                circle(r=bearingOD/2+bearingAdj);
            }
        }
        rotate([0,-90,0])
        translate([0,0,-0.1])
        cylinder(r=tubeOD/2+tubeAdj,sheathLength+0.2);

        translate([-sheathLength+tubeOD/2+1,0,0])
        rotate([0,-90,0])
        cylinder(r1=0,r2=sheathLength,h=sheathLength);
        
    }
    if (pipOffset != 0)
    {
        rPip = 2;
        translate([plateCenterX,rPip/2-(plateThickness+plateGap/2),plateCenterY])
        rotate([0,pipRotation,0])
        {
            translate([0,0,pipOffset])
            sphere(r=rPip);
            translate([0,0,-pipOffset])
            sphere(r=rPip);
            translate([-pipOffset,0,0])
            sphere(r=rPip);
        }
    }
}

module SimpleInnerSet()
{
    Double(tubeOffset/2)
    color("gray")
    tube(tubeId,tubeOd,tubeLength);

    CopyFourWays(tubeLength/2,tubeOffset/2)
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,
        pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);

    pulleyHeight = HtdPulleyHeight(16,15);
    translate([-x1-tubeLength/2,0,-y1])
    rotate([90,0,0])
    HtdPulley(16,15,0);    
    translate([x1+tubeLength/2,0,y1])
    rotate([90,0,0])
    HtdPulley(16,15,0);      
}

module SimpleOuterSet()
{
    Double(tubeOffset/2)
    color("gray")
    tube(tubeId,tubeOd,tubeLength);

    CopyFourWays(tubeLength/2,-tubeOffset/2)
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
        
    dy = plateMountDy(plateThickness,plateGap);
        echo(dy);
    dh = HtdPulleyHeight(16,9);
    CopyFourWays(tubeLength/2+x1,0)    
    translate([0,tubeOffset/2+dy+dh/2,y1])
    rotate([90,0,0])
    HtdPulley(16,9,0);    
}

module BottomOuterSet()
{
    Double(tubeOffset/2)
    color("gray")
    tube(tubeId,tubeOd,tubeLength2);

    translate([tubeLength2/2,tubeOffset/2,0])
    rotate([180,0,0])
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
    bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
    
    translate([tubeLength2/2,-tubeOffset/2,0])
    mirror([0,1,0])
    rotate([180,0,0])
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
    bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
    
    echo("R2 ? ",sqrt((tubeLength2+x1+x2)*(tubeLength2+x1+x2)+(y1+y2)*(y1+y2)));
    translate([-tubeLength2/2,-tubeOffset/2,0])
    mirror([1,0,0])
    difference()
    { 
        connector(tubeOd,sheathWall,sheathLength,x2,y2,plateThickness,plateGap,
          bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
        translate([x2,0,0])
        rotate([90,0,0])
        {
            translate([0,0,-10])
            for (i=[0:3])
            {
                rotate([0,0,45+90*i])
                translate([8,0,0])
                cylinder(r=2,h=20);
            }
        }        
    }
    
    
    translate([-tubeLength2/2,tubeOffset/2,0])
    rotate([0,0,180])    
    difference()
    { 
        connector(tubeOd,sheathWall,sheathLength,x2,y2,plateThickness,plateGap,
          bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
        translate([x2,0,0])
        rotate([90,0,0])
        {
            translate([0,0,-10])
            for (i=[0:3])
            {
                rotate([0,0,45+90*i])
                translate([8,0,0])
                cylinder(r=2,h=20);
            }
        }        
    }
        
    dy = plateMountDy(plateThickness,plateGap);
    dh = HtdPulleyHeight(16,9);

    translate([tubeLength2/2+x1,tubeOffset/2+dy+dh/2,-y1])
    rotate([90,0,0])
    HtdPulley(16,9,0);    
    translate([tubeLength2/2+x1,-(tubeOffset/2+dy+dh/2),-y1])
    rotate([90,0,0])
    HtdPulley(16,9,0);    

    translate([tubeLength2/2+x1,0,-y1])
    rotate([0,0,-90])
    axle(6,75);

    translate([-tubeLength2/2-x2,0,0])
    rotate([0,0,-90])
    axle(6,75);

    translate([-tubeLength2/2-x2,tubeOffset/2+dy+6.1,0])
    rotate([90,0,0])
    Nub();
    translate([-tubeLength2/2-x2,-(tubeOffset/2+dy+6.1),0])
    rotate([-90,0,0])
    Nub();
}

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

module TopInnerSet()
{
    Double(tubeOffset/2)
    color("gray")
    tube(tubeId,tubeOd,tubeLength2);

    translate([tubeLength2/2,tubeOffset/2,0])
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
    bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
    
    translate([tubeLength2/2,-tubeOffset/2,0])
    mirror([0,1,0])
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
    bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
    
    translate([-tubeLength2/2,-tubeOffset/2,0])
    mirror([1,0,0])
    rotate([180,0,0])
    connector(tubeOd,sheathWall,sheathLength,x2,y2,plateThickness,plateGap,
      bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
    translate([-tubeLength2/2,tubeOffset/2,0])
    rotate([180,0,180])
    connector(tubeOd,sheathWall,sheathLength,x2,y2,plateThickness,plateGap,
      bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
        
    dy = plateMountDy(plateThickness,plateGap);
    dh = HtdPulleyHeight(16,9);

    translate([tubeLength2/2+x1,0,y1])
    rotate([90,0,0])
    HtdPulley(16,15,0);    

    translate([-tubeLength2/2-x2,0,0])
    rotate([90,0,0])
    HtdPulley(16,15,0);    
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


module ToolMount()
{
    dy = plateMountDy(plateThickness,plateGap);
    dh = HtdPulleyHeight(16,9);
    pulleyFaceY = tubeOffset/2+dy;

    translate([-96-39,0,-32])
    {
        translate([32,0,-32])
        rotate([0,-90,0])
        TetrixChannel(96);
        translate([64,0,32])    
        TetrixChannel(96);
    }
    
    pd32 = HtdPulleyDiameter(32,9);
    pd16 = HtdPulleyDiameter(16,9);
    middleR = (pd32+pd16)/4-1.5;
    rotation = -45;
    
    difference()
    {
        union()
        {
            translate([0,tubeOffset/2+dy+dh/2,0])
            rotate([90,0,0])
            HtdPulley(32,9,0);    
            translate([0,-(tubeOffset/2+dy+dh/2),0])
            rotate([90,0,0])
            HtdPulley(32,9,0);   
        }
            rotate([90,0,0])
        translate([0,0,-50])
        {
            cylinder(r=bearingOD/2+bearingAdj,h=10);
            rotate([0,0,rotation])
            {
                translate([-middleR,0,0])
                cylinder(r=2.1,h=100);
                translate([0,middleR,0])
                cylinder(r=2.1,h=100);
                translate([0,-middleR,0])
                cylinder(r=2.1,h=100);
            }
        }
    }
    pt = pulleyFaceY-16;
    echo("Tool mount plate thickness",pt);
    translate([0,16+pt/2,0])
    ToolConnector(39,pt,rotation);
    translate([0,-16-pt/2,0])
    ToolConnector(39,pt,rotation);
}

module RobotMount()
{
    dh = HtdPulleyHeight(32,15);
    plateThickness = 14-dh/2;

    rotation = -11;
    
    translate([0,dh/2+plateThickness/2,0])
    rotate([0,-90,0])
    ToolConnector(39,plateThickness,rotation);
    translate([0,-dh/2-plateThickness/2,0])
    rotate([0,-90,0])
    ToolConnector(39,plateThickness,rotation);
    
    translate([0,0,-39])
    rotate([180,0,0])
    TetrixChannel(96);

    rotate([90,0,0])
    HtdPulley(32,15,0);    
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

carbonTube1 = [0.314*in,0.393*in,"McMaster"];
// 0.054 lb/in^3
// For the 0.393 in tube, this is 1.7 g/cm.
// Tetrix channel is 3.9 g/cm.

myTube = carbonTube1;
tubeId = myTube[0];
tubeOd = myTube[1];
tubeLength = 6.75*in;

PRUSA = 1;
TAZ = 2;

//-----------------//
printer = PRUSA;
//-----------------//

sheathWall = 2.5;
sheathLength = 1.0*in;
stackGap = 1.0;
flange = 0.1*in;
plateGap = 0.1*in;
plateThickness = 4; // Matches the bearing.
bearingOD = 6;
bearingAdj = 0.1; // 0 too tight. 0.2 a tiny bit loose. (Rough settings.)
tubeAdj = (printer==PRUSA) ? 0.08 : (printer==TAZ) ? 0.10 : 0.0; // 0.13 for TAZ/slic3r
// 0.09 is a little loose for PRUSA/Simplify3D, but nice with slic3r.

// R1 = 13.190*in;  // 5mm HTD 150, 16 to 16 tooth
R1 = 8.2687*in;  // 5mm HTD 100, 16 to 16 tooth
pitchDiameter1 = 1.0026*in;
y1 = -(tubeOd/2 + sheathWall + stackGap/2);
x1 = (sqrt(R1*R1-4*y1*y1)-tubeLength)/2;

plateDy = plateMountDy(plateThickness,plateGap);
tubeOffset = 2*plateDy + HtdPulleyHeight(16,15);
echo("tubeOffset=",tubeOffset);

// Bottom and top connectors.
R2 = 9.4365*in; // HTD 120, 16 to 32 tooth
echo("R2 = ",R2);
pitchDiameter2 = 2.0051*in;
tubeLength2 = 7.5*in;

y2 = 0;
//x2 = R2 - tubeLength2 - x1; //!!! This was a 0.2mm error !!!
x2 = sqrt(R2*R2-y1*y1) - tubeLength2 - x1;

//    theta = ($t < 0.45) ? $t/0.45*170
//        : ($t < 0.50) ? 170
//        : ($t < 0.95) ? (0.95-$t)/0.45*170
//        : 0;
    
// >> Set theta here! <<
// Good values are 0 to 170.
//
    
    theta = 0;
    firstAngle = 30;  // 30 for bottom 5 for top.
    lastAngle = 5;
    
    d1 = HtdPulleyPitchDiameter(16,9);
    d2 = HtdPulleyPitchDiameter(32,9);

justOneConnector = 0;
theWholeStack = 1;
onePulley = 2;
bottomLink = 3;
tetrixTest = 4;
tubeSpacer = 5;
tensioner = 6;
axleHolder = 7;

//display = bottomLink;
//display = theWholeStack;
//display = tetrixTest;
//display = onePulley;
display = justOneConnector;
//display = tubeSpacer;
//display = tensioner;
//display = axleHolder;

if (display == axleHolder)
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
                translate([0,23]) // 23 being 39-16, where 39 is the offset of the Robot Connector.
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
else if (display == tensioner)
{
    //tube(tubeId,tubeOd,1*in);
    h1 = 2.0;
    r1 = (2/3*tubeOd+1/3*tubeId)/2;
    cylinder(r=r1,h=h1);
    cylinder(r=r1/3,h=sheathLength/2);
}
else if (display == justOneConnector)
{
//Pulley Alignment
//It is essential that if we want the starting linkages to have the angles we
//specify, then the pulleys need to be aligned to allow it. One tooth over on 
//a 16 tooth pulley is 22.5 degrees!
//For the two linkages in the middle that are horizontal, we make sure all pulleys
//start orientated straight up. There is an alignment mark on each pulley that
//aligns with a belt valley.
//For any other set of pulleys that will share a belt, the alignment marks must 
//each point to the other pulley's center. Then the teeth are guaranteed to mesh.
//There are 3 pips on connectors, and by convention we will have these be located
//top, bottom, and left.
//So the corresponding pip holes on the pulleys must be rotated so that they have
//the correct starting position.
    
// The connectors on the robot mount will be called 0a and 0b. 0a is on the left of
// the robot.
// The connectors on the first linkage are 1La, 1Lb, 1Ua, 1Ub. Lower and Upper.

// The bottom linkage is an Outer set. 9mm with pulleys. The 1Ua and 1Ub must start aligned
// upward to mesh with 3La and 3Lb, but linkage 1 is angled, and the pips on the connector
// must be adjusted.    

c0a = 1;
c0b = 2;
c1La = 3;
c1Ua = 4;    
c1Ub = 5;
c2La = 6;
c2Lb = 7;
c4Lb = 8;
c4La = 9;
c4Ua = 10;
c4Ub = 11; // Same as c4Ua
c5a = 12;
c5b = 13;

thisConnector = c1La;

dh3215 = HtdPulleyHeight(32,15);

    if (thisConnector == c1Ua)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        mirror([0,0,1])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,-firstAngle,(w+12)/4);
    }
    if (thisConnector == c1Ub)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,-firstAngle,(w+12)/4);
    }
    else if (thisConnector == c2La)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        mirror([0,0,1])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,0,(w+12)/4);
    }
    else if (thisConnector == c2Lb)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,0,(w+12)/4);
    }
    else if (thisConnector == c4La)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        mirror([0,0,1])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,-lastAngle,(w+12)/4);
    }
    else if (thisConnector == c4Lb)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,-lastAngle,(w+12)/4);
    }
    else if (thisConnector == c4Ua || thisConnector == c4Ub)
    {
        w = HtdPulleyDiameter(16,9);
        rotate([-90,0,0])
        connector(tubeOd,sheathWall,sheathLength,x2,0,plateThickness,plateGap,
          7,pitchDiameter1,flange,tubeAdj,bearingAdj,180,(w+12)/4);
    }
    else if (thisConnector == c1La)
    {
        rotate([-90.0,0])
        difference()
        { 
            union()
            {
                connector(tubeOd,sheathWall,sheathLength,x2,y2,plateThickness,plateGap,
                  bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj,0,0);
                xx = 22;
                yy = 4;
                zz = 10.5;
                translate([-xx/2,-tubeOd/2-tubeAdj-yy,-zz/2])
                cube([xx,yy,zz]);
            }
            translate([x2,0,0])
            rotate([90,0,0])
            {
                translate([0,0,-10])
                for (i=[0:3])
                {
                    rotate([0,0,45+90*i])
                    translate([8,0,0])
                    cylinder(r=2,h=20);
                }
            }        
        }       
    }
    else if (thisConnector == c0a)
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
    else if (thisConnector == c5a)
    {
        dy = plateMountDy(plateThickness,plateGap);
        dh = HtdPulleyHeight(16,9);
        pulleyFaceY = tubeOffset/2+dy;
        pt = pulleyFaceY - 16;
        echo("pt",pt);
        rotate([-90,0,0])
        ToolConnector(39,pt,0);
    }


}
else if (display == tubeSpacer)
{
    
    translate([-tubeOffset/2,0,0])
    difference()
    {
        cylinder(r=tubeOd/2+sheathWall,10);
        translate([0,0,-0.1])
        cylinder(r=tubeOd/2+tubeAdj,10.2);
        translate([0,0,-10+tubeOd/2+1])
        cylinder(r1=tubeOd,r2=0,h=tubeOd);
        translate([0,0,10-tubeOd/2-1])
        cylinder(r2=tubeOd,r1=0,h=tubeOd);
    }
    translate([tubeOffset/2,0,0])
    difference()
    {
        cylinder(r=tubeOd/2+sheathWall,10);
        translate([0,0,-0.1])
        cylinder(r=tubeOd/2+tubeAdj,10.2);
        translate([0,0,-10+tubeOd/2+1])
        cylinder(r1=tubeOd,r2=0,h=tubeOd);
        translate([0,0,10-tubeOd/2-1])
        cylinder(r2=tubeOd,r1=0,h=tubeOd);
    }
    translate([-(tubeOffset-tubeOd-sheathWall)/2,-sheathWall/2,0])
    cube([tubeOffset-tubeOd-sheathWall,sheathWall,10]);
}
else if (display == onePulley)
{
    p0 = 1;
    p1Ua =2;
    p2L = 3;
    p2U = 4;
    p3Ua = 5;
    p5a = 6;
    
    dAngle0 = atan(y1/(x1+tubeLength2+x2));
    twist0 = 90 - firstAngle + dAngle0;
    twist5 = 90 + lastAngle - dAngle0;
    
    thisPulley = p3Ua;
    
    bearingDiameterAdjust = 0.3; // First print at 12 gave a hole of 11.6mm
    if (thisPulley == p0)
    {
        teeth = 32;
        width = 15;
        h = HtdPulleyHeight(teeth,width);
        echo(twist0);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,twist0,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else if (thisPulley == p2L)
    {
        teeth = 16;
        width = 15;
        h = HtdPulleyHeight(teeth,width);
        echo(twist0);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,twist0,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else if (thisPulley == p2U)
    {
        teeth = 16;
        width = 15;
        h = HtdPulleyHeight(teeth,width);
        echo(twist0);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,0,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else if (thisPulley == p1Ua)
    {
        teeth = 16;
        width = 9;
        h = HtdPulleyHeight(teeth,width);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,0,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else if (thisPulley == p3Ua)
    {
        teeth = 16;
        width = 9;
        h = HtdPulleyHeight(teeth,width);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,twist5,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else if (thisPulley == p5a)
    {
        teeth = 32;
        width = 9;
        h = HtdPulleyHeight(teeth,width);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,twist5,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
    else
    {
        teeth = 16;
        width = 9;
        h = HtdPulleyHeight(teeth,width);
        difference()
        {
            translate([0,0,h/2])
            HtdPulley(teeth,width,0,$fn=50);
            translate([0,0,-0.5])
            bearing(6,12+bearingDiameterAdjust,5);
            translate([0,0,h-4.5])
            bearing(6,12+bearingDiameterAdjust,5);
            cylinder(r=5.75,h=h);
        }
    }
}
else if (display == bottomLink)
{
    BottomOuterSet();
}
else if (display == tetrixTest)
{
    TetrixChannel(96);
}
else
{
    echo("x1=",x1,"  x2=",x2);

    RobotMount();
    rotate([0,-theta/2-firstAngle,0]) 
    translate([tubeLength2+x1+x2,0,-(y1+y2)])
    {
        translate([-tubeLength2/2-x1,0,y1])
        {
            BottomOuterSet();
            rotate([90,0,0])
            HtdBelt(d2,-x2-tubeLength2/2,y2,d1,x1+tubeLength2/2,-y1,15);
        }
        rotate([0,theta+firstAngle,0])
        translate([-tubeLength-2*x1,0,-2*y1])
        {
            translate([tubeLength/2+x1,0,y1])
            {
                SimpleInnerSet();
                Double(tubeOffset/2+9/2+plateMountDy(plateThickness,plateGap)+2.75)
                rotate([90,0,0])
                HtdBelt(d1,-x1-tubeLength/2,-y1,d1,x1+tubeLength/2,y1,9);
            }
            
            rotate([0,-theta,0])
            translate([tubeLength+2*x1,0,-2*y1])
            {    
                translate([-tubeLength/2-x1,0,y1])
                rotate([0,0,180])
                {
                    SimpleOuterSet();
                    rotate([90,0,0])
                    HtdBelt(d1,-x1-tubeLength/2,-y1,d1,x1+tubeLength/2,y1,15);
                }
                rotate([0,theta+lastAngle,0])
                translate([-tubeLength2-x1-x2,0,-y1])
                {
                    translate([tubeLength2/2+x2,0,0])
                    {
                    TopInnerSet();
                    Double(tubeOffset/2+9/2+plateMountDy(plateThickness,plateGap)+2.75)
                    rotate([90,0,0])
                    HtdBelt(d2,-x2-tubeLength2/2,0,d1,x1+tubeLength2/2,y1,9);
                    }
                    
                    rotate([0,-theta/2-lastAngle,0]) 
                    ToolMount();
                    
                }
            }
        }
    }
}

