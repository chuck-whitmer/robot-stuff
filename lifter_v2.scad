in = 25.4;
pi = 3.14159;
$fn = 50;

use <TimingBeltPulley.scad>

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
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
}

module SimpleOuterSet()
{
Double(tubeOffset/2)
color("gray")
tube(tubeId,tubeOd,tubeLength);

CopyFourWays(tubeLength/2,-tubeOffset/2)
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
}


module HtdPulley(nTeeth,beltWidth)
{
    // This is specific to the HTD 5mm belt.
    bigR = 1.525;
    littleR = 0.43;
    pitchLineOffset = 0.5715;
    toothDepth = 2.06;
    widthAdjust = 0.5;
    flangeHeight = 2.5;
    boreRadius = 3.1;

    outerDiameter = nTeeth*5/pi - 2*pitchLineOffset; 
    segmentAngle = 360/nTeeth;
    
    // The bigR circle (tooth cutout) is tangent to the outside of a 
    // circle of radius (outerDiamter/2-toothDepth).
    // The littleR circle (notch roundoff) is tangent to the inside
    // of the outerDiamter circle.
    // Calculate the radius of the point where these two are tangent.
    A = outerDiameter/2 + bigR - toothDepth;
    C = outerDiameter/2 - littleR;
    B = littleR + bigR; // The distance the circle centers are apart when tangent.
    // If you travel out from the pulley center towards the center of the big cutout,
    // and then turn to head to the center of the little circle, then phi is the amount of the turn.
    cosPhi = (A*A + B*B - C*C)/(2*A*B);
    rOfTangent = sqrt(A*A + bigR*bigR - 2*A*bigR*cosPhi);
    // And what is the center angle between the big and little circles?
    sinPhi = sqrt(1.0 - cosPhi*cosPhi);
    theta = asin(sinPhi/C*B);
    h = 2*flangeHeight+beltWidth+widthAdjust;
    w = outerDiameter+2*flangeHeight;
    
    intersection()
    {
        difference()
        {
            union()
            {
                translate([0,0,flangeHeight])
                rotate([0,0,segmentAngle/2])
                linear_extrude(beltWidth+widthAdjust)
                difference()
                {
                    union()
                    {
                        for (i=[0:nTeeth-1])
                        {
                            rotate([0,0,i*segmentAngle])
                            hull()
                            {
                                rotate([0,0,-theta])
                                translate([0,C])
                                circle(littleR);
                                rotate([0,0,theta-segmentAngle])
                                translate([0,C])
                                circle(littleR);
                            }
                        }
                        circle(r=rOfTangent);
                    }
                    for (i=[0:nTeeth-1])
                    {
                        rotate([0,0,i*segmentAngle])
                        translate([0,A])
                        circle(r=bigR);
                    }
                }
                // Add the flanges.
                cylinder(r1=w/2,r2=outerDiameter/2,h=flangeHeight+0.1);
                translate([0,0,h])
                mirror([0,0,1])
                cylinder(r1=w/2,r2=outerDiameter/2,h=flangeHeight+0.1);
            }
            translate([0,0,-0.1])
            cylinder(r=boreRadius,h=h+0.2);
            
            // Alignment cutouts.
            translate([0,A-2,0])
            translate([-1,-2,-1])
            cube([2,4,2]);
            translate([0,-(A-2),0])
            translate([-1,-2,-1])
            cube([2,4,2]);
            translate([0,A-2,h])
            translate([-1,-2,-1])
            cube([2,4,2]);
            translate([0,-(A-2),h])
            translate([-1,-2,-1])
            cube([2,4,2]);
        }
        translate([0,0,-0.1])
        cylinder(r=w/2-1.0,h=h+0.2);
        translate([0,0,-w/2+1.5])
        cylinder(r1=0,r2=2*w,h=2*w);
        translate([0,0,h-1.5*w-1.5])
        cylinder(r1=2*w,r2=0,h=2*w);
    }
}





carbonTube1 = [0.314*in,0.393*in,"McMaster"];

myTube = carbonTube1;
tubeId = myTube[0];
tubeOd = myTube[1];
tubeLength = 6.75*in;
tubeOffset = 2.0*in;

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

justOneConnector = 0;
theWholeStack = 1;
onePulley = 2;

display = onePulley;

if (display == justOneConnector)
{
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
}
else if (display == theWholeStack)
{
    SimpleInnerSet();
    translate([0,0,2*y1])
    rotate([0,0,180])
    SimpleOuterSet();
}
else
{
    HtdPulley(16,15);
}



