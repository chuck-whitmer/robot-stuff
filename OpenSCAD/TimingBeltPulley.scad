pi = 3.14159;

Htd5BigR = 1.525;
Htd5LittleR = 0.43;
Htd5PitchLineOffset = 0.5715;
Htd5ToothDepth = 2.06;
widthAdjust = 0.5;
flangeHeight = 2.5;

function HtdPulleyHeight(nTeeth,beltWidth) 
    = 2*flangeHeight+beltWidth+widthAdjust;
    
function HtdPulleyDiameter(nTeeth,beltWidth)
    = nTeeth*5/pi - 2*Htd5PitchLineOffset + 2*flangeHeight;

function HtdPulleyPitchDiameter(nTeeth,beltWidth)
    = nTeeth*5/pi;

module boundary2D(dd)
{
    difference()
    {
        offset(dd) children();
        children();
    }
}

module HtdTimingBelt(n1,x1,y1,n2,x2,y2,width)
{
    d1 = HtdPulleyPitchDiameter(n1,width);
    d2 = HtdPulleyPitchDiameter(n2,width);
    color([0.64,0.45,0.33])
    translate([0,0,-width/2])
    linear_extrude(width)
    boundary2D(2)
    hull()
    {
        translate([x1,y1])
        circle(r=d1/2-1);
        translate([x2,y2])
        circle(r=d2/2-1);
    }
}

module HtdPulley(nTeeth,beltWidth,pipRotation)
{
    // This is specific to the HTD 5mm belt.
    bigR = Htd5BigR;
    littleR = Htd5LittleR;
    pitchLineOffset = Htd5PitchLineOffset;;
    toothDepth = Htd5ToothDepth;
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
    w = outerDiameter+2*flangeHeight;  // Same as HtdPulleyDiameter.
    
    translate([0,0,-h/2])
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

            // Cut out the alignment pips.
            rPipLocation = (w+12)/4;
            adj = 0.2;
            rPip = 2;
            rotate([0,0,pipRotation])
            {
                translate([-rPipLocation,0,h+rPip/2])
                sphere(r=rPip+adj);
                translate([0,-rPipLocation,h+rPip/2])
                sphere(r=rPip+adj);
                translate([0,rPipLocation,h+rPip/2])
                sphere(r=rPip+adj);
                translate([-rPipLocation,0,-rPip/2])
                sphere(r=rPip+adj);
                translate([0,-rPipLocation,-rPip/2])
                sphere(r=rPip+adj);
                translate([0,rPipLocation,-rPip/2])
                sphere(r=rPip+adj);
            }
            translate([0,rPipLocation,h])
            translate(-[1,3*rPip,2]/2)
            cube([1,3*rPip,2]);
            translate([0,rPipLocation,0])
            translate(-[1,3*rPip,2]/2)
            cube([1,3*rPip,2]);
            
        }
        translate([0,0,-0.1])
        cylinder(r=w/2-1.0,h=h+0.2);
        translate([0,0,-w/2+1.5])
        cylinder(r1=0,r2=2*w,h=2*w);
        translate([0,0,h-1.5*w-1.5])
        cylinder(r1=2*w,r2=0,h=2*w);
    }
}

module HtdSimplePulley(nTeeth,beltWidth,$fn=40)
{
    // This is specific to the HTD 5mm belt.
    bigR = Htd5BigR;
    littleR = Htd5LittleR;
    pitchLineOffset = Htd5PitchLineOffset;;
    toothDepth = Htd5ToothDepth;
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
    w = outerDiameter+2*flangeHeight;  // Same as HtdPulleyDiameter.
    
    translate([0,0,-h/2])
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

            
        }
        translate([0,0,-0.1])
        cylinder(r=w/2-1.0,h=h+0.2);
        translate([0,0,-w/2+1.5])
        cylinder(r1=0,r2=2*w,h=2*w);
        translate([0,0,h-1.5*w-1.5])
        cylinder(r1=2*w,r2=0,h=2*w);
    }
}

//$fn=100;
HtdSimplePulley(29,6,$fn=100);
