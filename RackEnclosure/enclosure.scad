// This file contains all the parts for a rack enclosure
// It has the format required for a customizable project on Thingiverse
// Note: Calculated variables does not show up in the customizer, hence the *1; 

$fn = 50*1;

part = "f"; // [a:Extrusion no holes,b:Extrusion front holes,c:Extrusion front and side holes,d:End open,e:End grid,f:End chimney,g:End closed,h:Nut-less Trap,i:Panel,j:Panel with handle,k:Handle]

Units = 3;

// Rack footprint depth (front-to-back). Width is fiveinch (130mm).
Depth = 200;

// 1mm raised lip on Grid / Chimney / Closed that nests into End open
Stack_notch = "yes"; // [yes, no]

//Hole size for 4mm screws or freedom unit equivalent
Four_mm_screw = 3.8;

//Hole size for 5mm screws or freedom unit equivalent
Five_mm_screw = 4.8;

//Constants, do not change !
// Named 5"; front plate is a bit over 5" (127mm), same idea as the
// original 6" rack using 155mm instead of 152.4mm.
fiveinch  = 130*1;       // mm; slightly over 5"
ear       = 20*1;        // mm; 20x20 profile / mounting ear
width     = fiveinch-ear-ear; // 90mm between rails
unit      = (44.5/19)*6; // 1U ≈ 14.05mm (same as original 6" rack)
gauge     = 3*1;
gauge_box = 2*1;
slip      = 0.35*1;      // extra slip between parts
stack_lip = 1*1;         // mm; nesting lip height for Stack_notch

go();

module go(){
    if (part=="a"){
        extrusion(Units,true,false,false);
    }else if (part=="b"){
        extrusion(Units,true,true,false);
    }else if (part=="c"){
        extrusion(Units,true,true,true);
    }else if (part=="d"){
        rack_end(0);
    }else if (part=="e"){
        rack_end(1);
    }else if (part=="f"){
        rack_end(2);
    }else if (part=="g"){
        rack_end(3);
    }else if (part=="h"){
        trap(Units);
    }else if (part=="i"){
        sidepanel(Units,false);
    }else if (part=="j"){
        sidepanel(Units,true);
    }else if (part=="k"){
        tophandle();
    translate([0,30,0]){tophandle();}
    }
}




module chimney() {    
    for(i=[0:8:80]){
        echo(i);
        translate([20 + (width-80)/2  +i,-1,20]){
            minkowski(){
                cube([0.01,50,30]);    
                sphere(d=2);        
            }
        }
    }
}

// Raised 1mm rim that fits into the inner opening of End open
module stack_notch_lip(end_w, end_d){
    rim = 3;
    translate([20+slip, 20+slip, gauge]){
        difference(){
            cube([end_w-40-2*slip, end_d-40-2*slip, stack_lip]);
            translate([rim, rim, -0.1]){
                cube([end_w-40-2*slip-2*rim, end_d-40-2*slip-2*rim, stack_lip+0.2]);
            }
        }
    }
}




// Nut-less Trap
module trap(u){
    difference(){
        union(){
            translate([-2.4,0,4]){
                cube([4.8,unit*u,1.5]);
            }    
            translate([-2.4,unit*u,0]){
                rotate([90,0,0]){
                    linear_extrude(unit*u){
                        polygon(points=[[0,0],[4.8,0],[7,4],[-2.2,4]]);
                    }
                }
            }
        }                        
        for(i=[1:u]){
            translate([0,unit*i-unit/2,-1]){
                cylinder(d=Four_mm_screw,h=10);
            }                       
        }
    }
}



//0: open
//1: grid
//2: chimney
//3: closed
// End plate is fiveinch (width) by Depth (front-to-back), +1mm like the original.
module rack_end(type){    
    end_w = fiveinch+1;
    end_d = Depth+1;
    difference(){
        union(){
            translate([1.25,1.25,1.25]){
                minkowski(){
                    cube([end_w-2.5, end_d-2.5, gauge-2.5]);
                    sphere(r=1.25);
                }
            }
        }
        if(type==0 || type==1){
            translate([20,20,-1]){ cube([end_w-40, end_d-40, gauge+2]);}
        }
    
        translate([10,10,-0.1])             { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
        translate([end_w-10,10,-0.1])       { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
        translate([10,end_d-10,-0.1])       { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
        translate([end_w-10,end_d-10,-0.1]) { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
  
        rotate([-90,0,0]){
            if(type==2){
                // Chimney rows along the depth axis
                for(y=[0, (end_d-29)/2, end_d-29]){
                    translate([0,-5,y]){chimney();}
                }
            }
        }    
    }  
    if(type==1){
        intersection(){
            union(){
                sz=8;
                grid = 15;
                for(i=[-grid*10:12:grid*10]){        
                    translate([sz/2+i+end_w/2, sz/2+end_d/2, gauge/2]){
                        rotate([0,0,45]){
                            cube([2, max(end_w,end_d)*1.5, gauge],center=true);
                        }
                    }
                    translate([sz/2+i+end_w/2, sz/2+end_d/2+4, gauge/2]){
                        rotate([0,0,-45]){
                            cube([2, max(end_w,end_d)*1.5, gauge],center=true);
                        }
                    }
                }
            }
            translate([15,15,-1]){cube([end_w-30, end_d-30, 10]);}
        }
    }
    // Optional 1mm lip: nests into the inner opening of End open for stacking
    if(Stack_notch=="yes" && (type==1 || type==2 || type==3)){
        stack_notch_lip(end_w, end_d);
    }
}



module tophandle(){
    rotate([0,180,0]){
        difference(){
            union(){
                rotate([0,45,0]){
                    extrusion(4,false,false,false);
                }
                translate([fiveinch,20,0]){
                    rotate([0,45,180]){
                        extrusion(4,false,false,false);
                    }
                }
            }    
            wedge();            
            translate([90,90,10]){
                cube([200,200,20],center=true);
            }       
            translate([10,10,0]){handlescrew();}
            translate([fiveinch-10,10,0]){handlescrew();}        
        }
        intersection(){
            translate([0,0,-27.4]){
                extrusion(11,false,false,false);
            }
            wedge();        
        } 
    }    
}




module handlescrew(){
    translate([0,0,-39]){cylinder(d=5,h=40); }
    translate([0,0,-4]){cylinder(d1=10,d2=6,h=3.5);}
    translate([0,0,-34]){cylinder(d=10,h=30);}
}



module wedge(){
    translate([fiveinch/2,-10,15]){
        rotate([0,45+45/2,0]){
            cube([80,80,30]);
        }
        translate([0,80,0]){
            rotate([0,45+45/2,180]){
                cube([80,80,30]);
            }
        }
        translate([-20,0,-100]){
            cube([40,80,100]);
        }
    }
}




module extrusion(u,center,front,side){
    len=unit*u;
    difference(){
        translate([0,2,2]){
            minkowski(){
                cube([len,16,16]);
                sphere(d=4);
            }
        } 
        translate([-5,10,1.99]){
            rotate([0,90,0]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
        }
        translate([-5,10,18.01]){
            rotate([0,-90,180]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
        }    
        translate([-5,18.01,10]){
            rotate([90,0,90]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
        }    
        translate([-5,1.99,10]){
            rotate([-90,0,-90]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
        }    
        if(center){
            translate([-5,10,10]){
                rotate([0,90,0]){
                    cylinder(d=4.6,h=len+10);
                }
            }
        }     
        //holes
        if(front){
            for(i=[0:30]){
                translate([unit/2+i*unit,10,-5]){ cylinder(d=3.8,h=30);}
            }
        }    
        if(side){
            for(i=[0:30]){
                translate([unit/2+i*unit,25,10]){ rotate([90,0,0]){cylinder(d=3.8,h=30);}}
            }
        }
        //length cutoff
        translate([-2,0,0]){cube([4,60,60],center=true);}
        translate([len+2,0,0]){cube([4,60,60],center=true);}    
    }
}



module screw(){
    cylinder(r1=screw_head/2, r2=screw_dia/2, h=screw_head_height);
    cylinder(r=screw_dia/2, h=40);    
    translate([0,0,-0.99]){cylinder(r=screw_head/2, h=1);}    
}



module insideprofile(l){
    difference(){
        union(){
            translate([7.6,10,0]){cube([4.8,10,l]);}
            translate([0,7.6,0]){cube([20,4.8,l]);}  
            
            translate([6.5,10-2.1,0]){cube([7   ,10,l]);}
            translate([2.1,6.5,0]){cube([15.8,7   ,l]);}  
        }
        translate([4,4,-1]){
            cube([12,12,l+2]);
        }
    } 
    translate([20,20,0]){
        rotate([0,-90,0]){
            linear_extrude(20){
                polygon (points=[[0,0],[l,0],[0,l]]);
            }
        }
    }    
}





module sidepanel(u,handle){
    // Side panel spans rack Depth (front-to-back)
    difference(){
        baseplate(u, Depth);
        if(handle){
              translate([(Depth-80)/2,         9,-4]) { cube([80,20,10]);}
              translate([(Depth-80)/2,        19,-4]) { cylinder(d=20,h=10);}
              translate([Depth-(Depth-80)/2,19,-4]) { cylinder(d=20,h=10);}
        }
    }
}



module baseplate(u, plate_w=fiveinch){
    difference(){
        union(){
            translate([1.25,1.25,1.25]){
                minkowski(){
                    cube([plate_w-2.5,unit*u-2.5,gauge-2.5]);
                    sphere(r=1.25);
                }
            }
        }
        //Rack mount holes
        translate([10-0.5,unit/2,-gauge/2])                    {cylinder(r=2.3,gauge*2);}
        translate([plate_w-10+0.5,unit/2,-gauge/2])            {cylinder(r=2.3,gauge*2);}
        translate([10-0.5,u*unit-(unit/2),-gauge/2])           {cylinder(r=2.3,gauge*2);}
        translate([plate_w-10+0.5,u*unit-(unit/2),-gauge/2])   {cylinder(r=2.3,gauge*2);}
        if(u>=5){
            translate([10-0.5,(u*unit)/2,-gauge/2])            {cylinder(r=2.3,gauge*2);}
            translate([plate_w-10+0.5,(u*unit)/2,-gauge/2])    {cylinder(r=2.3,gauge*2);}
        }  
    }    
}



















