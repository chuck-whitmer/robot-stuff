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
        cylinder(r=od,h=length);
        translate([0,0,-0.1])
        cylinder(r=id,h=length+0.2);
    }
}

module connector(tubeOd,tubeWall,thickness,length,plateThickness,plateSide,gap,adj)
{
    rotate([0,90,0])
    {
        difference()
        {
            union()
            {
                difference()
                {
                    cylinder(r=tubeOd+thickness, h=length);
                    translate([0,0,-0.1])
                    cylinder(r=tubeOd+adj, h=length+0.2);
                    
                }
                translate([tubeOd+adj,-(thickness+gap/2),0])
                cube([plateSide,plateThickness,length]);
                translate([plateSide/2+tubeOd+tubeWall/2,-gap/2,length+gap/2])
                rotate([90,0,0])
                cylinder(r=(plateSide-tubeWall)/2-gap/2,h=plateThickness);
            }
            translate([plateSide/2+tubeOd+tubeWall/2,-gap/2,length+gap/2])
            rotate([90,0,0])
            translate([0,0,-0.1])
            cylinder(r=1.125*in/2,h=plateThickness+0.2);
        }
    }
}

connectorThickness = 0.1*in;
connectorPlateThickness = 0.1*in;
connectorPlateSide = 2*in;
connectorPlateOverlap = 0.2*in;
connectorAdj = 0.2;
connectorGap = 0.1*in;
connectorLength = (connectorPlateSide - connectorGap)/2;

tubeWall = tubeOd - tubeId;

/*
translate([tubeLen/2-connectorLength,0,0])
connector(tubeOd,connectorThickness,connectorLength,connectorPlateThickness,connectorPlateSide,connectorGap,connectorAdj);

color("gray")
tube(tubeId,tubeOd,tubeLen);
*/


translate([-connectorPlateSide/2,0,0])
connector(tubeOd,tubeWall,connectorThickness,connectorLength,connectorPlateThickness,connectorPlateSide,connectorGap,connectorAdj);


rotate([0,0,180])
translate([-connectorPlateSide/2,0,0])
connector(tubeOd,tubeWall,connectorThickness,connectorLength,connectorPlateThickness,connectorPlateSide,connectorGap,connectorAdj);


