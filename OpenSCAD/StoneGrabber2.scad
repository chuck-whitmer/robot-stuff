$fn=50;
use <tetrix_holes.scad>

in = 25.4;

backingToBarCenter = 60.0;
barDiameter = 7.5;
loopOpening = 6.75*in;
filetRadius = 7.5;

baseWidth = 64;
baseHeight = 28;
baseThickness = 5;

df = 1.0; // debug factor

module pipe(ptA,ptB,r)
{
    dx = ptB[0] - ptA[0];
    dy = ptB[1] - ptA[1];
    d = sqrt(dx*dx+dy*dy);
    translate([ptA[0],ptA[1],0])
    rotate([0,90,ptA[2]])
    cylinder(r=r,h=d);
}

module pipeBend(pt,angle,pipeRadius,turnRadius)
{
    rot = (angle>=0) ? [0,0,-90+pt[2]] : [0,0,90+pt[2]];
    translate([pt[0],pt[1],0])
    rotate(rot)
    translate([-turnRadius,0,0])
    rotate_extrude(angle=angle)
    translate([turnRadius,0])
    circle(r=pipeRadius);
}

function normalizeAngle(a) = a - floor((a+180)/360)*360;


module pipeJoin(ptA,ptB,pipeRadius,turnRadius)
{
    r = pipeRadius;
    fr = turnRadius;
    hA = ptA[2];
    hB = ptB[2];
    ss = sin(hB-hA); // - for right turn, + for left.
    // Points C and D are centers of turing radii.
    cx = (ss > 0) ? ptA[0]+fr*cos(hA+90) : ptA[0]+fr*cos(hA-90);
    cy = (ss > 0) ? ptA[1]+fr*sin(hA+90) : ptA[1]+fr*sin(hA-90);
    dx = (ss > 0) ? ptB[0]+fr*cos(hB+90) : ptB[0]+fr*cos(hB-90);
    dy = (ss > 0) ? ptB[1]+fr*sin(hB+90) : ptB[1]+fr*sin(hB-90);
    deltaX = dx - cx;
    deltaY = dy - cy;
    h = atan2(deltaY,deltaX);
    diffA = normalizeAngle(h-hA);
    pipeBend(ptA,diffA,r,fr);
    ptD = traverseBend(ptA,diffA,fr);
    ball(ptD,r);
    l = sqrt(deltaX*deltaX+deltaY*deltaY);
    ptE = traverse(ptD,l);
    ball(ptE,r);
    pipe(ptD,ptE,r);
    diffB = normalizeAngle(hB-h);
    pipeBend(ptE,diffB,r,fr);
}

module ball(pt,r)
{
    translate([pt[0],pt[1],0])
    sphere(r=r);
}

function traverse(pt,d) = [pt[0]+d*cos(pt[2]),pt[1]+d*sin(pt[2]),pt[2]];

function traverseBend(pt,angle,turnRadius)
  = let (d=abs(2*turnRadius*sin(angle/2)), effectiveHeading=pt[2]+angle/2)
    [pt[0]+d*cos(effectiveHeading),pt[1]+d*sin(effectiveHeading),pt[2]+angle];

function reverseDirection(pt) = [pt[0],pt[1],pt[2]+180];

//----------------//

rotate([-90,0,0])
difference()
{
  translate([-baseWidth/2,-baseHeight/2,0])
  cube([baseWidth,baseHeight,baseThickness]);
  translate([-16,0,0])
  littleHoles(2);
  translate([16,0,0])
  littleHoles(2);
}

r = barDiameter/2;
fr = filetRadius;

L1 = loopOpening-2*(fr-r);
L2 = backingToBarCenter/2 - 2*filetRadius;

point0 = [-L1/2,backingToBarCenter,0];
point1 = traverse(point0,L1);
point2 = traverseBend(point1,-90,fr);
point3 = traverse(point2,L2);

ball(point0,r);
pipe(point0,point1,r);
ball(point1,r);
pipeBend(point1,-90,r,fr);
ball(point2,r);
pipe(point2,point3,r);
ball(point3,r);

point4 = [baseWidth/2,barDiameter/2,-180];
point5 = [baseWidth/2-10,barDiameter/2,-180];
pipe(point4,point5,r);
ball(point4,r);
ball(point5,r);

pipeJoin(point3,point4,r,fr);

point1p = reverseDirection(point0);
point2p = traverseBend(point1p,90,fr);
point3p = traverse(point2p,L2);

pipeBend(point1p,90,r,fr);
ball(point2p,r);
pipe(point2p,point3p,r);
ball(point3p,r);

point4p = [-baseWidth/2,barDiameter/2,0];
point5p = [-baseWidth/2+10,barDiameter/2,0];
pipe(point4p,point5p,r);
ball(point4p,r);
ball(point5p,r);

pipeJoin(point3p,point4p,r,fr);





