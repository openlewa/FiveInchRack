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
// Upright rails on both long edges with stacked horizontal
// openings (one per media type). USB-C has rounded corners
// and is rotated 90° so it overlaps the USB-A opening.
////////////////////////////////////////////////////////////

usb_a    = [13, 5];      // width along edge, height of opening
sd       = [25, 3];
microsd  = [12, 2];
usb_c    = [9, 3.5];     // native plug outline before 90° rotate
usb_c_r  = 1.1;          // corner radius for USB-C

// USB-C after 90°: narrow along edge, tall in Y — overlaps USB-A
usb_c_rot = [usb_c[1], usb_c[0]];  // [3.5, 9]

holder_margin = 1.5;
holder_sep    = 1.2;     // wall between stacked openings
holder_floor  = 1.2;
holder_top    = 1.2;
holder_len    = sd[0] + 2*holder_margin;  // along long edge (Z)
holder_w      = 10;                       // pocket depth into drawer (X)
// Combined USB-A + rotated USB-C share one band (height = USB-C)
usb_band_h    = usb_c_rot[1];
holder_h      = holder_floor + usb_band_h + holder_sep
              + sd[1] + holder_sep
              + microsd[1] + holder_sep
              + microsd[1] + holder_top;
holder_pitch  = holder_len + 2;
slot_depth    = holder_w - 1.5;           // leave outer skin
z_margin      = 8;


// Horizontal slot cut: opens on +X face, extends -X into the body
module holder_slot_box(w, h, d){
    cube([d + 0.1, h, w]);
}


// USB-C opening with rounded corners (stadium rectangle)
module holder_slot_usbc(w, h, d, r){
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
    // Openings are horizontal and stacked in Y — USB SD Holder by openlewa
    y_usb = holder_floor;
    y_sd  = y_usb + usb_band_h + holder_sep;
    y_ms1 = y_sd + sd[1] + holder_sep;
    y_ms2 = y_ms1 + microsd[1] + holder_sep;
    xcut  = holder_w - slot_depth;

    // Vertically center USB-A inside the taller rotated USB-C band
    y_usba = y_usb + (usb_band_h - usb_a[1]) / 2;

    difference(){
        cube([holder_w, holder_h, holder_len]);

        // Overlapping USB-A + USB-C (90°): same pocket, pick either type
        translate([xcut, y_usba, (holder_len - usb_a[0]) / 2])
            holder_slot_box(usb_a[0], usb_a[1], slot_depth);

        translate([xcut, y_usb, (holder_len - usb_c_rot[0]) / 2])
            holder_slot_usbc(usb_c_rot[0], usb_c_rot[1], slot_depth, usb_c_r);

        translate([xcut, y_sd, (holder_len - sd[0]) / 2])
            holder_slot_box(sd[0], sd[1], slot_depth);

        translate([xcut, y_ms1, (holder_len - microsd[0]) / 2])
            holder_slot_box(microsd[0], microsd[1], slot_depth);

        translate([xcut, y_ms2, (holder_len - microsd[0]) / 2])
            holder_slot_box(microsd[0], microsd[1], slot_depth);
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

        // Left long edge — openings face +X (into drawer)
        translate([dx0, dy0, z]){
            usb_sd_holder_unit();
        }

        // Right long edge — mirrored, openings face -X (into drawer)
        translate([dx0 + inner_w, dy0, z]){
            mirror([1, 0, 0]){
                usb_sd_holder_unit();
            }
        }
    }
}
