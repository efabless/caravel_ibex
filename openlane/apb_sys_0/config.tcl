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

# User config
set ::env(DESIGN_NAME) 				apb_sys_0
set ::env(DESIGN_IS_CORE) 			0

set ::env(ROUTING_CORES) 			16

# Change if needed
set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/uprj_defines.v
	$script_dir/../../verilog/rtl/AHB_sys_0/APB_sys_0/*.v
	$script_dir/../../verilog/rtl/IPs/*.v"

set ::env(RUN_KLAYOUT) 0

# Fill this
# 18-> 2
set ::env(CLOCK_PERIOD) 			"22"
set ::env(CLOCK_PORT) 				"HCLK"
set ::env(CLOCK_NET) 				"HCLK"

set ::env(VDD_NETS)			        "vccd1"
set ::env(GND_NETS)                 "vssd1"
set ::env(SYNTH_MAX_FANOUT)         "4"

set ::env(FP_SIZING) 				absolute
set ::env(FP_PIN_ORDER_CFG) 		$::env(DESIGN_DIR)/pin_order.cfg
set ::env(DIE_AREA) 				"0 0 450 700"

set ::env(PL_TARGET_DENSITY) 			0.66

set ::env(CELL_PAD) 					0

set ::env(GLB_RT_OBS) 				"met5 $::env(DIE_AREA)"
set ::env(GLB_RT_MAXLAYER) 			5
set ::env(GLB_RT_ADJUSTMENT) 		0.3

set ::env(DIODE_INSERTION_STRATEGY) 	4

