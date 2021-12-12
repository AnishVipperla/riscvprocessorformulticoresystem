// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

// The processor instruction length is 32-bit which are byte addressable.
// The program counter holds the current address value of a byte addressable instruction (8-bit)
// Inputs can either be from ALU output for Branch instructions or PC + 4 computed independently
// Input multiplexer integrated into the program counter

// Note that instruction memory is NOT a cache memory.
// IMEM module has a maximum capacity of 512 instructions
// Each address location can accomodate a byte of data
// RISC V RV32E has a 32-bit byte addressable instruction format.
// Therefore total Instruction Memory (IMEM module) size would be 4*512*8 = 16384
// 2KB instruction memory module with 11-bit address
// It has to point 512 locations.

// STATUS - STABLE

`timescale 1ns/1ps

module program_counter ( // Built on RV32E,M class ISA for deep embedded applications

input clk,
input [31:0] ALU_out,
input PC_enable,
input PC_Sel,
output reg [31:0] inst_mem_addr    
);

reg [31:0] PC_value;

initial 
begin
    PC_value = 32'h00000000;
end

always @ (posedge clk)
begin
    if (PC_enable === 1'b1)
    begin
        inst_mem_addr = (PC_Sel === 1'b1) ? ALU_out [31:0] : PC_value;
        PC_value = PC_value + 32'h00000004;
    end
end

endmodule