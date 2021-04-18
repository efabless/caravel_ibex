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
	A simple 32-bit PWM generator
	PRE: clock prescalar (tmer_clk = clk / (PRE+1))
	TMRCMP1: Timer CMP register (period)
	TMRCMP2: PWN level change Comparator

	PWM period = (TMRCMP1 + 1)/timer_clk = (TMRCMP1 + 1)*(PRE + 1)/clk
	PWM off cyle % = (TMRCMP1 + 1)/(TMRCMP2 + 1)
*/

`timescale 1ns/1ps
`default_nettype none

module PWM32 (
		input wire clk,
		input wire rst,
		input wire [31:0] PRE,
		input wire [31:0] TMRCMP1,
		input wire [31:0] TMRCMP2,
		input wire 				TMREN,
		output reg pwm
	);

	reg [31:0]	TMR;
	reg [31:0] 	clkdiv;
	wire 		timer_clk = (clkdiv==PRE) ;
	wire 		tmrov = (TMR == TMRCMP1);
	wire 		pwmov = (TMR == TMRCMP2);

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

	// PWM Output
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			pwm <= 1'd0;
		else if(pwmov)
			pwm <= 1'd1;
		else if (tmrov)
			pwm <= 1'd0;
	end

endmodule
