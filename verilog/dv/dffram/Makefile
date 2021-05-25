PDK_PATH?=${PDK_ROOT}/sky130A
VERILOG_PATH=../..
RTL_PATH=$(VERILOG_PATH)/rtl

SIM?=RTL

.SUFFIXES:

PATTERN = dffram

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.v
ifeq ($(SIM),RTL)
	iverilog -o $@ -DFUNCTIONAL -I $(PDK_PATH) -I $(RTL_PATH) -I $(VERILOG_PATH) \
	$< 
else
	iverilog -o $@ -DFUNCTIONAL -DUSE_POWER_PINS -DGL -I $(PDK_PATH) -I $(RTL_PATH) -I $(VERILOG_PATH) \
	$< 
endif

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd *.out

.PHONY: clean all