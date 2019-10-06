module hexagon(w)
{
    s = w/sqrt(3);
    polygon([[-s/2,w/2],[s/2,w/2],[s,0],[s/2,-w/2],[-s/2,-w/2],[-s,0]]);
}

module hexagonalPrism(w,h)
{
    linear_extrude(height=h)
    hexagon(w);
}
