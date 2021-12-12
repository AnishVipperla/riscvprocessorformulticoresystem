`timescale 1ns/1ps
`include "register_file.sv"

// Testbench for Register File for all possible cases.

module register_file_tb();

reg wen;
reg register_file_enable;
reg clk = 1'b0;
reg [4:0] rs1_add;
reg [4:0] rs2_add;
reg [4:0] rd_add;
reg [31:0] data;
reg [31:0] rs1_val;
reg [31:0] rs2_val;

register_file RF(clk, rs1_add, rs2_add, rd_add, data, wen, register_file_enable, rs1_val, rs2_val); // RF module instantiation

always
begin
    #5 
  	clk = ~clk;
end

initial 
begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
    register_file_enable = 1;
    wen = 1;
    #10
    rd_add = 5'b00001;
    data = 32'h00000005;
    #10
    rd_add = 5'b00010;
    data = 32'h0000000a;
    #10
    wen = 0;
    #10
    rs1_add = 5'b00001;
    rs2_add = 5'b00010; 
  	#20
  	wen = 1;
  	rd_add = 5'b10001;
    data = 32'h0000000b;
  	#10
  	wen = 0;
  	#10
  	rs1_add = 5'b10001;
  	rs2_add = 5'b10010;
	#10
  	wen = 1;
  	rd_add = 5'b00000;
  	data = 32'h00000002;
  	#10
  	wen = 0;
  	rs1_add = 5'b00010;
  	rs2_add = 5'b00000;
  	#40
  
    $display("Register 1 value = %0h", rs1_val);
    $display("Register 2 value = %0h", rs2_val);
    $finish;
end
    
endmodule