include<../fiveinch_library.scad>


  ///////////////////////////////
 // Raspberry Pi  Model B     //
///////////////////////////////

print_frontplate_sml = true;
print_handle_sml     = true;
print_cabinet_sml    = true;
print_lid            = true;
print_rear           = true;

if(print_frontplate_sml){ // Frontplate //
    square_hole        = [[48 ,3, 28, 4]];
    round_hole         = [[93 ,5, 3.4],[98 ,5, 3.4]];
    round_peg          = [];   
    screw_side_front   = [];
    screw_top          = [36];
    screw_bottom_front = [36];
    units              = 2; 
    frontplate(units,square_hole,round_hole,round_peg,screw_side_front,screw_top,screw_bottom_front);

}

if(print_handle_sml){ // Handle // 
    units              = 2;
    lay_flat_for_print = false;   
    handle(units,lay_flat_for_print);
}

if(print_cabinet_sml){ // Cabinet //  
    screw_bottom_front = [36];
    screw_side_front   = [];
    round_peg          = [[28,35,6,screw_hole,6],
                          [53,90,6,screw_hole,6],
                          [20,90,6,0,6],
                          [53,35,6,0,6]];
    depth              = 98;
    units              = 2;
    cabinet(depth,units,screw_bottom_front,round_peg,screw_side_front);
}

if(print_lid){ // Lid // 
    depth = 98;
    units = 2;
    screw_front = [36];//mm
    screw_back  = [36];//mm
    lid(98,2,screw_front,screw_back);        
}

if(print_rear){  // Back plate //    
    square_hole  = [[10 ,5, 18, 15] , [31 ,5, 17, 17] , [66,5,10,3] ];
    round_hole   = [];
    screw_top    = [36];//mm
    screw_bottom = [36];//mm
    screw_side   = [];
    depth        = 98;
    units        = 2;
    back_plate(units,depth,screw_top,screw_bottom,screw_side,square_hole,round_hole);
}  
