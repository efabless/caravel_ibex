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


/*
	A simple 32-bit watchdog timer
	WDTMR	: 32-bit down counter
	WDLOAD	: 32-bit load value
	WDOV	: WD Timer overflow (WDTMR==0)
	TMROVCLR: Control signal to clear the WDOV flag
*/


`timescale 1ns/1ps
`default_nettype none

module WDT32 (
		input wire clk,
		input wire rst,
		output reg [31:0] WDTMR,
		input wire [31:0] WDLOAD,
		output reg WDOV,
		input wire WDOVCLR,
		input wire WDEN
);

	wire	wdov = (WDTMR == 32'd0);
	
	// WDTimer
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			WDTMR <= 32'h0;
		else if(wdov & WDEN)
			WDTMR <= WDLOAD;
		else if(WDEN)
			WDTMR <= WDTMR - 32'd1;
		else if(~WDEN)
		  WDTMR <= 32'h0;
	end
	
	reg wden_p;
	always @(posedge clk) 
	  wden_p <= WDEN;

	always @(posedge clk or posedge rst)
	begin
		if(rst)
			WDOV <= 1'd0;
		else if(WDOVCLR)
			WDOV <= 1'd0;
		else if(wdov & wden_p)
			WDOV <= 1'd1;
	end

endmodule