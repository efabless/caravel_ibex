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


`timescale 1ns / 1ps
`default_nettype none

module RAM_3Kx32 (
`ifdef USE_POWER_PINS
	vccd1,
	vssd1,
`endif
    CLK,
    WE,
    EN,
    Di,
    Do,
    A
);

`ifdef USE_POWER_PINS
	input vccd1;
	input vssd1;
`endif

    input           CLK;
    input   [3:0]   WE;
    input           EN;
    input   [31:0]  Di;
    output  [31:0]  Do;
    input   [11:0]   A;

    localparam BLOCKS=3;
    wire  [3:0]       _EN_ ;
    wire [31:0] _Do_ [BLOCKS-1:0];
    wire [31:0] Do_pre;
    wire [11:10] A_buf;

    generate 
        genvar gi;
        for(gi=0; gi<BLOCKS; gi=gi+1) 

`ifdef USE_DFFRAM_BEH
	DFFRAM_beh 
`else
	DFFRAM_4K
`endif
            #(.COLS(4)) RAM (
                .CLK(CLK),
                .WE(WE),
                .EN(_EN_[gi]),
                .Di(Di),
                .Do(_Do_[gi]),
                .A(A[9:0])
            );
        
    endgenerate 
    
    sky130_fd_sc_hd__clkbuf_8 ABUF[11:10] (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .X(A_buf), .A(A[11:10]));

    MUX4x1_32 MUX ( 
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .A0(_Do_[0]), .A1(_Do_[1]), .A2(_Do_[2]), .A3(32'b0), .S(A_buf), .X(Do_pre) );
    DEC2x4 DEC ( 
     `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .EN(EN), .A(A[11:10]), .SEL(_EN_) );

    sky130_fd_sc_hd__clkbuf_4 DOBUF[31:0] (
     `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .X(Do), .A(Do_pre));
    
endmodule
