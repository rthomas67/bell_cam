// Crank cam

camFollowerWidth=45;

// Temp override
camFollowerWidth=5;

camFollowerRadius=20;

axleDia=44;

camCoreThickness=15;  // 2 * this plus axleDia == "base circle"
camLobeHeight=30;
camCutDia=80;
camOuterDia=axleDia+camCoreThickness*2+camLobeHeight*2;


numberOfLobes=3;


$fn=50;
overlap=0.01;


difference() {
    cylinder(d=camOuterDia, h=camFollowerWidth);
    // axle
    translate([0,0,-overlap])
        cylinder(d=axleDia, h=camFollowerWidth+overlap*2);
    for (zRotation=[0:360/numberOfLobes:359]) {
        rotate([0,0,zRotation])
            translate([camOuterDia/2,camCutDia/2,-overlap])
                camCut();
    }
}

module camCut() {
    cylinder(d=camCutDia, h=camFollowerWidth+overlap*2);
}

