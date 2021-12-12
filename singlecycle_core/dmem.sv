// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

// This is a 2KB data memory
// 32 bit address with least significant 9 bits active.
// 512 locations for storing 32-bit word in each address
// Total - 2048 Bytes = 2KB.
// For loading data into the data memory (ROM)
// Dump the memory file "data.mem"

/** 
    "data.mem" format shown below:
    abcdef01
    2345acbd
    :  :  : 
**/

// --------------------------------------------------------------------------------------------------------------------------

// STATUS - DESIGN

// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------


`timescale 1ns/1ps
`include "data.mem"

module dmem (
    input clk,
    input dmem_enable,
    input dmem_WR,
    input load_dmem,
    input data,
    input [31:0] write_address,
    output reg [31:0] data_read
);
reg [31:0] data_mem [511:0];

always @ (posedge clk and dmem_enable === 1'b1)
begin
    if (load_dmem === 1'b0)
    begin
        if (dmem_WR === 1'b0)   // Read
            data_read = data_mem [write_address[8:0]];   // Using least significant 9 bits
        else if (dmem_WR === 1'b1) // Write
            data_mem[write_address[8:0]] = data; 
    end

    else if (load_imem === 1'b1)
         $readmemh("data.mem", data_mem);         // Load data from file to DMEM
end    
endmodule