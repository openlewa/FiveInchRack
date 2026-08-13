This is a customizable drawer for the 5" rack series.

Default depth is **200mm** to match the enclosure footprint. The frame does not have to be as deep as the drawer itself — change `dp` in the Customizer if needed.

Front plate width is **130mm** (FiveInchRack).

Uses `../fiveinch_library.scad` (also available as `../sixinch_library.scad` alias). Do **not** name the drawer gap variable `slip` — that name is reserved by the library (0.35mm part clearance). Use `drawer_slip` instead.

Optional **USB SD Holder by openlewa** (`USB_SD_Holder = yes`, default **no**): one tight row at the **back** of the drawer (away from the front screws). **SD + USB-A + USB-C** (90°, rounded) overlap in the center; **microSD** (90°) between SD and USB edges. Flat face, openings only. Set `Holder_count` to override auto-fit.

For the handle, you may need to shorten two screws, or find some really short ones.

Adapted from KronBjorn's [6" Rack, Drawer, Customizer](https://www.thingiverse.com/thing:2205569) (CC BY).
