// cowbell cam follower pivot

camFollowerTipWidth=15;
camFollowerTipHeight=20;

pivotInsideDia=44;

pivotWallThickness=10;

pivotOutsideDia=pivotInsideDia+pivotWallThickness*2;

camFollowerWidth=45;

// Temp override
camFollowerWidth=5;



boltHoleDia=6;

cowbellHangerThickness=16;
cowbellHangarMetalThickness=2;

cowbellHangarOpeningHeight= 17.5;

cowbellHandleBlockOverHangThickness=15;
cowbellHandleBlockThickness=cowbellHangerThickness+2*cowbellHandleBlockOverHangThickness;


// Used to create a block that supports/braces the top of the bell a bit
cowbellTopOverHangDepth=14;
cowbellTopFlatThickness=24;
cowbellTopCornerRadius=6;
cowbellTopThickness=cowbellTopFlatThickness+cowbellTopCornerRadius*2;

overlap=0.01;
$fn=50;

// TODO: create two other objects that are cut pieces of this one.

union() {
    difference() {
        hull() {
            // cam follower tip
            translate([-camFollowerTipWidth,pivotOutsideDia/2,0])
                cube([camFollowerTipWidth,camFollowerTipHeight,camFollowerWidth]);
            // pivot
            cylinder(d=pivotOutsideDia, h=camFollowerWidth);
            // block to hold the cowbell
            translate([-cowbellHandleBlockThickness/2,-pivotOutsideDia/2-cowbellHangarOpeningHeight,0])
                cube([cowbellHandleBlockThickness,cowbellHangarOpeningHeight,camFollowerWidth]);
            
        }
        // pivot opening
        translate([0,0,-overlap])
            cylinder(d=pivotInsideDia, h=camFollowerWidth+overlap*2);
        // slot for hanger to pass through
        translate([-cowbellHangerThickness/2,-pivotOutsideDia/2-cowbellHangarMetalThickness,-overlap])
            cube([cowbellHangerThickness,cowbellHangarMetalThickness,camFollowerWidth+overlap*2]);
        
        if (camFollowerWidth > boltHoleDia*4) {
            // bolt hole 1
            translate([0,
                    -pivotOutsideDia/2-cowbellHangarOpeningHeight/2,
                    camFollowerWidth*3/4])
                rotate([0,90,0])
                    cylinder(d=boltHoleDia, h=pivotOutsideDia+overlap*2, center=true);
            // bolt hole 2
            translate([0,
                    -pivotOutsideDia/2-cowbellHangarOpeningHeight/2,
                    camFollowerWidth/4])
                rotate([0,90,0])
                    cylinder(d=boltHoleDia, h=pivotOutsideDia+overlap*2, center=true);
        }
        
    }
    translate([0,-pivotOutsideDia/2-cowbellHangarOpeningHeight-cowbellTopOverHangDepth,0])
        bellTopBraceBlock();
}

module bellTopBraceBlock() {
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
            translate([-cowbellTopFlatThickness/2-cowbellTopCornerRadius,0,0])
                cube([cowbellTopFlatThickness+cowbellTopCornerRadius*2,
                    cowbellTopOverHangDepth-cowbellTopCornerRadius,
                    camFollowerWidth+overlap*2]);
        }
    }
}