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
    input vccd1,
    input vssd1,
`endif
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
    
     generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM512_ #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM32 (.CLK(CLK_buf), .EN(SEL[i]), .WE(WE_buf), .Di(Di_buf), .Do(Do_pre[i]), .A(A_buf[8:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1_ #(.WIDTH(WSIZE*8)) DoMUX ( .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A_buf[9]), .X(Do) );

endmodule