in = 25.4;
$fn = 50;

carbonTube1 = [0.314*in,0.393*in,"McMaster"];

myTube = carbonTube1;
tubeId = myTube[0];
tubeOd = myTube[1];
tubeLen = 12*in;


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

module connector(tubeOd,sheathThickness,length,plateThickness,gap,bearing,disk,adj)
{
    // Two concepts: plateGap for gap between the disks. foldGap for the distance between tubes when folded.
    holeTranslation = [tubeOd/2+sheathThickness+gap/2,-gap/2,length+gap/2+disk/2];
    rotate([0,90,0])
    {
        difference()
        {
            union()
            {
                cylinder(r=tubeOd/2+sheathThickness, h=length);
                translate([holeTranslation[0],holeTranslation[1],0])
                rotate([90,0,0])
                linear_extrude(plateThickness)
                hull()
                {
                    translate([-1.5*gap-tubeOd,length-1.4*gap])
                    square(gap);
                    translate([0,holeTranslation[2]])
                    circle(disk/2);
                }
            }
            translate(holeTranslation)
            rotate([90,0,0])
            translate([0,0,-0.1])
            cylinder(r=bearing/2,h=plateThickness+0.2);
            translate([0,0,-0.1])
            cylinder(r=tubeOd/2+adj, h=length+0.2);
        }
    }
}

connectorThickness = 0.1*in;
connectorPlateThickness = 4;
connectorPlateSide = 2*in;
connectorPlateOverlap = 0.2*in;
connectorAdj = 0.2;
connectorGap = 0.1*in;
connectorLength = (connectorPlateSide - connectorGap)/2;
bearingHole = 6;  // was 12
connectorDisk = 28;


/*

color("gray")
tube(tubeId,tubeOd,tubeLen);
*/


translate([-connectorPlateSide/2,0,0])
connector(tubeOd,connectorThickness,connectorLength,connectorPlateThickness,connectorGap,bearingHole,connectorDisk,connectorAdj);

rotate([0,0,180])
translate([-connectorPlateSide/2 - connectorDisk,0,0])
connector(tubeOd,connectorThickness,connectorLength,connectorPlateThickness,connectorGap,bearingHole,connectorDisk,connectorAdj);


