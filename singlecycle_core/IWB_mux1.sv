// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module IWB_mux1 (
    input [31:0] alu_output,
    input [31:0] dmem_output,
    input [31:0] PC_output,
    input [1:0] IWB_mux1_SEL,
    input IWB_mux1_EN,
    output reg [31:0] mux_out
);

always @ (IWB_mux1_EN, IWB_mux1_SEL)
begin
    if (IWB_mux1_SEL)
        mux_out =  (IWB_mux1_SEL === 2'b00) ? dmem_output : (
            (IWB_mux1_SEL === 2'b01) ? alu_output: (
            (IWB_mux1_SEL === 2'b10) ? PC_output + 4 : PC_output + 4
            ));
end
endmodule