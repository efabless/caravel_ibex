# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0


## Caravel Pointers
CARAVEL_PATH ?= ../../../caravel
CARAVEL_FIRMWARE_PATH = $(CARAVEL_PATH)/verilog/dv/caravel
CARAVEL_VERILOG_PATH  = $(CARAVEL_PATH)/verilog
CARAVEL_RTL_PATH = $(CARAVEL_VERILOG_PATH)/rtl
CARAVEL_BEHAVIOURAL_MODELS = $(CARAVEL_VERILOG_PATH)/dv/caravel

## User project Pointers
UPRJ_VERILOG_PATH ?= ../../../verilog
UPRJ_RTL_PATH = $(UPRJ_VERILOG_PATH)/rtl
UPRJ_BEHAVIOURAL_MODELS = ../

## Ibex firmware
IBEX_FIRMWARE_PATH = ../../../sw

## GCC Path
GCC_PATH?=/ef/apps/bin
GCC_PREFIX?=riscv32-unknown-elf

PDK_PATH?=/ef/tech/SW/sky130A

SIM?=RTL

.SUFFIXES:

PATTERN = spm

all:  ${PATTERN:=.vcd}

hex:  ${PATTERN:=.hex}

%.vvp: %_tb.v caravel_%.hex ibex_%.hex
ifeq ($(SIM),RTL)
	iverilog -DFUNCTIONAL -DSIM -DFAST -I $(PDK_PATH) \
	-I $(CARAVEL_BEHAVIOURAL_MODELS) -I $(CARAVEL_RTL_PATH) \
	-I $(UPRJ_BEHAVIOURAL_MODELS)    -I $(UPRJ_RTL_PATH) \
	$< -o $@ 
else  
	iverilog -DFUNCTIONAL -DSIM -DGL_UA -I $(PDK_PATH) \
	-I $(CARAVEL_BEHAVIOURAL_MODELS) -I $(CARAVEL_RTL_PATH) -I $(CARAVEL_VERILOG_PATH) \
	-I $(UPRJ_BEHAVIOURAL_MODELS) -I$(UPRJ_RTL_PATH)   -I $(UPRJ_VERILOG_PATH) \
	$< -o $@ 
endif

%.vcd: %.vvp
	vvp $<

## Caravel Firmware
caravel_%.elf: caravel.c $(CARAVEL_FIRMWARE_PATH)/sections.lds $(CARAVEL_FIRMWARE_PATH)/start.s
	${GCC_PATH}/${GCC_PREFIX}-gcc -march=rv32imc -mabi=ilp32 -Wl,-Bstatic,-T,$(CARAVEL_FIRMWARE_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(CARAVEL_FIRMWARE_PATH)/start.s $<

caravel_%.hex: caravel_%.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	# to fix flash base address
	sed -i 's/@10000000/@00000000/g' $@

caravel_%.bin: caravel_%.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

## IBEX Firmware
ibex_%.elf: %.c $(IBEX_FIRMWARE_PATH)/crt0.S $(IBEX_FIRMWARE_PATH)/link.ld 
	$(GCC_PATH)/${GCC_PREFIX}-gcc -Wall -falign-functions=4 -march=rv32ic -mabi=ilp32 -nostdlib -mstrict-align -T $(IBEX_FIRMWARE_PATH)/link.ld -o $@ -lgcc $(IBEX_FIRMWARE_PATH)/crt0.S $(IBEX_FIRMWARE_PATH)/n5_drv.c $<  -lgcc

ibex_%.hex: ibex_%.elf
	$(GCC_PATH)/${GCC_PREFIX}-objcopy -O verilog $< $@

ibex_%.lst: ibex_%.elf
	$(GCC_PATH)/${GCC_PREFIX}-objdump -D $< > $@

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.log
	rm -f $(IBEX_FIRMWARE_PATH)/*.bin $(IBEX_FIRMWARE_PATH)/*.hex $(IBEX_FIRMWARE_PATH)/*.elf $(IBEX_FIRMWARE_PATH)/*.lst

.PHONY: clean hex all
