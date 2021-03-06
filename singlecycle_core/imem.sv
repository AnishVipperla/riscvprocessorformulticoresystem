// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

// This is a 2KB instruction memory
// Note that instruction memory is NOT a cache memory.
// IMEM module has a maximum capacity of 512 instructions
// Each address location can accomodate a byte of data
// RISC V RV32E has a 32-bit byte addressable instruction format.
// Therefore total Instruction Memory (IMEM module) size would be 4*512*8 = 16384
// 2KB instruction memory module with 11-bit address
// 32-bit address in which least signifcant 11 bits are active.

// For loading data into the instruction memory (ROM)
// Dump the memory file "inst.mem"
// "inst.mem" is generated using the python interpreter for converting assembly to machine code
/** 
    "inst.mem" format shown below:
    ab cd ef 01 // 1 32-bit instruction comprising 4 8-bit words stored sequentially in IMEM
    00 23 ac bd
    :  :  :  :
**/

// --------------------------------------------------------------------------------------------------------------------------
// STATUS - STABLE

`timescale 1ns/1ps
`include "inst.mem"

module imem ( // Built on RV32E class ISA for deep embedded applications
    input  clk,
    input  [31:0] inst_mem_addr_in, // generated by the program counter
    input  imem_enable,
    input  load_imem,
    output reg [4:0] rs1_address,   // To RF source register 1 address port
    output reg [4:0] rs2_address,   // To RF source register 2 address port
    output reg [4:0] rd_address,    // To RF destination register address port
    output reg [31:0] imm_decode,   // To Immediate value decode stages
    output reg [31:0] inst_CCD      // To control code generator
);

reg [10:0] inst_mem_addr;
reg [10:0] inst_mem_addr_1;
reg [10:0] inst_mem_addr_2;
reg [10:0] inst_mem_addr_3;
reg [10:0] inst_mem_addr_4;

reg [7:0] inst_mem [2047:0];


always @ (posedge clk and imem_enable === 1'b1)
begin
    if (load_imem === 1'b0)
        begin
            inst_mem_addr [10:0] = inst_mem_addr_in [10:0]
            inst_mem_addr_1 = inst_mem_addr;                    // address for inst_1
            inst_mem_addr_2 = inst_mem_addr_1+4'h1;             // address for inst_2
            inst_mem_addr_3 = inst_mem_addr_2+4'h1;             // address for inst_3
            inst_mem_addr_4 = inst_mem_addr_3+4'h1;             // address for inst_4
            inst_CCD     = {
                               inst_mem[inst_mem_addr_1], 
                               inst_mem[inst_mem_addr_2], 
                               inst_mem[inst_mem_addr_3], 
                               inst_mem[inst_mem_addr_4]
                           };    								// 32-bit instruction
              
            imm_decode   = inst_CCD;
            rs1_address  = inst_CCD [19:15];                    // 5-bit address
            rs2_address  = inst_CCD [24:20];                    // 5-bit address
            rd_address   = inst_CCD [11:7];                     // 5-bit address
            
        end
      else if (load_imem === 1'b1)
            $readmemh("inst.mem", inst_mem);                // Load data from file to IMEM
end
endmodule