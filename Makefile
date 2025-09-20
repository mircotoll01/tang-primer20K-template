# ===== Tang Primer 20K — VHDL Makefile template =====
# Usage:
#   - Put your VHDL files under src/
#   - Set TOP to the entity name you want to elaborate (e.g. prova)
#   - Edit DEVICE/FAMILY/PART/FREQ if needed
#   - Put your constraints file in constr/tangprimer20k.cst
#
# Build:
#   make           # build bitstream (calls synth -> pnr -> pack)
#   make prog      # program board (openFPGALoader)
#   make clean     # remove generated files
#   make info      # print settings

# change to your top-level entity name (do not put spaces after the name, or it will become part of the variable)
TOP := top

DEVICE := GW2A-LV18PG256C8/I7
PART := GW2A-18C
FAMILY := gw2a
BOARD := tangprimer20k
FREQ := 27

# tools (adjust if installed in non-standard locations)
YOSYS := yosys
NEXTPNR := nextpnr-himbaechel
PACK := gowin_pack
PROG := openFPGALoader

# gather all VHDL sources under src/ (both .vhd and .vhdl), sorted
VHDL_SRCS := $(shell find src -type f \( -name '*.vhd' -o -name '*.vhdl' \) | sort)

# generated filenames
SYNTH := $(TOP)-$(BOARD)-synth.json
ROUTED := $(TOP)-$(BOARD).json
BIT := $(TOP)-$(BOARD).fs

.PHONY: all prog clean info

all: $(BIT)

# 1) synth (GHDL via Yosys)
$(SYNTH): $(VHDL_SRCS)
	@echo "Synthesizing VHDL sources for TOP"
	@printf "  %s\n" $(VHDL_SRCS)
	$(YOSYS) -m ghdl -p "ghdl --std=08 $(VHDL_SRCS) -e $(TOP); synth_gowin -json $@ -family $(FAMILY)"

# 2) place & route (nextpnr-himbaechel)
$(ROUTED): $(SYNTH) constr/$(BOARD).cst
	@echo "Running place & route (nextpnr-himbaechel) -> $@"
	$(NEXTPNR) --json $< --write $@ --device $(DEVICE) --freq $(FREQ) --vopt family=$(PART) --vopt cst=constr/$(BOARD).cst

# 3) pack into .fs bitstream
$(BIT): $(ROUTED)
	@echo "Packing bitstream -> $@"
	$(PACK) -c -d $(PART) -o $@ $<

# program board
prog: $(BIT)
	@echo "Programming board with $(BIT)..."
	$(PROG) -b $(BOARD) $<

clean:
	-rm -f $(SYNTH) $(ROUTED) $(BIT) 

info:
	@echo "TOP = $(TOP)"
	@echo "DEVICE = $(DEVICE)"
	@echo "PART = $(PART)"
	@echo "FAMILY = $(FAMILY)"
	@echo "BOARD = $(BOARD)"
	@echo "FREQ = $(FREQ)"
	@echo "VHDL_SRCS:"
	@printf "  %s\n" $(VHDL_SRCS)
