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
	A simple 32-bit timer
	TMR : 32-bit counter
	PRE: clock prescalar (tmer_clk = clk / (PRE+1))
	TMRCMP: Timer CMP register
	TMROV: Timer overflow (TMR>=TMRCMP)
	TMROVCLR: Control signal to clear the TMROV flag
*/


`timescale 1ns/1ps
`default_nettype none

module TIMER32 (
		input wire clk,
		input wire rst,
		output reg [31:0] TMR,
		input wire [31:0] PRE,
		input wire [31:0] TMRCMP,
		output reg TMROV,
		input wire TMROVCLR,
		input wire TMREN
	);

	reg [31:0] 	clkdiv;
	wire 		timer_clk = (clkdiv==PRE) ;
	wire 		tmrov = (TMR == TMRCMP);

	// Prescalar
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			clkdiv <= 32'd0;
		else if(timer_clk)
			clkdiv <= 32'd0;
		else if(TMREN)
			clkdiv <= clkdiv + 32'd1;
	end

	// Timer
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			TMR <= 32'd0;
		else if(tmrov)
			TMR <= 32'd0;
		else if(timer_clk)
			TMR <= TMR + 32'd1;
	end

	always @(posedge clk or posedge rst)
	begin
		if(rst)
			TMROV <= 1'd0;
		else if(TMROVCLR)
			TMROV <= 1'd0;
		else if(tmrov)
			TMROV <= 1'd1;
	end

endmodule
