## Description

This template is specifically made to work with a Tang Primer 20K board with an open source toolchain based on:
- GHDL 
- Yosys with ghdl-yosys-plugin
- nextpnr-himbaechel
- OpenFPGALoader

A unofficial constraint file is available in the `contstr/` folder and `src/` contains a simple blink script named `top.vhd`. When compiling, the top architecture's name has to be specified inside the makefile in the section that also allows to change board type.

~~~ Makefile
# change to your top-level entity name (do not put spaces after the name, or it will become part of the variable)
TOP := top

DEVICE := GW2A-LV18PG256C8/I7
PART := GW2A-18C
FAMILY := gw2a
BOARD := tangprimer20k
FREQ := 27
~~~

**Note**: make sure there are no spaces (in this example write `"top"` and not `"top "`) after the name of the top architecture or the variable $(TOP) will include that as well and may result in errors during synthesis.

To synthesize a top architecture execute:

```bash
make synth
```

To start place and route of a design execute:

```bash
make impl
```
To build the bitstream execute:

```bash
make bit
```

And finally, to program the device execute:

```bash
make prog
```

To clean build files execute:

```bash
make clean
```

