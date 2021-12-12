`timescale 1ns/1ps
`include "program_counter.sv"

module program_counter_tb ();
reg clk = 1'b0;
reg [31:0] ALU_out;
reg PC_enable;
reg branch;
reg [10:0] inst_mem_addr; 

program_counter PC(clk, ALU_out, PC_enable, branch, inst_mem_addr);

always
begin
    #5 
  clk = ~clk;
end

initial 
begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
    PC_enable = 0;
    #20
    ALU_out = 32'h0000000b;
    PC_enable = 1;
    branch = 0;
    #20
    branch = 1;
    #40 
    $finish;
end
endmodule