$fn=100;
in=25.4;

r0 = 0.1*in;
x0 = (1.5 + 0.1)*in;
y0 = 0.135*in;

r1=0.712*in;
x1=(2.5-3/16-1/4)*in;
y1=3/8*in-r1;

r2=3/16*in;
x2=(2.5-3/16)*in;
y2=3/8*in-r2;

rotate_extrude(angle=360)
hull()
{
    translate([x0,y0])
    circle(r0);
    translate([x0,-y0])
    circle(r0);
    translate([x2,y2])
    circle(r2);
    translate([x2,-y2])
    circle(r2);

    intersection()
    {
        translate([2*in,0])
        square([0.9*in,1*in],center=true);    
        translate([x1,y1])
        circle(r1);
        translate([x1,-y1])
        circle(r1);
    }
}