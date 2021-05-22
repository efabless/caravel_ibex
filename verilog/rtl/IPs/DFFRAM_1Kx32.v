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
    Author: Mohamed Shalan (mshalan@aucegypt.edu)
*/

module DFFRAM_1Kx32 #(parameter  USE_LATCH=0,
                            WSIZE=4 ) 
(
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input   wire               CLK,    // FO: 1
    input   wire [WSIZE-1:0]    WE,     // FO: 1
    input                       EN,     // FO: 1
    input   wire [9:0]           A,      // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
    
);

    wire                    CLK_buf;
    wire [WSIZE-1:0]         WE_buf;
    wire                    EN_buf;
    wire [9:0]             A_buf;
    wire [(WSIZE*8-1):0]     Di_buf;
    wire [1:0]              SEL;

    wire [(WSIZE*8-1):0]    Do_pre[WSIZE-1:0]; 
                            
    // Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(Di_buf),  .A(Di));
    
    sky130_fd_sc_hd__clkbuf_4   CLKBUF              (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(CLK_buf), .A(CLK));
    
    sky130_fd_sc_hd__clkbuf_2   WEBUF[WSIZE-1:0]     (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(WE_buf),  .A(WE));
    
    sky130_fd_sc_hd__clkbuf_2   ENBUF               (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(EN_buf),  .A(EN));
    
    sky130_fd_sc_hd__clkbuf_2   ABUF[9:0]           (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(A_buf),   .A(A));

    // 1x2 DEC
    DEC1x2_ DEC1x2(
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .EN(EN),
        .A(A[7]),
        .SEL(SEL)
    );

     generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM512_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM512 (
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif
                .CLK(CLK_buf), .EN(SEL[i]), .WE(WE_buf), .Di(Di_buf), .Do(Do_pre[i]), .A(A_buf[8:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1_ #(.WIDTH(WSIZE*8)) DoMUX ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A[7]), .X(Do) );


endmodule

// module DFFRAM_1K #(parameter USE_LATCH=`DFFRAM_USE_LATCH,
//                             SIZE=`DFFRAM_SIZE ) 
// (
// `ifdef USE_POWER_PINS
//     input wire VPWR,
//     input wire VGND,
// `endif
//     input   wire                CLK,    // FO: 2
//     input   wire [SIZE-1:0]     WE,     // FO: 2
//     input                       EN,     // FO: 2
//     input   wire [7:0]          A,      // FO: 5
//     input   wire [(SIZE*8-1):0] Di,     // FO: 2
//     output  wire [(SIZE*8-1):0] Do

// );

//     wire [1:0]             SEL;
//     wire [(SIZE*8-1):0]    Do_pre[SIZE-1:0]; 

//     // 1x2 DEC
//     DEC1x2_ DEC1x2(
//     `ifdef USE_POWER_PINS
//         .VPWR(VPWR),
//         .VGND(VGND),
//     `endif
//         .EN(EN),
//         .A(A[7]),
//         .SEL(SEL)
//     );

//     generate
//         genvar i;
//         for (i=0; i< 2; i=i+1) begin : BLOCK
//             RAM128_ #(.USE_LATCH(USE_LATCH), .SIZE(SIZE)) RAM128 (
//             `ifdef USE_POWER_PINS
//                 .VPWR(VPWR),
//                 .VGND(VGND),
//             `endif
//                 .CLK(CLK), .EN(SEL[i]), .WE(WE), .Di(Di), .Do(Do_pre[i]), .A(A[6:0]) );        
//         end
//      endgenerate

//     // Output MUX    
//     MUX2x1_ #(.WIDTH(SIZE*8)) DoMUX ( 
//     `ifdef USE_POWER_PINS
//         .VPWR(VPWR),
//         .VGND(VGND),
//     `endif
//         .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A[7]), .X(Do) );

// endmodule