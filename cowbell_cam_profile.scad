// Crank cam

camFollowerWidth=45;

// Temp override
//camFollowerWidth=2;

camFollowerRadius=20;

axleDia=34;

crossHoleDia=6;
crossHoleCountersinkDepth=4;
adjustCountersinkForFn4=16;

crossHolePrecessionAngle1=30;

camCoreThickness=30;  // 2 * this plus axleDia == "base circle"
camLobeHeight=18;
camLobeSmoothnessRadius=5;
camOuterDia=axleDia+camCoreThickness*2;

camLobeBackCutDia=65;
camLobeBackCutPrecessAngle=40;
camLobeBackCutAspectRatio=3;  // how wide to stretch the cut

numberOfLobes=3;

axleTaperHeight=6;
axleTaperFactor=1.04;


$fn=50;
overlap=0.01;

//import("cowbell_cam_profile_v3.stl");

difference() {
   union() {
        cylinder(d=camOuterDia, h=camFollowerWidth,$fn=numberOfLobes);
        for (zRotation=[0:360/numberOfLobes:359]) {
            rotate([0,0,zRotation])
                translate([camOuterDia/2-camLobeHeight,-camLobeHeight/2,-overlap])
                    camLobe();
        }
    }
    // axle
    translate([0,0,-overlap])
        cylinder(d=axleDia, h=camFollowerWidth+overlap*2);
    // taper out at print-bed to compensate for abs warp
    translate([0,0,-overlap])
        cylinder(d1=axleDia*axleTaperFactor, d2=axleDia, h=axleTaperHeight);

//    for (zRotation=[0:360/numberOfLobes:359]) {
//        rotate([0,0,zRotation+camLobeBackCutPrecessAngle])
//            translate([0,camOuterDia/2+camLobeHeight,-overlap])
//                scale([3,1,1])
//                cylinder(d=camLobeBackCutDia, h=camFollowerWidth+overlap*2);
//    }
    // countersunk cross holes for bolt to lock into the pvc "axle"
    translate([0,0,camFollowerWidth/4]) rotate([0,0,crossHolePrecessionAngle1])
        crossHole();
    translate([0,0,camFollowerWidth*3/4]) rotate([0,0,-crossHolePrecessionAngle1])
        crossHole();
}

module crossHole() {
    rotate([0,90,0])
        union() {
            cylinder(d=crossHoleDia, h=camOuterDia, center=true);
            translate([0,0,camOuterDia/2-crossHoleCountersinkDepth-adjustCountersinkForFn4])
                cylinder(d=crossHoleDia*2, h=crossHoleCountersinkDepth*2);
            translate([0,0,-camOuterDia/2-crossHoleCountersinkDepth+adjustCountersinkForFn4])
                cylinder(d=crossHoleDia*2, h=crossHoleCountersinkDepth*2);
        }
}
module camLobe() {
    translate([camLobeSmoothnessRadius,camLobeSmoothnessRadius,camLobeSmoothnessRadius])
    minkowski() {
        cube([camLobeHeight*2-camLobeSmoothnessRadius*2,
            camLobeHeight-camLobeSmoothnessRadius*2,
            camFollowerWidth-camLobeSmoothnessRadius*2]);
        sphere(r=camLobeSmoothnessRadius);
    }
}

