`timescale 1ns/1ps
`include "imem.sv"

module imem_tb ();

reg clk = 1'b0;
reg [10:0] inst_mem_addr; 
reg imem_enable;
reg load_imem;
reg [4:0] rs1_address;
reg [4:0] rs2_address;
reg [4:0] rd_address;
reg [31:0] inst_CCD;
reg [31:0] imm_decode;

always @(*)
begin
    #5
    clk = ~clk;
end

imem IMEM(clk, inst_mem_addr, imem_enable, load_imem, rs1_address, rs2_address, rd_address, imm_decode, inst_CCD);

initial 
begin
$dumpfile("dump.vcd");
$dumpvars(0);
#10
imem_enable = 1'b0;
#10
imem_enable = 1'b1;
#10
load_imem = 1'b1;
#40
load_imem = 1'b0;
#20
inst_mem_addr = 4'h0;
#10
inst_mem_addr = 4'h4;
#60
$finish;

end

endmodule