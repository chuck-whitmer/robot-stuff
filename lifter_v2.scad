in = 25.4;
$fn = 50;



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

carbonTube1 = [0.314*in,0.393*in,"McMaster"];

myTube = carbonTube1;
tubeId = myTube[0];
tubeOd = myTube[1];
tubeLength = 11.625*in;
tubeOffset = 2.0*in;

sheathWall = 2.5;
sheathLength = 1.0*in;
stackGap = 1.0;
flange = 0.1*in;
plateGap = 0.1*in;
plateThickness = 4; // Matches the bearing.
bearingOD = 6;
bearingAdj = 0.2;
tubeAdj = 0.1;

R1 = 13.190*in;  // 5mm HTD 150, 16 to 16 tooth
pitchDiameter1 = 1.0026*in;
y1 = -(tubeOd/2 + sheathWall + stackGap/2);
x1 = (sqrt(R1*R1-4*y1*y1)-tubeLength)/2;

justOne = 0;

if (justOne)
{
connector(tubeOd,sheathWall,sheathLength,x1,y1,plateThickness,plateGap,bearingOD,pitchDiameter1,flange,tubeAdj,bearingAdj);
}
else
{
    SimpleInnerSet();
    translate([0,0,2*y1])
    rotate([0,0,180])
    SimpleOuterSet();
}




