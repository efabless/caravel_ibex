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

set script_dir [file dirname [file normalize [info script]]]

### User config
set ::env(DESIGN_NAME) 					DMC_32x16HC
# Number of threads during routing
set ::env(ROUTING_CORES) 				16
# Disable streaming GDS using klayout
set ::env(RUN_KLAYOUT) 0

### Design config
set ::env(DESIGN_IS_CORE) 				0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/uprj_defines.v
	$script_dir/../../verilog/rtl/IPs/DFFRAMBB.v
	$script_dir/../../verilog/rtl/IPs/DMC_32x16HC.v"

### Clock Config
set ::env(CLOCK_PERIOD) 				"10"
set ::env(CLOCK_PORT) 					"clk"
# Disable clock tree synthesis because the Cache has the clock tree embedded inside 
set ::env(CLOCK_TREE_SYNTH) 			0

### Synthesis	
set ::env(SYNTH_READ_BLACKBOX_LIB)      1

### Floorplan
set ::env(FP_PIN_ORDER_CFG) 			$::env(DESIGN_DIR)/pin_order.cfg
set ::env(FP_SIZING) 					absolute
set ::env(DIE_AREA) 					"0 0 400 600"
set ::env(CELL_PAD) 					 0

### Placement
set ::env(PL_TARGET_DENSITY) 			              0.78
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS)            0
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS)            0

### Power Nets
set ::env(VDD_NETS)                     "vccd1"
set ::env(GND_NETS)                     "vssd1"

### Routing
# Add routing obstruction on met5 to avoid having shorts on the top level where met5 power straps intersect with the macro
set ::env(GLB_RT_OBS) 					"met5 $::env(DIE_AREA)"
set ::env(GLB_RT_MAXLAYER) 				5
set ::env(GLB_RT_ADJUSTMENT) 			0.25

### Diode Insertion
set ::env(DIODE_INSERTION_STRATEGY) 	4
