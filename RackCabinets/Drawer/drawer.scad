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

// Optional media holders along both long edges
// USB SD Holder by openlewa
USB_SD_Holder = "yes"; // [yes, no]

// How many holders per long edge (0 = auto-fit)
Holder_count = 0;


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
        frontplate(u,[],[],[],[],[],[]);
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
            frontplate(u,[],[],[],[],[],[]);
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

    if(USB_SD_Holder=="yes"){
        // USB SD Holder by openlewa
        usb_sd_holders();
    }
}


module print_handles(){
    // Uses a 4U handle for grip; cuts away the extra of the printed pair
    difference(){
        translate([30,0,0]){handle(4,true);}
        translate([42,-100,-1]){cube([20,100,10]);}
    }
}


////////////////////////////////////////////////////////////
// USB SD Holder by openlewa
// Optional rows of media slots along both long drawer edges.
// Each holder: USB-A (13x5) on the long edge, SD (25x3),
// 2x microSD (12x2) on the short edges, USB-C in the center.
////////////////////////////////////////////////////////////

usb_a    = [13, 5];
sd       = [25, 3];
microsd  = [12, 2];
usb_c    = [9, 3.5];

holder_margin = 1.5;
holder_gap    = 1.0;
// Long enough for: margin + µSD + gap + SD + gap + µSD + margin
holder_len    = 2*holder_margin + microsd[1] + holder_gap + sd[0] + holder_gap + microsd[1];
holder_w      = microsd[0] + 2*holder_margin;     // into drawer (X)
holder_h      = 10;
holder_pitch  = holder_len + 2;
holder_floor  = 1.2;
z_margin      = 8; // keep clear of front plate / back lip


module usb_sd_holder_unit(){
    // Local coords: X = into drawer, Y = up, Z = along long edge
    // USB SD Holder by openlewa
    msd_z0 = holder_margin;
    msd_z1 = holder_len - holder_margin - microsd[1];
    sd_z   = msd_z0 + microsd[1] + holder_gap;

    difference(){
        cube([holder_w, holder_h, holder_len]);

        // USB-A 13x5, mittig an langer (äusserer) Kante
        translate([-0.1, holder_floor, (holder_len - usb_a[0]) / 2]){
            cube([usb_a[1] + 0.1, holder_h, usb_a[0]]);
        }

        // SD 25x3 between the microSD end slots, inner long edge
        translate([holder_w - sd[1] - holder_margin, holder_floor, sd_z]){
            cube([sd[1], holder_h, sd[0]]);
        }

        // microSD 12x2 an beiden kurzen Kanten
        translate([(holder_w - microsd[0]) / 2, holder_floor, msd_z0]){
            cube([microsd[0], holder_h, microsd[1]]);
        }
        translate([(holder_w - microsd[0]) / 2, holder_floor, msd_z1]){
            cube([microsd[0], holder_h, microsd[1]]);
        }

        // USB-C mittig
        translate([(holder_w - usb_c[1]) / 2, holder_floor, (holder_len - usb_c[0]) / 2]){
            cube([usb_c[1], holder_h, usb_c[0]]);
        }
    }
}


module usb_sd_holders(){
    // USB SD Holder by openlewa
    dx0 = 30 + drawer_slip + 2;                 // inner left X
    dy0 = 2 + drawer_slip + 2;                  // inner floor Y
    dz0 = gauge;
    inner_w = width - 20 - 2*drawer_slip - 4;
    usable_z = dp - 2 - 2*z_margin;
    n_auto = max(1, floor((usable_z + 2) / holder_pitch));
    n = Holder_count > 0 ? Holder_count : n_auto;
    span = n * holder_pitch - 2;
    z0 = dz0 + z_margin + max(0, (usable_z - span) / 2);

    for(i = [0:n-1]){
        z = z0 + i * holder_pitch;

        // Left long edge — outer wall at X=0 of the unit
        translate([dx0, dy0, z]){
            usb_sd_holder_unit();
        }

        // Right long edge — mirrored so outer wall sits on +X side
        translate([dx0 + inner_w, dy0, z]){
            mirror([1, 0, 0]){
                usb_sd_holder_unit();
            }
        }
    }
}
