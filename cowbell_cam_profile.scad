// Crank cam

camFollowerWidth=45;

// Temp override
camFollowerWidth=2;

camFollowerRadius=20;

axleDia=34;

camCoreThickness=45;  // 2 * this plus axleDia == "base circle"
camLobeHeight=20;
camOuterDia=axleDia+camCoreThickness*2+camLobeHeight*2;

camLobeBackCutDia=65;
camLobeBackCutPrecessAngle=40;
camLobeBackCutAspectRatio=3;  // how wide to stretch the cut


numberOfLobes=4;


$fn=50;
overlap=0.01;

difference() {
    union() {
        cylinder(d=camOuterDia, h=camFollowerWidth);
        for (zRotation=[0:360/numberOfLobes:359]) {
            rotate([0,0,zRotation])
                translate([0,camOuterDia/2-camLobeHeight,-overlap])
                    camLobe();
        }
    }
    // axle
    translate([0,0,-overlap])
        cylinder(d=axleDia, h=camFollowerWidth+overlap*2);
    for (zRotation=[0:360/numberOfLobes:359]) {
        rotate([0,0,zRotation+camLobeBackCutPrecessAngle])
            translate([0,camOuterDia/2+camLobeHeight,-overlap])
                scale([3,1,1])
                cylinder(d=camLobeBackCutDia, h=camFollowerWidth+overlap*2);
    }
}

module camLobe() {
        cube([camLobeHeight*2,camLobeHeight*2,camFollowerWidth]);
}

