$fn=50;

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

module hole(r, h, drop)
{
    translate([0,0,-drop])
    cylinder(r=r,h=h+drop);
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

smallR = 4.2/2; // Nominal 3.7 mm.  4.2 works on TAZ. For #6-32 holes
screwHeadDiameter = 6.5;  // Nominal 6.0 mm.
screwHeadHeight = 4.0;
lockNutHexFlat = 7.94 + 0.41;  // Flat to flat diameter for 5/16" nut = 7.94 mm.
                        // On Prusa this came out as a 7.5 opening.
lockNutHeight = 4.6;                 

module nutHolder(h, b, d) // height, backing, drop
{
    if (b != 0)
    {
        translate([0,0,b])
            hexagonalPrism(lockNutHexFlat, h, 0);
        hole(smallR, height, d);
    }
    else
    {
        hexagonalPrism(lockNutHexFlat, h+d, d);
    }
}

// The model


length = 78.0;
width = 26.5;  // Nominal is 27.0
backing = 2.0;
height = lockNutHeight + backing - 1.0;
holeSeparationX = 64.0;
holeSeparationY = 16.0;

difference()
{
    roundRect(length, width, height, 4, 0);
    
    union()
    {
        translate([-holeSeparationX/2,-holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        translate([holeSeparationX/2,-holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        translate([-holeSeparationX/2,holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        translate([holeSeparationX/2,holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        translate([0,-holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        translate([0,holeSeparationY/2,0])
            nutHolder(height, backing, 0.1);
        
        
    }
    
}



