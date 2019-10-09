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

    difference()
    {
        union()
        {
            // Construct the sheath.
            rotate([0,-90,0])
            cylinder(r=tubeOD/2+sheathWall,h=sheathLength);

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
    }
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

module ToolConnector(shift,plateThickness,rotation)
{
    pd32 = HtdPulleyDiameter(32,9);
    pd16 = HtdPulleyDiameter(16,9);
    middleR = (pd32+pd16)/4 -1.5;
    
    rotate([90,0,0])
    difference()
    {  
        translate([0,0,-plateThickness/2])
        linear_extrude(plateThickness)
        hull()
        {
            circle(r=pd32/2);
            translate([-shift,0])
            circle(r=14);
        }
        translate([-shift,0,0])
        holes(8);
        translate([0,0,-5])
        {
            cylinder(r=bearingOD/2+bearingAdj,h=10);
            rotate([0,0,rotation])
            {
                translate([-middleR,0,0])
                cylinder(r=2.1,h=10);
                translate([0,middleR,0])
                cylinder(r=2.1,h=10);
                translate([0,-middleR,0])
                cylinder(r=2.1,h=10);
            }
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
    plateThickness = pulleyFaceY-16;
    translate([0,16+plateThickness/2,0])
    ToolConnector(39,plateThickness,rotation);
    translate([0,-16-plateThickness/2,0])
    ToolConnector(39,plateThickness,rotation);
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

sheathWall = 2.5;
sheathLength = 1.0*in;
stackGap = 1.0;
flange = 0.1*in;
plateGap = 0.1*in;
plateThickness = 4; // Matches the bearing.
bearingOD = 6;
bearingAdj = 0.1; // 0 too tight. 0.2 a tiny bit loose. (Rough settings.)
tubeAdj = 0.1;

// R1 = 13.190*in;  // 5mm HTD 150, 16 to 16 tooth
R1 = 8.2687*in;  // 5mm HTD 100, 16 to 16 tooth
pitchDiameter1 = 1.0026*in;
y1 = -(tubeOd/2 + sheathWall + stackGap/2);
x1 = (sqrt(R1*R1-4*y1*y1)-tubeLength)/2;

plateDy = plateMountDy(plateThickness,plateGap);
tubeOffset = 2*plateDy + HtdPulleyHeight(16,15);

// Bottom and top connectors.
R2 = 9.4365*in; // HTD 120, 16 to 32 tooth
pitchDiameter2 = 2.0051*in;
tubeLength2 = 7.5*in;

y2 = 0;
x2 = R2 - tubeLength2 - x1;

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

//display = bottomLink;
//display = theWholeStack;
//display = tetrixTest;
//display = onePulley;
display = justOneConnector;

if (display == justOneConnector)
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
    
    
    // 1Ua
    w = HtdPulleyDiameter(16,9);
    mirror([0,0,1])
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,
      7,pitchDiameter1,flange,tubeAdj,bearingAdj,-firstAngle,(w+12)/4);
}
else if (display == onePulley)
{
    teeth = 16;
    width = 9;
    h = HtdPulleyHeight(teeth,width);
    
    difference()
    {
        translate([0,0,h/2])
        HtdPulley(teeth,width,0,$fn=50);
        translate([0,0,-1])
        bearing(6,12,5);
        translate([0,0,h-4])
        bearing(6,12,5);
        cylinder(r=5.75,h=h);
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

