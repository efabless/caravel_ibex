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
# SPDX-License-Identifier: Apache-2.0

### Base Configurations. Don't Touch
### section begin
set script_dir [file dirname [file normalize [info script]]]

source $script_dir/../../caravel/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl

set ::env(DESIGN_NAME) user_project_wrapper
### section end

### User Configurations
# Number of threads during routing
set ::env(ROUTING_CORES)  16
# Disable streaming GDS using klayout
set ::env(RUN_KLAYOUT) 0

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$script_dir/../../caravel/verilog/rtl/defines.v
	$script_dir/../../verilog/rtl/uprj_defines.v
    $script_dir/../../verilog/rtl/acc/AHB_SPM.v
    $script_dir/../../verilog/rtl/IPs/AHBSRAM.v
    $script_dir/../../verilog/rtl/IPs/DFFRAMBB.v
    $script_dir/../../verilog/rtl/IPs/GPIO.v
    $script_dir/../../verilog/rtl/IPs/APB_I2C.v
    $script_dir/../../verilog/rtl/IPs/APB_SPI.v
    $script_dir/../../verilog/rtl/IPs/APB_UART.v
    $script_dir/../../verilog/rtl/IPs/i2c_master.v
    $script_dir/../../verilog/rtl/IPs/PWM32.v
    $script_dir/../../verilog/rtl/IPs/RAM_3Kx32.v
    $script_dir/../../verilog/rtl/IPs/QSPI_XIP_CTRL.v
    $script_dir/../../verilog/rtl/IPs/spi_master.v
    $script_dir/../../verilog/rtl/IPs/TIMER32.v
    $script_dir/../../verilog/rtl/IPs/WDT32.v
    $script_dir/../../verilog/rtl/AHB_sys_0/*.v
    $script_dir/../../verilog/rtl/soc_core.v
    $script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT)   "wb_clk_i"
set ::env(CLOCK_NET)    "wb_clk_i"
set ::env(CLOCK_PERIOD) "28"

## Synthesis
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

## Floorplan
set ::env(FP_PDN_CHECK_NODES) 0
## Placement
set ::env(PL_TARGET_DENSITY)     0.05
# Increase diamanod search height so that the detailed placement can legalize cells overlapping with big macros
set ::env(PL_DIAMOND_SEARCH_HEIGHT) 400	

set ::env(CELL_PAD)              0

## Routing configurations
set ::env(GLB_RT_ADJUSTMENT) 0.35
set ::env(GLB_RT_MAXLAYER) 5

set ::env(GLB_RT_OBS) "
	met4 200  150  1300 1550,\
	met4 1600 150  2700 1550,\
	met4 2100 2650 2500 3250,\
	met4 2150 1700 2750 2500"

## Diode insertion 
set ::env(DIODE_INSERTION_STRATEGY) "4"

## Internal Macros
### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
    $script_dir/../../verilog/rtl/ibex/ibex_wrapper.v
	$script_dir/../../verilog/rtl/IPs/DFFRAM_1Kx32.v
    $script_dir/../../verilog/rtl/AHB_sys_0/APB_sys_0/APB_sys_0.v
    $script_dir/../../verilog/rtl/IPs/DMC_32x16HC.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/ibex_wrapper.lef
	$script_dir/../../lef/apb_sys_0.lef
	$script_dir/../../lef/DFFRAM_1Kx32.lef
    $script_dir/../../lef/DMC_32x16HC.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/ibex_wrapper.gds
	$script_dir/../../gds/apb_sys_0.gds
 	$script_dir/../../gds/DFFRAM_1Kx32.gds
 	$script_dir/../../gds/DMC_32x16HC.gds"
