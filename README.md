# FiveInchRack

This is a project for 5" cabinets and rack enclosures.

It is based on [6" Rack Enclosure, Customizable](https://www.thingiverse.com/thing:1936196) by [KronBjorn](https://www.thingiverse.com/KronBjorn) ([GitHub](https://github.com/KronBjorn/SixInchRack)), licensed under Creative Commons Attribution (CC BY). This fork keeps the same license family as **CC BY 4.0** — see `LICENSE`.

For pictures of the original 6" series, see:
 - http://www.thingiverse.com/thing:1957436
 - http://www.thingiverse.com/thing:1936196
 - http://www.thingiverse.com/thing:2084736

The project is a scaled-down version of the familiar 19" rack standard (and of KronBjorn's 6" rack), with the following size:
 - 1U is about **14.05mm** (`(44.5/19)*6`) — same U height as the original 6" rack; only the width is reduced
 - The front plate is **130mm** wide (a bit over 5" / 127mm — same idea as the original using 155mm for 6")
 - Rack depth is **200mm** (enclosure ends are rectangular: ~131 × 201mm including the original +1mm clearance)
 - The inside distance between the two vertical profiles is **90mm**
 - The ears protrude **20mm** (still sized for 20x20 extruded aluminium)
 - Optional **1mm stack notch** on End grid / chimney / closed: a raised lip that nests into the inner opening of End open for stacking

It is designed for the 20x20 extruded aluminium profile, but a profile can also be printed.


## I want to print a simple blank five inch cabinet
Fetch these files from the repository and open `RackCabinets/ThingiverseCustomizer/thingiverse_customizer.scad` in OpenSCAD. Specify how many units you need in height, and depth in mm.


## I want to print a simple five inch rack enclosure for cabinets
Open `RackEnclosure/enclosure.scad` in OpenSCAD and choose which parts you need in the Customizer.


## I want to print a 5" cabinet for a specific component
Download the `.scad` files from this repository. Currently the following components are adapted from the community originals (coordinates adjusted for the narrower 5" bay):

- `RackCabinets/RaspberryPi3ModelB/` Raspberry Pi 3 Model B
- `RackCabinets/RaspberryPiModelB/` Raspberry Pi Model B

Original 6" Thingiverse builds (for reference):
- http://www.thingiverse.com/thing:2084736 Raspberry Pi 3 Model B
- http://www.thingiverse.com/thing:1905998 Raspberry Pi B
- http://www.thingiverse.com/thing:2151578 Beaglebone Black
- http://www.thingiverse.com/thing:2123108 DPS5005 power supply
- http://www.thingiverse.com/thing:2105698 Beaglebone Black

## I want to make a new cabinet for my favourite module
Start by inspecting this file for inspiration `_RackCabinets/RaspberryPiModelB/usb_back.scad_`, and take a look at the how to section below.

1. Create a new file that includes `_fiveinch_library.scad_`
2. Customize all the parts needed for your cabinet
3. Create a new folder with your project, and anything else needed like print descriptions
4. If you like, publish a build with pictures and your STL, and add a link in this file

## Quick How To
A cabinet consists of five parts:
- Front plate
- Back plate
- Cabinet
- Lid
- Handles

In a new file, include `_fiveinch_library.scad_`. For each of the parts, there is a module in the library where you can specify the most commonly used features like round and square holes, and pegs for supporting PCBs etc. The following examples are for a Raspberry Pi 3 cabinet.  
The default modules obviously do not support everything you need, but should give you a good start for further customization. Feel free to add functionality to the library.

### Front Plate
```java
square_hole        = [];
round_hole         = [[53 ,7.5, 3.1],[57.5 ,7.5, 3.1]];
round_peg          = [];   
screw_side_front   = [];
screw_top          = [36];
screw_bottom_front = [36];
units              = 2; 
frontplate(units,square_hole,round_hole,round_peg,screw_side_front,screw_top,screw_bottom_front);
```

### Handle
```java
units              = 2;
lay_flat_for_print = true;   
handle(units,lay_flat_for_print);
```

### Cabinet
```java
w=76;
h=70;
screw_bottom_front = [36];
screw_side_front   = [];
round_peg          = [[w,h,6,2.8,4],
                     [w-49,h,6,2.8,4],
                     [w-49,h-58,6,2.8,4],
                     [w,h-58,6,2.8,4]];
depth              = 98;
units              = 2;
cabinet(depth,units,screw_bottom_front,round_peg,screw_side_front);
```

### Lid
```java
depth = 98;
units = 2;
screw_front = [36];//mm
screw_back  = [36];//mm
lid(98,2,screw_front,screw_back);        
```


### Back plate   
```java
square_hole  = [[25 ,3, 17, 15] , [45 ,4, 15, 16] , [63,4,15,16] ];
round_hole   = [[6,5,6],[6,1,6], [24,3.5,3.5],[24,1.2,3.5]  ,[30,3.5,3.5],[30,1.2,3.5]];
screw_top    = [36];//mm
screw_bottom = [36];//mm
screw_side   = [];
depth        = 98;
units        = 2;
back_plate(units,depth,screw_top,screw_bottom,screw_side,square_hole,round_hole);
```
