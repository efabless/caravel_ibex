// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`define IBEX_TEST_FILE     "ibex_spm.hex" 
`define CARAVEL_TEST_FILE  "caravel_spm.hex" 
`define SIM_LEVEL          0
`define SOC_SETUP_TIME     200*2001

`include "uprj_netlists.v"
`include "caravel_netlists.v"

`include "spiflash.v"

module spm_tb;
	reg clock;
    reg RSTB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;
	wire [7:0] mprj_io_0;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end
	
	// Serial Terminal connected to UART0 TX*/
    terminal term(.rx(mprj_io[21]));  // RsTx_Sys0_SS0_S0

    // SPI SRAM connected to SPI0
    wire SPI_HOLD = 1'b1;
    M23LC512 SPI_SRAM(
        .RESET(~RSTB),
        .SO_SIO1(mprj_io[24]),  // MSI_Sys0_SS0_S2
        .SI_SIO0(mprj_io[25]),  // MSO_Sys0_SS0_S2
        .CS_N(mprj_io[26]),     // SSn_Sys0_SS0_S2
        .SCK(mprj_io[27]),      // SCLK_Sys0_SS0_S2
        .HOLD_N_SIO3(SPI_HOLD)
	);

	initial begin
		// Load the application into the Ibex flash memory
		#1  $readmemh(`IBEX_TEST_FILE, flash.I0.memory);
		$display("---------Ibex Flash -----------");
		$display("Memory[0]: %0d, Memory[1]: %0d, Memory[2]: %0d, Memory[3]: %0d", 
            flash.I0.memory[0], flash.I0.memory[1], flash.I0.memory[2], flash.I0.memory[3]);
	end

	initial begin
		$dumpfile("spm.vcd");
		$dumpvars(0, spm_tb);
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1;	    // Release reset
		#(`SOC_SETUP_TIME);
		wait(mprj_io[7:0] == 8'hA4);
	    $finish;
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
		#200;
		power3 <= 1'b1;
		#200;
		power4 <= 1'b1;
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire USER_VDD3V3 = power3;
	wire USER_VDD1V8 = power4;
	wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
        .mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME(`CARAVEL_TEST_FILE)
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

	/* Ibex Flash */
    sst26wf080b flash(
        .SCK(mprj_io[18]),     // fsclk
        .SIO(mprj_io[17:14]),  // fdo
        .CEb(mprj_io[19])      // fcen
    );

endmodule

module terminal #(parameter bit_time = 400) (input rx);

    integer i;
    reg [7:0] char;
    initial begin
        forever begin
            @(negedge rx);
            i = 0;
            char = 0;
            #(3*bit_time/2);
            for(i=0; i<8; i=i+1) begin
                char[i] = rx;
                #bit_time;
            end
            $write("%c", char);
        end
    end


endmodule
`default_nettype wire