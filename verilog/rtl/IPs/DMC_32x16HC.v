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

/*
    Hand-crafted 32 lines x 16 bytes Direct Mapped Cache
    It can operate @ 200MHz clock!
    Number of instances: 10654
    ICG cells are used to reduce dynamic power consumption
    A custom clock tree is embedded
*/

module HWORD (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input WE,
    input SELW,
    input SELR,
    input [15:0] Di,
    output [15:0] Do
);

    wire [15:0]  q_wire;
    wire        we_wire;
    wire        SEL_B;
    wire        GCLK;

    sky130_fd_sc_hd__inv_2 INV(
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL_B), .A(SELR));
    
    sky130_fd_sc_hd__and2_1 CGAND( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .A(SELW), .B(WE), .X(we_wire) );

    sky130_fd_sc_hd__dlclkp_1 CG( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .CLK(CLK), .GCLK(GCLK), .GATE(we_wire) );

    generate 
        genvar i;
        for(i=0; i<16; i=i+1) begin : BIT
            sky130_fd_sc_hd__dfxtp_1 FF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                .D(Di[i]), .Q(q_wire[i]), .CLK(GCLK) );

            sky130_fd_sc_hd__ebufn_2 OBUF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                .A(q_wire[i]), .Z(Do[i]), .TE_B(SEL_B) );
        end
    endgenerate 

endmodule


module LINE16 (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input WE,
    input SELW,
    input SELR,
    input [127:0] Di,
    output [127:0] Do
);

    wire [7:0] CLK_buf;

    sky130_fd_sc_hd__clkbuf_4 CLKBUF[7:0] ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
                .X(CLK_buf), 
                .A(CLK)
            );
    generate 
        genvar i;
        for(i=0; i<8; i=i+1)
            HWORD HW ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .CLK(CLK_buf[i]), .WE(WE), .SELW(SELW), .SELR(SELR), .Di(Di[i*16+15:i*16]), .Do(Do[i*16+15:i*16]) );
    endgenerate

endmodule 

module DEC2x4_DMC (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input   [1:0]   A,
    output  [3:0]   SEL
);
    sky130_fd_sc_hd__nor2_2    AND0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0]), .A(A[0]),   .B(A[1]) );
    
    sky130_fd_sc_hd__and2b_2    AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1]), .A_N(A[1]), .B(A[0]) );
    sky130_fd_sc_hd__and2b_2    AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2]), .A_N(A[0]), .B(A[1]) );
    
    sky130_fd_sc_hd__and2_2     AND3 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[3]), .A(A[1]),   .B(A[0]) );
    
endmodule

module DEC3x8_DMC (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input           EN,
    input [2:0]     A,
    output [7:0]    SEL
);

    wire [2:0] A_buf;
   
    sky130_fd_sc_hd__clkbuf_2 ABUF[2:0] (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(A_buf), .A(A));
   
    sky130_fd_sc_hd__nor4b_4   AND0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0])  , .A(A_buf[0]), .B(A_buf[1]), .C(A_buf[2]), .D_N(EN) ); // 000
   
    sky130_fd_sc_hd__and4bb_4   AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1])  , .A_N(A_buf[2]), .B_N(A_buf[1]), .C(A_buf[0])  , .D(EN) ); // 001
   
    sky130_fd_sc_hd__and4bb_4   AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2])  , .A_N(A_buf[2]), .B_N(A_buf[0]), .C(A_buf[1])  , .D(EN) ); // 010
    sky130_fd_sc_hd__and4b_4    AND3 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[3])  , .A_N(A_buf[2]), .B(A_buf[1]), .C(A_buf[0])  , .D(EN) );   // 011
    sky130_fd_sc_hd__and4bb_4   AND4 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[4])  , .A_N(A_buf[0]), .B_N(A_buf[1]), .C(A_buf[2])  , .D(EN) ); // 100
    sky130_fd_sc_hd__and4b_4    AND5 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[5])  , .A_N(A_buf[1]), .B(A_buf[0]), .C(A_buf[2])  , .D(EN) );   // 101
    sky130_fd_sc_hd__and4b_4    AND6 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[6])  , .A_N(A_buf[0]), .B(A_buf[1]), .C(A_buf[2])  , .D(EN) );   // 110
    sky130_fd_sc_hd__and4_4     AND7 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[7])  , .A(A_buf[0]), .B(A_buf[1]), .C(A_buf[2])  , .D(EN) ); // 111
endmodule

module DEC5x32_DMC (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input   [4:0]   A,
    output  [31:0]   SEL
);
    wire [3:0] en;
    DEC2x4_DMC DEC0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif 
        .A(A[4:3]), .SEL(en) );

    generate 
        genvar i;
        for(i=0; i<4; i=i+1)
            DEC3x8_DMC DEC1 ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .A(A[2:0]), .EN(en[i]), .SEL(SEL[i*8+7:i*8]) );

    endgenerate

endmodule
/*
module MUX4x1_32(
    input   [31:0]      A0, A1, A2, A3,
    input   [1:0]       S,
    output  [31:0]      X
);
    sky130_fd_sc_hd__mux4_1 MUX[31:0] (.A0(A0), .A1(A1), .A2(A2), .A3(A3), .S0(S[0]), .S1(S[1]), .X(X) );
endmodule
*/
module OVERHEAD(
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input RSTn,
    input SELR, SELW,
    input VDi,
    output VDo,
    input[14:0] TDi,
    output [14:0] TDo,
    input WE
);

    wire SEL_B;
    wire GCLK;
    wire we_wire;
    wire[15:0] q_wire;
    
    sky130_fd_sc_hd__inv_2 INV(
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL_B), .A(SELR));
    sky130_fd_sc_hd__and2_4 CGAND( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .A(SELW), .B(WE), .X(we_wire) );
    sky130_fd_sc_hd__dlclkp_1 CG( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .CLK(CLK), .GCLK(GCLK), .GATE(we_wire) );

    // Valid Bit
    sky130_fd_sc_hd__dfrtp_1 V( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Q(q_wire[15]), .CLK(GCLK), .D(VDi), .RESET_B(RSTn) );
    sky130_fd_sc_hd__ebufn_2 VOBUF ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .A(q_wire[15]), .Z(VDo), .TE_B(SEL_B) );

    // 15-bit TAG
    generate 
        genvar i;
        for(i=0; i<15; i=i+1) begin : VALID
            sky130_fd_sc_hd__dfxtp_1 FF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
             `endif
                .D(TDi[i]), .Q(q_wire[i]), .CLK(GCLK) );
            sky130_fd_sc_hd__ebufn_2 TOBUF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                .A(q_wire[i]), .Z(TDo[i]), .TE_B(SEL_B) );
        end
    endgenerate 

endmodule

module DMC_32x16HC (
`ifdef USE_POWER_PINS
    input vccd1,
    input vssd1,
`endif
    input wire          clk,
    input wire          rst_n,
    // A [23:2]
    input wire  [21:0]  A,
    // A[23:4]
    input wire  [19:0]  A_h,
    output wire [31:0]  Do,
    output wire         hit,
    //
    input wire [127:0]  line,
    input wire          wr
);

    wire [127:0] data;
    wire [1:0]  offset  = A[1:0];
    wire [4:0]  index   = A[6:2];
    wire [14:0] tag     = A[21:7];

    wire [4:0]  index_h   = A_h[4:0];
    wire [14:0] tag_h     = A_h[19:5];

    wire c_valid;
    wire[14:0] c_tag;

    wire [31:0] SELH, SEL;

    wire CLK_buf;

    wire hi;

    DEC5x32_DMC DECH ( 
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .A(index_h), .SEL(SELH) );
    
    DEC5x32_DMC DEC (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif 
        .A(index), .SEL(SEL) );

    sky130_fd_sc_hd__conb_1 TIE (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
        .VPB(vccd1),
        .VNB(vssd1),
    `endif
        .LO(), .HI(hi));

    sky130_fd_sc_hd__clkbuf_16 CLKBUF (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
        .VPB(vccd1),
        .VNB(vssd1),
    `endif
        .X(CLK_buf), .A(clk));

    OVERHEAD OVHB [31:0] (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .CLK(clk),
        .RSTn(rst_n),
        .SELR(SELH), 
        .SELW(SEL),
        .VDi(hi),
        .VDo(c_valid),
        .TDi(tag),
        .TDo(c_tag),
        .WE(wr)
    );

    LINE16 DATA [31:0] (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .CLK(clk),
        .WE(wr),
        .SELR(SEL), 
        .SELW(SEL),
        .Di(line),
        .Do(data)
    );

    assign  hit =   c_valid & (c_tag == tag_h);

    MUX4x1_ MUX ( 
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
    `endif
        .A0(data[31:0]), .A1(data[63:32]), .A2(data[95:64] ), .A3(data[127:96]), .S(offset[1:0]), .X(Do) );
/*
    assign  Do  =   (offset[3:2] == 2'd0) ?  data[31:0] :
                    (offset[3:2] == 2'd1) ?  data[63:32] :
                    (offset[3:2] == 2'd2) ?  data[95:64] :
                    data[127:96];
*/
endmodule

