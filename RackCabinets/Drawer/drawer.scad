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
// SD + USB-A + USB-C (90°, rounded) overlap centered.
// microSD (90°) overlaps both SD edges.
////////////////////////////////////////////////////////////

usb_a    = [13, 5];
sd       = [25, 3];
microsd  = [12, 2];
usb_c    = [9, 3.5];
usb_c_r  = 1.1;

// After 90°: narrow along edge, tall in Y
usb_c_rot   = [usb_c[1], usb_c[0]];      // [3.5, 9]
microsd_rot = [microsd[1], microsd[0]];  // [2, 12]

holder_margin = 1.5;
holder_floor  = 1.2;
holder_top    = 1.2;
holder_len    = sd[0] + 2*holder_margin;
holder_w      = 10;
slot_depth    = holder_w - 1.5;
z_margin      = 8;

// Combined center band: tallest of SD / USB-A / USB-C (rotated)
center_band_h = max(sd[1], usb_a[1], usb_c_rot[1]);
// microSD may extend the overall height if taller
slot_band_h   = max(center_band_h, microsd_rot[1]);
holder_h      = holder_floor + slot_band_h + holder_top;
holder_pitch  = holder_len + 2;


module holder_slot_box(w, h, d){
    cube([d + 0.1, h, w]);
}


module holder_slot_rounded(w, h, d, r){
    rr = min(r, h/2 - 0.05, w/2 - 0.05);
    hull(){
        translate([0, rr, rr]) rotate([0, 90, 0]) cylinder(r=rr, h=d + 0.1, $fn=24);
        translate([0, h - rr, rr]) rotate([0, 90, 0]) cylinder(r=rr, h=d + 0.1, $fn=24);
        translate([0, rr, w - rr]) rotate([0, 90, 0]) cylinder(r=rr, h=d + 0.1, $fn=24);
        translate([0, h - rr, w - rr]) rotate([0, 90, 0]) cylinder(r=rr, h=d + 0.1, $fn=24);
    }
}


module usb_sd_holder_unit(){
    // Local: X = into drawer, Y = up, Z = along long edge
    // USB SD Holder by openlewa
    xcut = holder_w - slot_depth;
    y0   = holder_floor;

    // Vertically center each opening in the shared band
    y_sd   = y0 + (slot_band_h - sd[1]) / 2;
    y_usba = y0 + (slot_band_h - usb_a[1]) / 2;
    y_usbc = y0 + (slot_band_h - usb_c_rot[1]) / 2;
    y_ms   = y0 + (slot_band_h - microsd_rot[1]) / 2;

    sd_z0 = (holder_len - sd[0]) / 2;

    difference(){
        cube([holder_w, holder_h, holder_len]);

        // SD + USB-A + USB-C mittig überlappend
        translate([xcut, y_sd, sd_z0])
            holder_slot_box(sd[0], sd[1], slot_depth);
        translate([xcut, y_usba, (holder_len - usb_a[0]) / 2])
            holder_slot_box(usb_a[0], usb_a[1], slot_depth);
        translate([xcut, y_usbc, (holder_len - usb_c_rot[0]) / 2])
            holder_slot_rounded(usb_c_rot[0], usb_c_rot[1], slot_depth, usb_c_r);

        // microSD 90° an beiden SD-Rändern, überlappend
        translate([xcut, y_ms, sd_z0])
            holder_slot_box(microsd_rot[0], microsd_rot[1], slot_depth);
        translate([xcut, y_ms, sd_z0 + sd[0] - microsd_rot[0]])
            holder_slot_box(microsd_rot[0], microsd_rot[1], slot_depth);
    }
}


module usb_sd_holders(){
    // USB SD Holder by openlewa
    dx0 = 30 + drawer_slip + 2;
    dy0 = 2 + drawer_slip + 2;
    dz0 = gauge;
    inner_w = width - 20 - 2*drawer_slip - 4;
    usable_z = dp - 2 - 2*z_margin;
    n_auto = max(1, floor((usable_z + 2) / holder_pitch));
    n = Holder_count > 0 ? Holder_count : n_auto;
    span = n * holder_pitch - 2;
    z0 = dz0 + z_margin + max(0, (usable_z - span) / 2);

    for(i = [0:n-1]){
        z = z0 + i * holder_pitch;

        translate([dx0, dy0, z]){
            usb_sd_holder_unit();
        }

        translate([dx0 + inner_w, dy0, z]){
            mirror([1, 0, 0]){
                usb_sd_holder_unit();
            }
        }
    }
}
