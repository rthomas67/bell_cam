// pvc pipe flange
// Need 10 of these (hope there's enough time to print them)

innerDia=45;

receiverThickness=12;
receiverLength=50;

flangeThickness=10;
flangeTaperHeight=6;

flangeWidth=20;

screwHoleCount=6;
screwHoleDia=6;

sideScrewHoleCount=6;
sideScrewHoleDia=4;
sideScrewPositionOffsetAngle=30;
sideScrewHoleOverlap=1;

screwCounterSinkDepth=1;

baseOuterDia=innerDia+receiverThickness*2+flangeWidth*2;
receiverOuterDia=innerDia+receiverThickness*2;

screwHolePositionOffset=receiverOuterDia/2+flangeWidth/2;

$fn=50;
overlap=0.01;

difference() {
    union() {
        // flange
        hull() {
            cylinder(d=baseOuterDia, h=flangeThickness);
            cylinder(d=receiverOuterDia, h=flangeThickness+flangeTaperHeight);
        }
        // receiver
        cylinder(d=receiverOuterDia, h=receiverLength);
    }
    // center
    translate([0,0,-overlap])
        cylinder(d=innerDia, h=receiverLength+overlap*2);
    
    // flange screw holes
    for (zRotation=[0:360/screwHoleCount:359]) {
        rotate([0,0,zRotation])
            translate([screwHolePositionOffset,0,0]) {
                translate([0,0,-overlap])
                    union() {
                        cylinder(d=screwHoleDia,h=flangeThickness+overlap*2);
                        translate([0,0,flangeThickness-screwCounterSinkDepth])
                            cylinder(d=screwHoleDia*2,h=screwCounterSinkDepth+flangeTaperHeight);
                    }
            }
    }
    // side screw holes
    for (zRotation=[0:360/sideScrewHoleCount:359]) {
        rotate([0,0,zRotation+sideScrewPositionOffsetAngle])
            translate([innerDia/2-sideScrewHoleOverlap,0,receiverLength*2/3])
                rotate([0,90,0]) {
                    cylinder(d=sideScrewHoleDia,h=receiverThickness+sideScrewHoleOverlap*2);
                }
    }
        
}