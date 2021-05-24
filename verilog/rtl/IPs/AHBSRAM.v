/*
 	 _   _  __ ___     __   _________  
	| \ | |/ _(_) \   / /__|___ /___ \ 
	|  \| | |_| |\ \ / / _ \ |_ \ __) |
	| |\  |  _| | \ V /  __/___) / __/ 
	|_| \_|_| |_|  \_/ \___|____/_____|
	Copyright 2020 Mohamed Shalan
	
	Licensed under the Apache License, Version 2.0 (the "License"); 
	you may not use this file except in compliance with the License. 
	You may obtain a copy of the License at:

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.
*/
/*
  Updated vesrion of the code provided by the Communication IC design Book
  The book is out of print and I cannot find any reference to it online
  The downloaded code does not contain any copyright or license text
  The cached version (by Google) can be found at: 
  http://en.pudn.com/Download/item/id/3120046.html
*/

`timescale          1ns/1ps
`default_nettype    none

module AHBSRAM #(
    parameter AW = 14               // Address width
)
(
    // AHB BUS       
    input  wire             HCLK,      
    input  wire             HRESETn,   
    input  wire             HSEL,      
    input  wire             HREADY,    
    input  wire [1:0]       HTRANS,    
    input  wire [2:0]       HSIZE,     
    input  wire             HWRITE,    
    input  wire [31:0]      HADDR,     
    input  wire [31:0]      HWDATA,   
    output wire [31:0]      HRDATA,       
    output wire             HREADYOUT,

    // SRAM Interface
    input  wire [31:0]      SRAMRDATA,    
    output wire [3:0]       SRAMWEN,      
    output wire [31:0]      SRAMWDATA,    
    output wire             SRAMCS,       
    output wire [AW-3:0]    SRAMADDR      
);   

   reg  [(AW-3):0]          buf_addr;        // Write address buffer
   reg  [3:0]               buf_we;          // Write enable buffer (data phase)
   reg                      buf_hit;         // High when AHB read address
                                             // matches buffered address
   reg  [31:0]              buf_data;        // AHB write bus buffered
   reg                      buf_pend;        // Buffer write data valid
   reg                      buf_data_en;     // Data buffer write enable (data phase)

   wire                     ahb_access   = HTRANS[1] & HSEL & HREADY;
   wire                     ahb_write    = ahb_access &  HWRITE;
   wire                     ahb_read     = ahb_access & (~HWRITE);


   // Stored write data in pending state if new transfer is read
   //   buf_data_en indicate new write (data phase)
   //   ahb_read    indicate new read  (address phase)
   //   buf_pend    is registered version of buf_pend_nxt
   wire         buf_pend_nxt = (buf_pend | buf_data_en) & ahb_read;

   // RAM write happens when
   // - write pending (buf_pend), or
   // - new AHB write seen (buf_data_en) at data phase,
   // - and not reading (address phase)
   wire         ram_write   = (buf_pend | buf_data_en)  & (~ahb_read); // ahb_write

   // RAM WE is the buffered WE
   assign       SRAMWEN     = {4{ram_write}} & buf_we[3:0];

   // RAM address is the buffered address for RAM write otherwise HADDR
   assign       SRAMADDR    = ahb_read ? HADDR[AW-1:2] : buf_addr;

   // RAM chip select during read or write
   wire         SRAMCS_src; 
   assign       SRAMCS_src  = ahb_read | ram_write;
   assign       SRAMCS      = SRAMCS_src; 
   
   // ----------------------------------------------------------
   // Byte lane decoder and next state logic
   // ----------------------------------------------------------

   wire       tx_byte    = (~HSIZE[1]) & (~HSIZE[0]);
   wire       tx_half    = (~HSIZE[1]) &  HSIZE[0];
   wire       tx_word    =   HSIZE[1];

   wire       byte_at_00 = tx_byte & (~HADDR[1]) & (~HADDR[0]);
   wire       byte_at_01 = tx_byte & (~HADDR[1]) &   HADDR[0];
   wire       byte_at_10 = tx_byte &   HADDR[1]  & (~HADDR[0]);
   wire       byte_at_11 = tx_byte &   HADDR[1]  &   HADDR[0];

   wire       half_at_00 = tx_half & (~HADDR[1]);
   wire       half_at_10 = tx_half &   HADDR[1];

   wire       word_at_00 = tx_word;

   wire       byte_sel_0 = word_at_00 | half_at_00 | byte_at_00;
   wire       byte_sel_1 = word_at_00 | half_at_00 | byte_at_01;
   wire       byte_sel_2 = word_at_00 | half_at_10 | byte_at_10;
   wire       byte_sel_3 = word_at_00 | half_at_10 | byte_at_11;

   // Address phase byte lane strobe
   wire [3:0] buf_we_nxt = { byte_sel_3 & ahb_write,
                             byte_sel_2 & ahb_write,
                             byte_sel_1 & ahb_write,
                             byte_sel_0 & ahb_write };

     // buf_data_en is data phase write control
   always @(posedge HCLK or negedge HRESETn)
     if (~HRESETn)
       buf_data_en <= 1'b0;
     else
       buf_data_en <= ahb_write;

   always @(posedge HCLK)
     if(buf_we[3] & buf_data_en)
       buf_data[31:24] <= HWDATA[31:24];

   always @(posedge HCLK)
     if(buf_we[2] & buf_data_en)
       buf_data[23:16] <= HWDATA[23:16];

   always @(posedge HCLK)
     if(buf_we[1] & buf_data_en)
       buf_data[15: 8] <= HWDATA[15: 8];

   always @(posedge HCLK)
     if(buf_we[0] & buf_data_en)
       buf_data[ 7: 0] <= HWDATA[ 7: 0];

   // buf_we keep the valid status of each byte (data phase)
   always @(posedge HCLK or negedge HRESETn)
     if (~HRESETn)
       buf_we <= 4'b0000;
     else if(ahb_write)
       buf_we <= buf_we_nxt;

   always @(posedge HCLK or negedge HRESETn)
     begin
     if (~HRESETn)
       buf_addr <= {(AW-2){1'b0}};
     else if (ahb_write)
         buf_addr <= HADDR[(AW-1):2];
     end
   
   wire  buf_hit_nxt = (HADDR[AW-1:2] == buf_addr[AW-3 - 0:0]);

   // ----------------------------------------------------------
   // Read data merge : This is for the case when there is a AHB
   // write followed by AHB read to the same address. In this case
   // the data is merged from the buffer as the RAM write to that
   // address hasn't happened yet
   // ----------------------------------------------------------

   wire [ 3:0] merge1  = {4{buf_hit}} & buf_we; // data phase, buf_we indicates data is valid

   assign HRDATA = {    merge1[3] ? buf_data[31:24] : SRAMRDATA[31:24],
                        merge1[2] ? buf_data[23:16] : SRAMRDATA[23:16],
                        merge1[1] ? buf_data[15: 8] : SRAMRDATA[15: 8],
                        merge1[0] ? buf_data[ 7: 0] : SRAMRDATA[ 7: 0] 
                    };

   // ----------------------------------------------------------
   // Synchronous state update
   // ----------------------------------------------------------

   always @(posedge HCLK or negedge HRESETn)
     if (~HRESETn)
       buf_hit <= 1'b0;
     else if(ahb_read)
       buf_hit <= buf_hit_nxt;

   always @(posedge HCLK or negedge HRESETn)
     if (~HRESETn)
       buf_pend <= 1'b0;
     else
       buf_pend <= buf_pend_nxt;

   // if there is an AHB write and valid data in the buffer, RAM write data
   // comes from the buffer. otherwise comes from the HWDATA
   assign SRAMWDATA = (buf_pend) ? buf_data : HWDATA[31:0];

   assign HREADYOUT = 1'b1;
   
endmodule
