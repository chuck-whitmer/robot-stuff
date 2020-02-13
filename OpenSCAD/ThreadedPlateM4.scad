$fn=50;

// hexagon - A 2D hexagon with flat to flat diameter w. Flats are parallel to x axis.
module hexagon(w)
{
    s = w/sqrt(3);
    polygon([[-s/2,w/2],[s/2,w/2],[s,0],[s/2,-w/2],[-s/2,-w/2],[-s,0]]);
}

// hexagonalPrism - An extrusion of the hexagon. Has an optional drop below the xy plane.
module hexagonalPrism(w, h)
{
    linear_extrude(h)
    hexagon(w);
}

module roundRect(x, y, z, r)
{
    linear_extrude(z,convexity=1)
    translate([r,r])
    offset(r)
    square([x-2*r,y-2*r]);
}

module NutHolder(xsize,ysize,xlist,ylist,xtrim=0,ytrim=0,rotation=0)
{
    difference()
    {
        translate([xtrim,ytrim])
        roundRect(xsize-2*xtrim,ysize-2*ytrim,2.5,2.5);
        for (x=xlist) for (y=ylist)
            translate([x,y,-0.1])
            rotate([0,0,rotation])
            hexagonalPrism(7,3);
    }
    
    
    
}

module ThreadedPlate(xsize,ysize,xlist,ylist,xtrim=0,ytrim=0)
{
    difference()
    {
        translate([xtrim,ytrim])
        roundRect(xsize-2*xtrim,ysize-2*ytrim,5,2.5);
        for (x=xlist) for (y=ylist)
        {
            translate([x,y,2])
            hexagonalPrism(7,4);
            translate([x,y,-0.1])
            cylinder(r=2,h=4);
        }
    }
    
    
    
}

module LargeFourHoleThreadedPlate()
{
    difference()
    {
        ThreadedPlate(48,48,[8,40],[8,40],3,3);
        translate([24,24,-0.1])
        cylinder(r=16,h=6);
    }
}

module SimpleThreadedPlate(n,m)
{
    ThreadedPlate(8*n,8*m,[for (i=[0:n]) 8*i+4],[for (i=[0:m]) 8*i+4],0,0);
}

SimpleThreadedPlate(2,2);

//LargeFourHoleThreadedPlate();
