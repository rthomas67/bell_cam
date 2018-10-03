// cowbell cam follower pivot
allParts=false;
topPart=true;

//import("cowbell_cam_follower_bottom_part_v1.stl");
//import("cowbell_cam_follower_top_part_v1.stl");

camFollowerTipWidth=15;
camFollowerTipHeight=30;
followerSmoothnessRadius=2;

pivotInsideDia=44;

pivotWallThickness=10;

pivotOutsideDia=pivotInsideDia+pivotWallThickness*2;

camFollowerWidth=45;

// test-print override
// camFollowerWidth=5;



boltHoleDia=6;
boltHoleCountersinkDepth=1;
boltHoleCountersinkAdjust=7;

cowbellHangerThickness=16;
cowbellHangarMetalThickness=2;
cowbellHangarCreaseAngle=2; // degrees up from middle on each side (applied 2x)

cowbellHangarOpeningHeight=20;

cowbellHandleBlockOverHangThickness=15;
cowbellHandleBlockThickness=cowbellHangerThickness+2*cowbellHandleBlockOverHangThickness;


// Used to create a block that supports/braces the top of the bell a bit
cowbellTopOverHangDepth=14;
cowbellTopFlatThickness=22;
cowbellTopCornerRadius=5;
cowbellTopThickness=cowbellTopFlatThickness+cowbellTopCornerRadius*2;

bottomPartBlockExtraHeight=6;
bottomPartBlockExtraOffset=3;

overlap=0.01;
$fn=50;

// TODO: create two other objects that are cut pieces of this one.
if (allParts) {
    wholeCamFollower();
} else if (topPart) {
    difference() {
        wholeCamFollower();
        bottomPartBlock();
    }
} else {
    intersection() {
        wholeCamFollower();
        bottomPartBlock();
    }
}

module bottomPartBlock() {
    translate([0,-pivotOutsideDia-bottomPartBlockExtraOffset,-overlap])
        cube([cowbellHandleBlockThickness,
            cowbellHangarOpeningHeight+cowbellTopOverHangDepth+bottomPartBlockExtraHeight,
                camFollowerWidth+overlap*2]);
}

module wholeCamFollower() {
    union() {
        difference() {
            hull() {
                // cam follower tip
                // Note: This is adjusted to account for the minkowski added size.
                translate([-pivotOutsideDia/2+followerSmoothnessRadius,
                        pivotOutsideDia/2-followerSmoothnessRadius,
                        followerSmoothnessRadius])
                    minkowski() {
                        cube([camFollowerTipWidth-followerSmoothnessRadius*2,
                            camFollowerTipHeight-followerSmoothnessRadius*2,
                            camFollowerWidth-followerSmoothnessRadius*2]);
                        sphere(r=followerSmoothnessRadius);
                    }
                // pivot
                cylinder(d=pivotOutsideDia, h=camFollowerWidth);
                // block to hold the cowbell
                translate([-cowbellHandleBlockThickness/2,-pivotOutsideDia/2-cowbellHangarOpeningHeight,0])
                    cube([cowbellHandleBlockThickness,cowbellHangarOpeningHeight,camFollowerWidth]);
                
            }
            // pivot opening
            translate([0,0,-overlap])
                cylinder(d=pivotInsideDia, h=camFollowerWidth+overlap*2);
            // slot for hanger to pass through (this is slightly creased into a subtle V shape)
            // Note Rotations are done such that the top corner overlaps the axis, so it makes no gap.
            translate([0,-pivotOutsideDia/2-cowbellHangarMetalThickness,-overlap])
                rotate([0,0,cowbellHangarCreaseAngle])
                    cube([cowbellHangerThickness/2,cowbellHangarMetalThickness,camFollowerWidth+overlap*2]);
            translate([-cowbellHangerThickness/2,-pivotOutsideDia/2-cowbellHangarMetalThickness,-overlap])
                // rotation is done from other side by translate->rotate->translateBack
                translate([cowbellHangerThickness/2,0,0]) 
                        rotate([0,0,-cowbellHangarCreaseAngle]) 
                        translate([-cowbellHangerThickness/2,0,0])
                    cube([cowbellHangerThickness/2,cowbellHangarMetalThickness,camFollowerWidth+overlap*2]);
            
            if (camFollowerWidth > boltHoleDia*4) {
                // bolt hole 1
                translate([0,
                        -pivotOutsideDia/2-cowbellHangarOpeningHeight/2,
                        camFollowerWidth/6])
                    boltHoleCut();
                // bolt hole 3
                translate([0,
                        -pivotOutsideDia/2-cowbellHangarOpeningHeight/2,
                        camFollowerWidth/2])
                    boltHoleCut();
                // bolt hole 3
                translate([0,
                        -pivotOutsideDia/2-cowbellHangarOpeningHeight/2,
                        camFollowerWidth*5/6])
                    boltHoleCut();
            }
            
        }
        translate([0,-pivotOutsideDia/2-cowbellHangarOpeningHeight-cowbellTopOverHangDepth,0])
            bellTopBraceBlock();
    }
}

module boltHoleCut() {
    rotate([0,90,0])
    union() {
        cylinder(d=boltHoleDia, h=pivotOutsideDia+overlap*2, center=true);
        // top countersink
        translate([0,0,pivotOutsideDia/2-boltHoleCountersinkDepth-boltHoleCountersinkAdjust])
            cylinder(d=boltHoleDia*2, h=boltHoleCountersinkDepth*2);
        // bottom countersink
        translate([0,0,-pivotOutsideDia/2-boltHoleCountersinkDepth+boltHoleCountersinkAdjust])
            cylinder(d=boltHoleDia*2, h=boltHoleCountersinkDepth*2);
    }
}

module bellTopBraceBlock() {
    fudge=1/cos(180/4);  // the last # is the same as $fn (4 for a square cylinder)
    difference() {
        translate([-cowbellHandleBlockThickness/2,0,0])
            cube([cowbellHandleBlockThickness,cowbellTopOverHangDepth,camFollowerWidth]);
        translate([0,-overlap,-overlap])
        hull() {
            // front (right) side of bell
            translate([cowbellTopFlatThickness/2,cowbellTopOverHangDepth-cowbellTopCornerRadius,0])
                cylinder(r=cowbellTopCornerRadius, h=camFollowerWidth+overlap*2);
            // back (left) side of bell
            translate([-cowbellTopFlatThickness/2,cowbellTopOverHangDepth-cowbellTopCornerRadius,0])
                cylinder(r=cowbellTopCornerRadius, h=camFollowerWidth+overlap*2);
                translate([0,0,camFollowerWidth/2])
                    rotate([-90,0,0])
                        scale([cowbellTopFlatThickness+cowbellTopCornerRadius*2,
                            camFollowerWidth,1])
                            rotate([0,0,45])
                            cylinder(d1=1.1*fudge, 
                                    d2=1*fudge,
                                    h=cowbellTopOverHangDepth-cowbellTopCornerRadius,
                                    $fn=4);
        }
    }
}