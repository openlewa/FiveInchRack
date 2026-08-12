// FiveInchRack drawer — Customizer parameters first, then library.
// Adapted from KronBjorn "6\" Rack, Drawer, Customizer"
// https://www.thingiverse.com/thing:2205569 (CC BY)

/*[Drawer]*/
//Which part to print
Part = "b"; // [a:Frame, b:Drawer, c:Handles]

//Height of drawer in units
u = 2;

//Depth of drawer (matches enclosure Depth)
dp = 200;

//Slip between drawer and frame (do not name this "slip" — that is used by the library)
drawer_slip = 0.5;

/*[USB SD Holder by openlewa]*/
// Optional media holders along one long edge
USB_SD_Holder = "yes"; // [yes, no]

// How many holders on that edge (0 = auto-fit)
Holder_count = 0;


// Library (fiveinch geometry; sixinch_library.scad is a compatible alias)
include <../fiveinch_library.scad>


////////////////////////////////////////////////////////////
// USB SD Holder by openlewa — constants before go()
// SD + USB-A + USB-C (90°, rounded) overlap centered.
// microSD (90°) centered between SD edge and USB edge,
// and vertically centered with that group.
// Flat face: openings only (no stick-body relief / band).
////////////////////////////////////////////////////////////

usb_a    = [13, 5];
sd       = [25, 3];
microsd  = [12, 2];
usb_c    = [9, 3.5];
usb_c_r  = 1.5;

usb_c_rot   = [usb_c[1], usb_c[0]];      // [3.5, 9] after 90°
microsd_rot = [microsd[1], microsd[0]];  // [2, 12] after 90°

holder_margin = 1.5;
holder_len    = sd[0] + 2*holder_margin;
holder_w      = 12;
slot_depth    = holder_w - 1.5;
z_margin      = 8;

// Band sized to the actual openings (flat face)
center_band_h = max(sd[1], max(usb_a[1], usb_c_rot[1]));
ms_overhang   = max(0, (microsd_rot[1] - center_band_h) / 2);
holder_floor  = max(6, ms_overhang);
holder_top    = max(6, ms_overhang);
holder_h      = holder_floor + center_band_h + holder_top;
holder_pitch  = holder_len;


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
    // Rails between mounting ears (use width, not hardcoded 115)
    translate([20,0,gauge]){cube([width,2,dp]);}
    translate([20,u*unit-2,gauge]){cube([width,2,dp]);}
}


module print_drawer(){
    // Center of front plate = fiveinch/2 == (width+40)/2
    half = (width+40)/2;
    hhhd = (4*unit-9)/2; // half handle hole distance for 4U handle
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
    difference(){
        translate([30,0,0]){handle(4,true);}
        translate([42,-100,-1]){cube([20,100,10]);}
    }
}


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
    // USB SD Holder by openlewa — flat face, openings only
    xcut = holder_w - slot_depth;

    y_mid  = holder_floor + center_band_h / 2;
    y_sd   = y_mid - sd[1] / 2;
    y_usba = y_mid - usb_a[1] / 2;
    y_usbc = y_mid - usb_c_rot[1] / 2;
    y_ms   = y_mid - microsd_rot[1] / 2;

    sd_z0  = (holder_len - sd[0]) / 2;
    usb_z0 = (holder_len - usb_a[0]) / 2;
    left_gap_z0  = sd_z0;
    left_gap_z1  = usb_z0;
    right_gap_z0 = usb_z0 + usb_a[0];
    right_gap_z1 = sd_z0 + sd[0];
    ms_left_z  = (left_gap_z0 + left_gap_z1) / 2 - microsd_rot[0] / 2;
    ms_right_z = (right_gap_z0 + right_gap_z1) / 2 - microsd_rot[0] / 2;

    difference(){
        cube([holder_w, holder_h, holder_len]);

        translate([xcut, y_sd, sd_z0])
            holder_slot_box(sd[0], sd[1], slot_depth);
        translate([xcut, y_usba, usb_z0])
            holder_slot_box(usb_a[0], usb_a[1], slot_depth);
        translate([xcut, y_usbc, (holder_len - usb_c_rot[0]) / 2])
            holder_slot_rounded(usb_c_rot[0], usb_c_rot[1], slot_depth, usb_c_r);

        translate([xcut, y_ms, ms_left_z])
            holder_slot_box(microsd_rot[0], microsd_rot[1], slot_depth);
        translate([xcut, y_ms, ms_right_z])
            holder_slot_box(microsd_rot[0], microsd_rot[1], slot_depth);
    }
}


module usb_sd_holders(){
    // USB SD Holder by openlewa — one long edge, units packed tight
    dx0 = 30 + drawer_slip + 2;
    dy0 = 2 + drawer_slip + 2;
    dz0 = gauge;
    usable_z = dp - 2 - 2*z_margin;
    n_auto = max(1, floor(usable_z / holder_pitch));
    n = (Holder_count > 0) ? Holder_count : n_auto;
    span = n * holder_pitch;
    z0 = dz0 + z_margin + max(0, (usable_z - span) / 2);

    for(i = [0:n-1]){
        translate([dx0, dy0, z0 + i * holder_pitch]){
            usb_sd_holder_unit();
        }
    }
}
