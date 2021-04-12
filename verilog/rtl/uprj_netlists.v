`include "defines.v"

`ifdef FAST
	`define USE_DFFRAM_BEH
    `define NO_HC_CACHE
    `include "DFFRAM_beh.v"
`else
	`ifndef GL_UA
		`include "IPs/DFFRAM_4K.v"
		`include "IPs/DFFRAMBB.v"
		`include "IPs/DMC_32x16HC.v"
	`endif
`endif

`ifdef GL_UA
	`default_nettype wire
	`include "gl/apb_sys_0.v"
	`include "gl/DFFRAM_4K.v"
	`include "gl/DMC_32x16HC.v"
	`include "gl/ibex_wrapper.v"
	`include "gl/user_project_wrapper.v"
`else
	`include "AHB_sys_0/AHBlite_sys_0.v"
	`include "AHB_sys_0/AHBlite_bus0.v"
	`include "AHB_sys_0/AHBlite_GPIO.v"
	`include "AHB_sys_0/AHBlite_db_reg.v"
	`include "AHB_sys_0/APB_sys_0/APB_WDT32.v"
	`include "AHB_sys_0/APB_sys_0/APB_TIMER32.v"
	`include "AHB_sys_0/APB_sys_0/APB_PWM32.v"
	`include "AHB_sys_0/APB_sys_0/AHB_2_APB.v"
	`include "AHB_sys_0/APB_sys_0/APB_bus0.v"
	`include "AHB_sys_0/APB_sys_0/APB_sys_0.v"
	`include "IPs/TIMER32.v"
	`include "IPs/PWM32.v"
	`include "IPs/WDT32.v"
	`include "IPs/spi_master.v"
	`include "IPs/i2c_master.v"
	`include "IPs/GPIO.v"
	`include "IPs/APB_UART.v"
	`include "IPs/APB_SPI.v"
	`include "IPs/APB_I2C.v"
	`include "IPs/AHBSRAM.v"
	`include "IPs/QSPI_XIP_CTRL.v"
	`include "IPs/RAM_3Kx32.v"
	`include "acc/AHB_SPM.v"
	`include "ibex/ibex_alu.v"
	`include "ibex/ibex_branch_predict.v"
	`include "ibex/ibex_compressed_decoder.v"
	`include "ibex/ibex_controller.v"
	`include "ibex/ibex_core.v"
	`include "ibex/ibex_counter.v"
	`include "ibex/ibex_cs_registers.v"
	`include "ibex/ibex_csr.v"
	`include "ibex/ibex_decoder.v"
	`include "ibex/ibex_dummy_instr.v"
	`include "ibex/ibex_ex_block.v"
	`include "ibex/ibex_fetch_fifo.v"
	`include "ibex/ibex_icache.v"
	`include "ibex/ibex_id_stage.v"
	`include "ibex/ibex_if_stage.v"
	`include "ibex/ibex_load_store_unit.v"
	`include "ibex/ibex_multdiv_fast.v"
	`include "ibex/ibex_multdiv_slow.v"
	`include "ibex/ibex_pmp.v"
	`include "ibex/ibex_prefetch_buffer.v"
	`include "ibex/ibex_register_file_latch.v"
	`include "ibex/ibex_wb_stage.v"
	`include "ibex/prim_clock_gating.v" 
	`include "ibex/ibex_register_file_ff.v"
	`include "ibex/ibex_wrapper.v"

	`include "soc_core.v"
	`include "user_project_wrapper.v"
`endif

`ifdef SIM
    // Behavoiral models for the simulation
    `include "sst26wf080b.v"
    `include "23LC512.v"
`endif