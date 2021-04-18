// SPDX-FileCopyrightText: 2020 Mohamed Shalan
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


`timescale 1ns/1ps
`default_nettype none

module APB_I2C(
    //APB Inputs
    input wire PCLK,
    input wire PRESETn,
    input wire PWRITE,
    input wire [31:0] PWDATA,
    input wire [31:0] PADDR,
    input wire PENABLE,
    
    input PSEL,
    
    //APB Outputs
    output wire PREADY,
    output wire [31:0] PRDATA,

	output wire IRQ,

    // i2c Ports
    input 	wire scl_i,	    // SCL-line input
	output 	wire scl_o,	    // SCL-line output (always 1'b0)
	output 	wire scl_oen_o, // SCL-line output enable (active low)
	input	wire sda_i,     // SDA-line input
	output	wire sda_o,	    // SDA-line output (always 1'b0)
	output	wire sda_oen_o // SDA-line output enable (active low)
    
);

  assign PREADY = 1'b1; //always ready
  
  wire[7:0] io_do;
  wire io_we = PENABLE & PWRITE & PREADY & PSEL;
  wire io_re = PENABLE & ~PWRITE & PREADY & PSEL;

  wire i2c_irq;

  reg I2C_IM_REG;

  assign IRQ = i2c_irq & I2C_IM_REG;

  // IM Register -- Size: 1 -- Offset: 0x14
  always @(posedge PCLK, negedge PRESETn)
  begin
    if(!PRESETn)
    begin
      I2C_IM_REG <= 1'b0;
    end
    else if(PENABLE & PWRITE & PREADY & PSEL & (PADDR[4:2] == 3'h7))
      I2C_IM_REG <= PWDATA[0:0];
  end


  i2c_master i2c (
    		.sys_clk(PCLK),
    		.sys_rst(~PRESETn),
    		//
    		.io_a(PADDR[7:2]),
		    .io_di(PWDATA[7:0]),
			.io_do(io_do),
			.io_re(io_re),
			.io_we(io_we),
			//
			.i2c_irq(i2c_irq),
			//
			.scl_i(scl_i),	   // SCL-line input
			.scl_o(scl_o),	   // SCL-line output (always 1'b0)
			.scl_oen_o(scl_oen_o), // SCL-line output enable (active low)
			.sda_i(sda_i),		// SDA-line input
			.sda_o(sda_o),	   // SDA-line output (always 1'b0)
			.sda_oen_o(sda_oen_o)  // SDA-line output enable (active low)
	);
  
  assign PRDATA[31:0] = (PADDR[4:2] == 3'h7) ? I2C_IM_REG : io_do;//I2C_DATA_REG;
  
endmodule
