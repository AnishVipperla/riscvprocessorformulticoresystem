// -------------------------------------------------------------------------------------------------------------------------
// 
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

// --------------------------- Register file information --------------------------------------------------------------------
// There are 16 registers (x0- x15) in the register file
// 15 are general-purpose registers (x1-x15)
// x0 is hardcoded to zero.
// Any value to written to register x0 is erased.
/*
For R type Instructions - rs1 address - bits 15-19 of opcode, rs2 address - bits 20-24 of opcode, rd - bits 7-11 of opcode
For I type Instructions - rs1 address - bits 15-19 of opcode, rs2 address - Not Applicable, rd - bits 7-11 of opcode
For S type Instructions - rs1 address - bits 15-19 of opcode, rs2 address - bits 20-24 of opcode, rd - Not Applicable
For SB type Instructions - rs1 address - bits 15-19 of opcode, rs2 address - bits 20-24 of opcode, rd - Not Applicable
For U type Instructions - rs1 address - Not Applicable, rs2 address - Not Applicable, rd - bits 7-11 of opcode
For UJ type Instructions - rs1 address - Not Applicable, rs2 address - Not Applicable, rd - bits 7-11 of opcode
*/
// Throws exception if the processor attempts to access x16-x31 registers
// ----------------------------------------------------------------------------------------------------------------------------

// STATUS - STABLE

`timescale 1ns/1ps

module register_file ( // Built on RV32E class ISA for deep embedded applications
    input clk, // clock signal
    input reg [4:0] rs1_address, // Source register address 1 (5 bits)
    input reg [4:0] rs2_address, // Source register address 2 (5 bits)
    input reg [4:0] rd_address,  // Destination register address (5 bits)
    input reg [31:0] data,       // 32-bit data to be written to the register in RF
    input reg wen,               // Postive logic write enable 
    input reg register_file_enable,
    output reg [31:0] rs1_value, // 32-bit output data value from source register 1
    output reg [31:0] rs2_value  // 32-bit output output data value from source register 2
);

reg [31:0] register [15:0];

initial 
begin
    register[0]  <= 32'hXXXXXXXX;
    register[1]  <= 32'hXXXXXXXX;
    register[2]  <= 32'hXXXXXXXX;
    register[3]  <= 32'hXXXXXXXX;
    register[4]  <= 32'hXXXXXXXX;
    register[5]  <= 32'hXXXXXXXX;
    register[6]  <= 32'hXXXXXXXX;
    register[7]  <= 32'hXXXXXXXX;
    register[8]  <= 32'hXXXXXXXX;
    register[9]  <= 32'hXXXXXXXX;
    register[10] <= 32'hXXXXXXXX;
    register[11] <= 32'hXXXXXXXX;
    register[12] <= 32'hXXXXXXXX;
    register[13] <= 32'hXXXXXXXX;
    register[14] <= 32'hXXXXXXXX;
    register[15] <= 32'hXXXXXXXX;
end


always @ (posedge clk and register_file_enable === 1'b1)
begin
  if (wen == 1'b1 && !(data === 32'hXXXXXXXX && rd_address != 5'bXXXXX))
    begin
        if(rd_address[4] != 1'b1)
        begin
            register[rd_address] = data;
            register[0] = 0;
        end
    end
    else if (wen == 1'b0)
    begin
      if (!(rs1_address === 5'bXXXXX && rs2_address ===5'bXXXXX))
      begin
        if (rs1_address[4] != 1'b1 && rs2_address[4] !=1'b1)
        begin
                rs1_value = register[rs1_address];
                rs2_value = register[rs2_address];
      
        end
        else
          begin
            rs1_value = 32'hXXXXXXXX;
            rs2_value = 32'hXXXXXXXX;
          end
      end
    end
end
endmodule