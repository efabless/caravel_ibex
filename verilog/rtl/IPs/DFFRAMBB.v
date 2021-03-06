/*
    Copyright ©2020-2021 The American University in Cairo and the Cloud V Project.

    This file is part of the DFFRAM Memory Compiler.
    See https://github.com/Cloud-V/DFFRAM for further info.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

// Add 1x2 binary decoder
`default_nettype none

module DEC1x2_ (
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input wire   EN,
    input  wire   A,
    output wire [1:0]   SEL
);

    sky130_fd_sc_hd__and2b_2 AND0 (
    `ifdef USE_POWER_PINS
            .VPWR(VPWR),
            .VGND(VGND),
            .VPB(VPWR),
            .VNB(VGND),
    `endif

        .X(SEL[0]),
        .A_N(A),
        .B(EN)
    );

    sky130_fd_sc_hd__and2_2 AND1 (
    `ifdef USE_POWER_PINS
            .VPWR(VPWR),
            .VGND(VGND),
            .VPB(VPWR),
            .VNB(VGND),
    `endif

        .X(SEL[1]),
        .A(A) ,
        .B(EN)
    );

endmodule

module DEC2x3_ (
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input           EN,
    input   [1:0]   A,
    output  [2:0]   SEL
);
    sky130_fd_sc_hd__nor3b_4    AND0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0]), .A(A[0]),   .B(A[1]), .C_N(EN) );
    
    sky130_fd_sc_hd__and3b_4    AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1]), .A_N(A[1]), .B(A[0]), .C(EN) );

    sky130_fd_sc_hd__and3b_4    AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2]), .A_N(A[0]), .B(A[1]), .C(EN) );
    
endmodule

module DEC2x4_ (
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input           EN,
    input   [1:0]   A,
    output  [3:0]   SEL
);
    sky130_fd_sc_hd__nor3b_4    AND0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0]), .A(A[0]),   .B(A[1]), .C_N(EN) );
    sky130_fd_sc_hd__and3b_4    AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1]), .A_N(A[1]), .B(A[0]), .C(EN) );
    sky130_fd_sc_hd__and3b_4    AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2]), .A_N(A[0]), .B(A[1]), .C(EN) );
    sky130_fd_sc_hd__and3_4     AND3 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[3]), .A(A[1]),   .B(A[0]), .C(EN) );
    
endmodule

module DEC3x8_ (
    input           EN,
    input [2:0]     A,
    output [7:0]    SEL
);

    wire [2:0]  A_buf;
    wire        EN_buf;

    sky130_fd_sc_hd__clkbuf_2 ABUF[2:0] (.X(A_buf), .A(A));
    sky130_fd_sc_hd__clkbuf_2 ENBUF (.X(EN_buf), .A(EN));
    
    sky130_fd_sc_hd__nor4b_2   AND0 ( .Y(SEL[0])  , .A(A_buf[0]), .B(A_buf[1])  , .C(A_buf[2]), .D_N(EN_buf) ); // 000
    sky130_fd_sc_hd__and4bb_2   AND1 ( .X(SEL[1])  , .A_N(A_buf[2]), .B_N(A_buf[1]), .C(A_buf[0])  , .D(EN_buf) ); // 001
    sky130_fd_sc_hd__and4bb_2   AND2 ( .X(SEL[2])  , .A_N(A_buf[2]), .B_N(A_buf[0]), .C(A_buf[1])  , .D(EN_buf) ); // 010
    sky130_fd_sc_hd__and4b_2    AND3 ( .X(SEL[3])  , .A_N(A_buf[2]), .B(A_buf[1]), .C(A_buf[0])  , .D(EN_buf) );   // 011
    sky130_fd_sc_hd__and4bb_2   AND4 ( .X(SEL[4])  , .A_N(A_buf[0]), .B_N(A_buf[1]), .C(A_buf[2])  , .D(EN_buf) ); // 100
    sky130_fd_sc_hd__and4b_2    AND5 ( .X(SEL[5])  , .A_N(A_buf[1]), .B(A_buf[0]), .C(A_buf[2])  , .D(EN_buf) );   // 101
    sky130_fd_sc_hd__and4b_2    AND6 ( .X(SEL[6])  , .A_N(A_buf[0]), .B(A_buf[1]), .C(A_buf[2])  , .D(EN_buf) );   // 110
    sky130_fd_sc_hd__and4_2     AND7 ( .X(SEL[7])  , .A(A_buf[0]), .B(A_buf[1]), .C(A_buf[2])  , .D(EN_buf) ); // 111
endmodule

module MUX4x1_ #(parameter   WIDTH=32)
(
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input   wire [WIDTH-1:0]     A0, A1, A2, A3,
    input   wire [1:0]          S,
    output  wire [WIDTH-1:0]     X
);
    localparam SIZE = WIDTH/8;
    wire [SIZE-1:0] SEL0, SEL1;
    sky130_fd_sc_hd__clkbuf_2 SEL0BUF[SIZE-1:0] (
     `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL0), .A(S[0]));
    
    sky130_fd_sc_hd__clkbuf_2 SEL1BUF[SIZE-1:0] (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL1), .A(S[1]));
    
    generate
        genvar i;
        for(i=0; i<SIZE; i=i+1) begin : M
            sky130_fd_sc_hd__mux4_1 MUX[7:0] (
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                    .A0(A0[(i+1)*8-1:i*8]), 
                    .A1(A1[(i+1)*8-1:i*8]), 
                    .A2(A2[(i+1)*8-1:i*8]), 
                    .A3(A3[(i+1)*8-1:i*8]), 
                    .S0(SEL0[i]), 
                    .S1(SEL1[i]), 
                    .X(X[(i+1)*8-1:i*8]) );        
        end
    endgenerate
endmodule

module MUX2x1_ #(parameter   WIDTH=32)
(
    input   wire [WIDTH-1:0]     A0, A1, A2, A3,
    input   wire           S,
    output  wire [WIDTH-1:0]     X
);
    localparam SIZE = WIDTH/8;
    wire [SIZE-1:0] SEL;
    sky130_fd_sc_hd__clkbuf_2 SELBUF[SIZE-1:0] (.X(SEL), .A(S));
    generate
        genvar i;
        for(i=0; i<SIZE; i=i+1) begin : M
            sky130_fd_sc_hd__mux2_1 MUX[7:0] (.A0(A0[(i+1)*8-1:i*8]), .A1(A1[(i+1)*8-1:i*8]), .S(SEL[i]), .X(X[(i+1)*8-1:i*8]) );
        end
    endgenerate
endmodule

module BYTE_ #(  parameter   USE_LATCH=0)( 
    input   wire        CLK,    // FO: 1
    input   wire        WE,     // FO: 1
    input   wire        SEL,    // FO: 2
    input   wire [7:0]  Di,     // FO: 1
    output  wire [7:0]  Do
);

    wire [7:0]  q_wire;
    wire        we_wire;
    wire        SEL_B;
    wire        GCLK;
    wire        CLK_B;

    generate 
        genvar i;

        if(USE_LATCH == 1) begin
            sky130_fd_sc_hd__inv_1 CLKINV(.Y(CLK_B), .A(CLK));
            sky130_fd_sc_hd__dlclkp_1 CG( .CLK(CLK_B), .GCLK(GCLK), .GATE(we_wire) );
        end else
            sky130_fd_sc_hd__dlclkp_1 CG( .CLK(CLK), .GCLK(GCLK), .GATE(we_wire) );
    
        sky130_fd_sc_hd__inv_1 SELINV(.Y(SEL_B), .A(SEL));
        sky130_fd_sc_hd__and2_1 CGAND( .A(SEL), .B(WE), .X(we_wire) );
    
        for(i=0; i<8; i=i+1) begin : BIT
            if(USE_LATCH == 0)
                sky130_fd_sc_hd__dfxtp_1 FF ( .D(Di[i]), .Q(q_wire[i]), .CLK(GCLK) );
            else 
                sky130_fd_sc_hd__dlxtp_1 LATCH (.Q(q_wire[i]), .D(Di[i]), .GATE(GCLK) );
            sky130_fd_sc_hd__ebufn_2 OBUF ( .A(q_wire[i]), .Z(Do[i]), .TE_B(SEL_B) );
        end
    endgenerate 
  
endmodule

module BYTE_1RW1R_ #(  parameter   USE_LATCH=0)( 
    input   wire        CLK,    // FO: 1
    input   wire        WE,     // FO: 1
    input   wire        SEL0,   // FO: 2
    input   wire        SEL1,   // FO: 2
    input   wire [7:0]  Di,     // FO: 1
    output  wire [7:0]  Do0,
    output  wire [7:0]  Do1
);

    wire [7:0]  q_wire;
    wire        we_wire;
    wire        SEL0_B, SEL1_B;
    wire        GCLK;
    wire        CLK_B;

    generate 
        genvar i;

        if(USE_LATCH == 1) begin
            sky130_fd_sc_hd__inv_1 CLKINV(.Y(CLK_B), .A(CLK));
            sky130_fd_sc_hd__dlclkp_1 CG( .CLK(CLK_B), .GCLK(GCLK), .GATE(we_wire) );
        end else
            sky130_fd_sc_hd__dlclkp_1 CG( .CLK(CLK), .GCLK(GCLK), .GATE(we_wire) );
    
        sky130_fd_sc_hd__inv_1 SEL0INV (.Y(SEL0_B), .A(SEL0));
        sky130_fd_sc_hd__inv_1 SEL1INV (.Y(SEL1_B), .A(SEL1));
        sky130_fd_sc_hd__and2_1 CGAND( .A(SEL0), .B(WE), .X(we_wire) );
    
        for(i=0; i<8; i=i+1) begin : BIT
            if(USE_LATCH == 0)
                sky130_fd_sc_hd__dfxtp_1 FF ( .D(Di[i]), .Q(q_wire[i]), .CLK(GCLK) );
            else 
                sky130_fd_sc_hd__dlxtp_1 LATCH (.Q(q_wire[i]), .D(Di[i]), .GATE(GCLK) );

            sky130_fd_sc_hd__ebufn_2 OBUF0 ( .A(q_wire[i]), .Z(Do0[i]), .TE_B(SEL0_B) );
            sky130_fd_sc_hd__ebufn_2 OBUF1 ( .A(q_wire[i]), .Z(Do1[i]), .TE_B(SEL1_B) );
        end
    endgenerate 
  
endmodule

module WORD_ #( parameter    USE_LATCH=0,
                            WSIZE=4 ) (
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input   wire                SEL,    // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
);

    wire SEL_buf;
    wire CLK_buf;
    sky130_fd_sc_hd__clkbuf_2 SELBUF (.X(SEL_buf), .A(SEL));
    sky130_fd_sc_hd__clkbuf_1 CLKBUF (.X(CLK_buf), .A(CLK));
    generate
        genvar i;
            for(i=0; i<WSIZE; i=i+1) begin : BYTE
                BYTE_ #(.USE_LATCH(USE_LATCH)) B ( .CLK(CLK_buf), .WE(WE[i]), .SEL(SEL_buf), .Di(Di[(i+1)*8-1:i*8]), .Do(Do[(i+1)*8-1:i*8]) );
            end
    endgenerate
    
endmodule 

module WORD_1RW1R_ #( parameter  USE_LATCH=0,
                                WSIZE=4 ) (
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input   wire                SEL0,    // FO: 1
    input   wire                SEL1,    // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do0,
    output  wire [(WSIZE*8-1):0] Do1
);

    wire SEL0_buf, SEL1_buf;
    wire CLK_buf;
    sky130_fd_sc_hd__clkbuf_2 SEL0BUF (.X(SEL0_buf), .A(SEL0));
    sky130_fd_sc_hd__clkbuf_2 SEL1BUF (.X(SEL1_buf), .A(SEL1));
    sky130_fd_sc_hd__clkbuf_1 CLKBUF (.X(CLK_buf), .A(CLK));
    generate
        genvar i;
            for(i=0; i<WSIZE; i=i+1) begin : BYTE
                BYTE_1RW1R_ #(.USE_LATCH(USE_LATCH)) B ( 
                    .CLK(CLK_buf), 
                    .WE(WE[i]), 
                    .SEL0(SEL0_buf), 
                    .SEL1(SEL1_buf), 
                    .Di(Di[(i+1)*8-1:i*8]), 
                    .Do0(Do0[(i+1)*8-1:i*8]),
                    .Do1(Do1[(i+1)*8-1:i*8])  
                );
            end
    endgenerate
    
endmodule 

module RAM8_ #( parameter    USE_LATCH=0,
                            WSIZE=4 ) (
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN,     // EN: 1
    input   wire [2:0]          A,      // A: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
);

    wire    [7:0]        SEL;
    wire    [WSIZE-1:0]   WE_buf; 
    wire                 CLK_buf;

    DEC3x8_ DEC (.EN(EN), .A(A), .SEL(SEL));
    sky130_fd_sc_hd__clkbuf_2 WEBUF[WSIZE-1:0] (.X(WE_buf), .A(WE));
    sky130_fd_sc_hd__clkbuf_2 CLKBUF (.X(CLK_buf), .A(CLK));

    generate
        genvar i;
        for (i=0; i< 8; i=i+1) begin : WORD
            WORD_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) W ( .CLK(CLK_buf), .WE(WE_buf), .SEL(SEL[i]), .Di(Di), .Do(Do) );
        end
    endgenerate

endmodule

module RAM8_1RW1R_ #( parameter     USE_LATCH=0,
                                    WSIZE=4 ) (
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN0,     // EN: 1
    input                       EN1,
    input   wire [2:0]          A0,     // A: 1
    input   wire [2:0]          A1,     // A: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do0,
    output  wire [(WSIZE*8-1):0] Do1
);

    wire    [7:0]          SEL0, SEL1;
    wire    [WSIZE-1:0]     WE_buf; 
    wire                   CLK_buf;

    DEC3x8_ DEC0 (.EN(EN0), .A(A0), .SEL(SEL0));
    DEC3x8_ DEC1 (.EN(EN1), .A(A1), .SEL(SEL1));
    
    sky130_fd_sc_hd__clkbuf_2 WEBUF[(WSIZE-1):0]   (.X(WE_buf), .A(WE));
    sky130_fd_sc_hd__clkbuf_2 CLKBUF (.X(CLK_buf), .A(CLK));

    generate
        genvar i;
        for (i=0; i< 8; i=i+1) begin : WORD
            WORD_1RW1R_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) W ( 
                .CLK(CLK_buf), 
                .WE(WE_buf), 
                .SEL0(SEL0[i]),
                .SEL1(SEL1[i]),
                .Di(Di), 
                .Do0(Do0),
                .Do1(Do1) 
            );
        end
    endgenerate

endmodule

// 4 x RAM8 slices (128 bytes) with registered outout 
module RAM32_ #( parameter   USE_LATCH=0,
                            WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN,     // FO: 1
    input   wire [4:0]          A,      // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
    
);
    wire [3:0]          SEL;
    wire [4:0]          A_buf;
    wire                CLK_buf;
    wire [WSIZE-1:0]     WE_buf;
    wire                EN_buf;

    wire [(WSIZE*8-1):0] Do_pre;
    wire [(WSIZE*8-1):0] Di_buf;

    // Buffers
    // Di Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (.X(Di_buf), .A(Di));
    // Control signals buffers
    sky130_fd_sc_hd__clkbuf_2   CLKBUF              (.X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_2   WEBUF[(WSIZE-1):0]   (.X(WE_buf), .A(WE));
    sky130_fd_sc_hd__clkbuf_2   ABUF[4:0]           (.X(A_buf), .A(A[4:0]));
    sky130_fd_sc_hd__clkbuf_2   ENBUF               (.X(EN_buf), .A(EN));

    DEC2x4_ DEC (.EN(EN_buf), .A(A_buf[4:3]), .SEL(SEL));

    generate
        genvar i;
        for (i=0; i< 4; i=i+1) begin : SLICE
            RAM8_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM8 (.CLK(CLK_buf), .WE(WE_buf),.EN(SEL[i]), .Di(Di_buf), .Do(Do_pre), .A(A_buf[2:0]) ); 
        end
    endgenerate

    // Ensure that the Do_pre lines are not floating when EN = 0
    wire [WSIZE-1:0] lo;
    wire [WSIZE-1:0] float_buf_en;
    sky130_fd_sc_hd__clkbuf_2   FBUFENBUF[WSIZE-1:0] ( .X(float_buf_en), .A(EN) );
    sky130_fd_sc_hd__conb_1     TIE[WSIZE-1:0] (.LO(lo), .HI());

    // Following split by group because each is done by one TIE CELL and ONE CLKINV_4
    // Provides default values for floating lines (lo)
    generate
        for (i=0; i< WSIZE; i=i+1) begin : BYTE
            sky130_fd_sc_hd__ebufn_2 FLOATBUF[(8*(i+1))-1:8*i] ( .A( lo[i] ), .Z(Do_pre[(8*(i+1))-1:8*i]), .TE_B(float_buf_en[i]) );        
        end
    endgenerate
    
    sky130_fd_sc_hd__dfxtp_1 Do_FF[WSIZE*8-1:0] ( .D(Do_pre), .Q(Do), .CLK(CLK) );

endmodule

module RAM32_1RW1R_ #( parameter     USE_LATCH=0,
                                    WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN0,    // FO: 1
    input                       EN1,
    input   wire [4:0]          A0,     // FO: 1
    input   wire [4:0]          A1,
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do0,
    output  wire [(WSIZE*8-1):0] Do1
    
);
    wire [3:0]          SEL0, SEL1;
    wire [4:0]          A0_buf, A1_buf;
    wire                CLK_buf;
    wire [WSIZE-1:0]     WE_buf;
    wire                EN0_buf, EN1_buf;

    wire [(WSIZE*8-1):0] Do0_pre, Do1_pre;
    wire [(WSIZE*8-1):0] Di_buf;

    // Buffers
    // Di Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (.X(Di_buf), .A(Di));
    // Control signals buffers
    sky130_fd_sc_hd__clkbuf_2   CLKBUF              (.X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_2   WEBUF[(WSIZE-1):0]   (.X(WE_buf), .A(WE));
    sky130_fd_sc_hd__clkbuf_2   A0BUF[4:0]           (.X(A0_buf), .A(A0));
    sky130_fd_sc_hd__clkbuf_2   A1BUF[4:0]           (.X(A1_buf), .A(A1));
    sky130_fd_sc_hd__clkbuf_2   EN0BUF               (.X(EN0_buf), .A(EN0));
    sky130_fd_sc_hd__clkbuf_2   EN1BUF               (.X(EN1_buf), .A(EN1));

    DEC2x4_ DEC0 (.EN(EN0_buf), .A(A0_buf[4:3]), .SEL(SEL0));
    DEC2x4_ DEC1 (.EN(EN1_buf), .A(A1_buf[4:3]), .SEL(SEL1));


    generate
        genvar i;
        for (i=0; i< 4; i=i+1) begin : SLICE
            RAM8_1RW1R_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM8 (
                .CLK(CLK_buf), 
                .WE(WE_buf),
                .EN0(SEL0[i]), 
                .EN1(SEL1[i]), 
                .Di(Di_buf), 
                .Do0(Do0_pre), 
                .Do1(Do1_pre), 
                .A0(A0_buf[2:0]),
                .A1(A1_buf[2:0])  
            ); 
        end
    endgenerate

    // Ensure that the Do_pre lines are not floating when EN = 0
    wire [WSIZE-1:0] lo0, lo1;
    wire [WSIZE-1:0] float_buf_en0, float_buf_en1;
    sky130_fd_sc_hd__clkbuf_2   FBUFENBUF0[WSIZE-1:0] ( .X(float_buf_en0), .A(EN0) );
    sky130_fd_sc_hd__clkbuf_2   FBUFENBUF1[WSIZE-1:0] ( .X(float_buf_en1), .A(EN1) );
    sky130_fd_sc_hd__conb_1     TIE0[WSIZE-1:0] (.LO(lo0), .HI());
    sky130_fd_sc_hd__conb_1     TIE1[WSIZE-1:0] (.LO(lo1), .HI());
    

    // Following split by group because each is done by one TIE CELL and ONE CLKINV_4
    // Provides default values for floating lines (lo)
    generate
        for (i=0; i< WSIZE; i=i+1) begin : BYTE
            sky130_fd_sc_hd__ebufn_2 FLOATBUF0[(8*(i+1))-1:8*i] ( .A( lo0[i] ), .Z(Do0_pre[(8*(i+1))-1:8*i]), .TE_B(float_buf_en0[i]) );
            sky130_fd_sc_hd__ebufn_2 FLOATBUF1[(8*(i+1))-1:8*i] ( .A( lo1[i] ), .Z(Do1_pre[(8*(i+1))-1:8*i]), .TE_B(float_buf_en1[i]) );
        end
    endgenerate
    
    sky130_fd_sc_hd__dfxtp_1 Do0_FF[WSIZE*8-1:0] ( .D(Do0_pre), .Q(Do0), .CLK(CLK) );
    sky130_fd_sc_hd__dfxtp_1 Do1_FF[WSIZE*8-1:0] ( .D(Do1_pre), .Q(Do1), .CLK(CLK) );
    

endmodule

/*
    4 x RAM32 Blocks
*/

module RAM128_ #(parameter   USE_LATCH=0,
                            WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN,     // FO: 1
    input   wire [6:0]          A,      // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
    
);

    wire                    CLK_buf;
    wire [WSIZE-1:0]         WE_buf;
    wire                    EN_buf;
    wire [6:0]              A_buf;
    wire [(WSIZE*8-1):0]     Di_buf;
    wire [3:0]              SEL;

    wire [(WSIZE*8-1):0]    Do_pre[3:0]; 
                            
    // Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (.X(Di_buf),  .A(Di));
    sky130_fd_sc_hd__clkbuf_4   CLKBUF              (.X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_2   WEBUF[WSIZE-1:0]     (.X(WE_buf),  .A(WE));
    sky130_fd_sc_hd__clkbuf_2   ENBUF               (.X(EN_buf),  .A(EN));
    sky130_fd_sc_hd__clkbuf_2   ABUF[6:0]           (.X(A_buf),   .A(A));

    DEC2x4_ DEC (.EN(EN_buf), .A(A_buf[6:5]), .SEL(SEL));

     generate
        genvar i;
        for (i=0; i< 4; i=i+1) begin : BLOCK
            RAM32_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM32 (.CLK(CLK_buf), .EN(SEL[i]), .WE(WE_buf), .Di(Di_buf), .Do(Do_pre[i]), .A(A_buf[4:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX4x1_ #(.WIDTH(WSIZE*8)) DoMUX ( .A0(Do_pre[0]), .A1(Do_pre[1]), .A2(Do_pre[2]), .A3(Do_pre[3]), .S(A_buf[6:5]), .X(Do) );

endmodule

module RAM128_1RW1R_ #( parameter    USE_LATCH=0,
                                    WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN0,    // FO: 1
    input                       EN1,
    input   wire [6:0]          A0,     // FO: 1
    input   wire [6:0]          A1,
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do0,
    output  wire [(WSIZE*8-1):0] Do1
    
);

    wire                    CLK_buf;
    wire [WSIZE-1:0]         WE_buf;
    wire                    EN0_buf;
    wire                    EN1_buf;
    wire [6:0]              A0_buf;
    wire [6:0]              A1_buf;
    wire [(WSIZE*8-1):0]     Di_buf;
    wire [3:0]              SEL0;
    wire [3:0]              SEL1;

    wire [(WSIZE*8-1):0]    Do0_pre[3:0]; 
    wire [(WSIZE*8-1):0]    Do1_pre[3:0]; 
                            
    // Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (.X(Di_buf),  .A(Di));
    sky130_fd_sc_hd__clkbuf_4   CLKBUF              (.X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_2   WEBUF[WSIZE-1:0]     (.X(WE_buf),  .A(WE));
    sky130_fd_sc_hd__clkbuf_2   EN0BUF               (.X(EN0_buf),  .A(EN0));
    sky130_fd_sc_hd__clkbuf_2   A0BUF[6:0]           (.X(A0_buf),   .A(A0));
    sky130_fd_sc_hd__clkbuf_2   ENB1UF               (.X(EN1_buf),  .A(EN1));
    sky130_fd_sc_hd__clkbuf_2   A1BUF[6:0]           (.X(A1_buf),   .A(A1));

    DEC2x4_ DEC0 (.EN(EN0_buf), .A(A0_buf[6:5]), .SEL(SEL0));
    DEC2x4_ DEC1 (.EN(EN1_buf), .A(A1_buf[6:5]), .SEL(SEL1));

     generate
        genvar i;
        for (i=0; i< 4; i=i+1) begin : BLOCK
            RAM32_1RW1R_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM32 (.CLK(CLK_buf), .EN0(SEL0[i]), .EN1(SEL1[i]), .WE(WE_buf), .Di(Di_buf), .Do0(Do0_pre[i]), .Do1(Do1_pre[i]), .A0(A0_buf[4:0]), .A1(A1_buf[4:0]) );        
        end
     endgenerate

    // Output MUXs    
    MUX4x1_ #(.WIDTH(WSIZE*8)) Do0MUX ( .A0(Do0_pre[0]), .A1(Do0_pre[1]), .A2(Do0_pre[2]), .A3(Do0_pre[3]), .S(A0_buf[6:5]), .X(Do0) );
    MUX4x1_ #(.WIDTH(WSIZE*8)) Do1MUX ( .A0(Do1_pre[0]), .A1(Do1_pre[1]), .A2(Do1_pre[2]), .A3(Do1_pre[3]), .S(A1_buf[6:5]), .X(Do1) );
    

endmodule

module RAM256_ #(parameter   USE_LATCH=0,
                            WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 2
    input   wire [WSIZE-1:0]     WE,     // FO: 2
    input                       EN,     // FO: 2
    input   wire [7:0]          A,      // FO: 5
    input   wire [(WSIZE*8-1):0] Di,     // FO: 2
    output  wire [(WSIZE*8-1):0] Do

);

    wire [1:0]             SEL;
    wire [(WSIZE*8-1):0]    Do_pre[1:0]; 

    // 1x2 DEC
    sky130_fd_sc_hd__inv_2 DEC (.Y(SEL[0]), .A(A[7]));
    assign SEL[1] = A[7];

    generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM128_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM128 (.CLK(CLK), .EN(SEL[i]), .WE(WE), .Di(Di), .Do(Do_pre[i]), .A(A[6:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1_ #(.WIDTH(WSIZE*8)) DoMUX ( .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A[7]), .X(Do) );

endmodule

module RAM256_1RW1R_ #(parameter USE_LATCH=0,
                                WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 2
    input   wire [WSIZE-1:0]     WE,     // FO: 2
    input                       EN0,    // FO: 2
    input                       EN1,
    input   wire [7:0]          A0,     // FO: 5
    input   wire [7:0]          A1,
    input   wire [(WSIZE*8-1):0] Di,     // FO: 2
    output  wire [(WSIZE*8-1):0] Do0,
    output  wire [(WSIZE*8-1):0] Do1
    
);

    wire [1:0]              SEL0, SEL1;
    wire [(WSIZE*8-1):0]     Do0_pre[1:0],
                            Do1_pre[1:0]; 
    // 1x2 DEC
    sky130_fd_sc_hd__inv_2 DEC0 (.Y(SEL0[0]), .A(A0[7]));
    sky130_fd_sc_hd__inv_2 DEC1 (.Y(SEL1[0]), .A(A1[7]));
    assign SEL0[1] = A0[7];
    assign SEL1[1] = A1[7];


    generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM128_1RW1R_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM128 (.CLK(CLK), .EN0(SEL0[i]), .EN1(SEL1[i]), .WE(WE), .Di(Di), .Do0(Do0_pre[i]), .Do1(Do1_pre[i]), .A0(A0[6:0]), .A1(A1[6:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1_ #(.WIDTH(WSIZE*8)) Do0MUX ( .A0(Do0_pre[0]), .A1(Do0_pre[1]), .S(A0[7]), .X(Do0) );
    MUX2x1_ #(.WIDTH(WSIZE*8)) Do1MUX ( .A0(Do1_pre[0]), .A1(Do1_pre[1]), .S(A1[7]), .X(Do1) );


endmodule


module RAM512_ #(parameter   USE_LATCH=0,
                            WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 4
    input   wire [WSIZE-1:0]     WE,     // FO: 4
    input                       EN,     // FO: 4
    input   wire [8:0]          A,      // FO: 5
    input   wire [(WSIZE*8-1):0] Di,     // FO: 4
    output  wire [(WSIZE*8-1):0] Do
    
);

    wire [3:0]             SEL;
    wire [(WSIZE*8-1):0]    Do_pre[3:0]; 

    DEC2x4_ DEC (.EN(EN), .A(A[8:7]), .SEL(SEL));

    generate
        genvar i;
        for (i=0; i< 4; i=i+1) begin : BLOCK
            RAM128_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM128 (.CLK(CLK), .EN(SEL[i]), .WE(WE), .Di(Di), .Do(Do_pre[i]), .A(A[6:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX4x1_ #(.WIDTH(WSIZE*8)) DoMUX ( .A0(Do_pre[0]), .A1(Do_pre[1]), .A2(Do_pre[2]), .A3(Do_pre[3]), .S(A[8:7]), .X(Do) );

endmodule


module RAM1024_ #(parameter  USE_LATCH=0,
                            WSIZE=4 ) 
(
    input   wire                CLK,    // FO: 1
    input   wire [WSIZE-1:0]     WE,     // FO: 1
    input                       EN,     // FO: 1
    input   wire [9:0]          A,      // FO: 1
    input   wire [(WSIZE*8-1):0] Di,     // FO: 1
    output  wire [(WSIZE*8-1):0] Do
    
);

    wire                    CLK_buf;
    wire [WSIZE-1:0]         WE_buf;
    wire                    EN_buf;
    wire [9:0]             A_buf;
    wire [(WSIZE*8-1):0]     Di_buf;
    wire [1:0]              SEL;

    wire [(WSIZE*8-1):0]    Do_pre[1:0]; 
                            
    // Buffers
    sky130_fd_sc_hd__clkbuf_16  DIBUF[(WSIZE*8-1):0] (.X(Di_buf),  .A(Di));
    sky130_fd_sc_hd__clkbuf_4   CLKBUF              (.X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_2   WEBUF[WSIZE-1:0]     (.X(WE_buf),  .A(WE));
    sky130_fd_sc_hd__clkbuf_2   ENBUF               (.X(EN_buf),  .A(EN));
    sky130_fd_sc_hd__clkbuf_2   ABUF[9:0]           (.X(A_buf),   .A(A));

    // 1x2 DEC
    DEC1x2_ DEC1x2(
        .EN(EN),
        .A(A[9]),
        .SEL(SEL)
    );
    
    // sky130_fd_sc_hd__inv_2 DEC (.Y(SEL[0]), .A(A[9]));
    // assign SEL[1] = A[9];

     generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM512_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM32 (.CLK(CLK_buf), .EN(SEL[i]), .WE(WE_buf), .Di(Di_buf), .Do(Do_pre[i]), .A(A_buf[8:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1_ #(.WIDTH(WSIZE*8)) DoMUX ( .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A_buf[9]), .X(Do) );

endmodule
