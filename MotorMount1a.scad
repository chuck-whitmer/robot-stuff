$fn=50;

length = 91.0;
width = 27.0;
height = 12.0;
holeSeparation = 64.0;
slotSeparation = 16.0;
hexFlat = 7.94 + 0.41;  // Flat to flat diameter for 5/16" nut = 7.94 mm.
                 // On Prusa this came out as a 7.5 opening.
lockNutHeight = 4.6;                 
hexChannel = 9.0; // Height of a channel for the locknut.
screwHeadDiameter = 6.5;  // Nominal 6.0 mm.
screwHeadHeight = 4.0;
slotLength = 32;
slotGap = 16;
smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ. For #6-32 holes

// slot - A rounded slot framed by two cylinders of diameter w a distance l apart.
//  It is assumed that this is mostly used for subtraction. 
//  The drop makes it extend below the xy plane for robust subtraction.
module slot(l, w, h, drop)
{
    translate([l/2,0,-drop])
        cylinder(r=w/2,h=h+drop);
    translate([-l/2,0,-drop])
        cylinder(r=w/2,h=h+drop);
    translate([0,0,(h-drop)/2])
        cube([l, w, h+drop], center=true);
}

// hexagon - A 2D hexagon with flat to flat diameter w. Flats are parallel to x axis.
module hexagon(w)
{
    s = w/sqrt(3);
    polygon([[-s/2,w/2],[s/2,w/2],[s,0],[s/2,-w/2],[-s/2,-w/2],[-s,0]]);
}

// hexagonalPrism - An extrusion of the hexagon. Has an optional drop below the xy plane.
module hexagonalPrism(w, h, drop)
{
    translate([0,0,-drop])
    linear_extrude(height=h+drop)
    hexagon(w);
}

// roundRect - Actually a rounded rectangular prism. Makes a cube of dimension x,y,z, but
//   centered on the z axis and sitting on the xy plane. Vertical corners are rounded
//   with radius r. Allows an optional drop below the xy plane.
module roundRect(x, y, z, r, drop)
{
    union()
    {
        translate([0,0,(z-drop)/2])
        {
            cube([x-2*r,y,z+drop],center=true);
            cube([x,y-2*r,z+drop],center=true);
        }
        translate([-(x/2-r),-(y/2-r),-drop])
            cylinder(r=r,h=z+drop);
        translate([-(x/2-r),(y/2-r),-drop])
            cylinder(r=r,h=z+drop);
        translate([(x/2-r),-(y/2-r),-drop])
            cylinder(r=r,h=z+drop);
        translate([(x/2-r),(y/2-r),-drop])
            cylinder(r=r,h=z+drop);
    }
}

// A module specific to this problem.

module slotWithHead()
{
    slot(slotLength, 2*smallR, 20, 0.1);
    translate([0,0,height-screwHeadHeight])
        slot(slotLength, screwHeadDiameter, 20, 0);
}

difference()
{
    roundRect(length, width, height, 4, 0);

    {
        // Slots for screws
        translate([-(slotGap+slotLength)/2,slotSeparation/2,0])
            slotWithHead();
        translate([-(slotGap+slotLength)/2,-slotSeparation/2,0])
            slotWithHead();
        translate([(slotGap+slotLength)/2,slotSeparation/2,0])
            slotWithHead();
        translate([(slotGap+slotLength)/2,-slotSeparation/2,0])
            slotWithHead();
                
        // Motor mount holes with locknut channels.
        translate([-holeSeparation/2,0,0])
        {
            cylinder(r=smallR, h=height+0.1);
            hexagonalPrism(hexFlat, hexChannel, 0.1);
        }
        translate([holeSeparation/2,0,0])
        {
            cylinder(r=smallR, h=height+0.1);
            hexagonalPrism(hexFlat, hexChannel, 0.1);
        }
        
        // An additional slot to save mass.
        slot(32,3,20,.1);
    }
}
