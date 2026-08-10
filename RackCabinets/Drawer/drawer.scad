include <../fiveinch_library.scad>

// Adapted from KronBjorn "6\" Rack, Drawer, Customizer"
// https://www.thingiverse.com/thing:2205569 (CC BY)
// Sized for FiveInchRack: 130mm front, longer 200mm depth.

//Which part to print
Part = "b"; // [a:Frame, b:Drawer, c:Handles]

//Height of drawer in units
u = 2;

//Depth of drawer (matches enclosure Depth)
dp = 200;

//Slip between drawer and frame
drawer_slip = 0.5;


go();
module go(){
    if(Part=="a"){
        print_frame();
    }else if(Part=="b"){
        print_drawer();
    }else if(Part=="c"){
        print_handles();
    }
}


module print_frame(){
    difference(){
        frontplate(u,[],[],[],[],[]);
        translate([30,0,0]){cube([width-20,u*unit,dp]);}
    }
    difference(){
        translate([28,0,gauge]){cube([width-20+4,u*unit,dp]);}
        translate([30,2,gauge-1]){cube([width-20,u*unit-4,dp+2]);}
    }
    translate([20,0,gauge]){cube([width,2,dp]);}
    translate([20,u*unit-2,gauge]){cube([width,2,dp]);}
}


module print_drawer(){
    half = (width+40)/2;
    hhhd = (4*unit-9)/2; //half handle hole distance for 4U handle
    intersection(){
        difference(){
            frontplate(u,[],[],[],[],[]);
            translate([20,0,gauge]){cube([width,u*unit,gauge]);}//remove support
            translate([half+hhhd,(u*unit)/2,gauge-0.25]){rotate([180,0,0]){screw();}}
            translate([half-hhhd,(u*unit)/2,gauge-0.25]){rotate([180,0,0]){screw();}}
        }
        translate([30+drawer_slip,0,0]){cube([width-20-drawer_slip*2,u*unit,dp]);}
    }

    difference(){
        translate([30+drawer_slip,2+drawer_slip,gauge]){
            cube([width-20-2*drawer_slip,u*unit-4-2*drawer_slip,dp]);
        }
        translate([30+drawer_slip+2,2+drawer_slip+2,gauge-0.01]){
            cube([width-20-2*drawer_slip-4,u*unit-4-2*drawer_slip,dp-2]);
        }
    }
}


module print_handles(){
    // Uses a 4U handle for grip; cuts away the extra of the printed pair
    difference(){
        translate([30,0,0]){handle(4,true);}
        translate([42,-100,-1]){cube([20,100,10]);}
    }
}
