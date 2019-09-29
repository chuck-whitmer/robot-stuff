in = 25.4;
$fn = 50;

use <TimingBeltPulley.scad>


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
    plateThickness,plateGap,bearingOD,pitchDiameter,flange,tubeAdj,bearingAdj)
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
    
}

module SimpleInnerSet()
{
    Double(tubeOffset/2)
    color("gray")
    tube(tubeId,tubeOd,tubeLength);

    CopyFourWays(tubeLength/2,tubeOffset/2)
    connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,
        pitchDiameter1,flange,tubeAdj,bearingAdj);

    pulleyHeight = HtdPulleyHeight(16,15);
    translate([-x1-tubeLength/2,0,-y1])
    rotate([90,0,0])
    HtdPulley(16,15);    
    translate([x1+tubeLength/2,0,y1])
    rotate([90,0,0])
    HtdPulley(16,15);      
}

module SimpleOuterSet()
{
Double(tubeOffset/2)
color("gray")
tube(tubeId,tubeOd,tubeLength);

CopyFourWays(tubeLength/2,-tubeOffset/2)
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
    
dy = plateMountDy(plateThickness,plateGap);
    echo(dy);
dh = HtdPulleyHeight(16,9);
CopyFourWays(tubeLength/2+x1,0)    
translate([0,tubeOffset/2+dy+dh/2,y1])
rotate([90,0,0])
HtdPulley(16,9);    
    
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

justOneConnector = 0;
theWholeStack = 1;
onePulley = 2;

display = theWholeStack;

if (display == justOneConnector)
{
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
}
else if (display == onePulley)
{
    HtdPulley(16,15);
    echo($fn);
}
else
{
    //theta = 180*$t;
    theta = 20;
    firstAngle = 20;
    
    d1 = HtdPulleyPitchDiameter(16,9);

    rotate([0,-theta/2-firstAngle,0])
    translate([tubeLength+2*x1,0,-2*y1])
    {
        translate([-tubeLength/2-x1,0,y1])
        rotate([0,0,180])
        SimpleOuterSet();
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
                rotate([0,theta,0])
                translate([-tubeLength/2-x1,0,-y1])
                SimpleInnerSet();
            }
        }
    }
}

