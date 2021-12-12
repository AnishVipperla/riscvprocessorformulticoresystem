// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module IE_mux2 (
    input [11:0] immediate,
    input [31:0] rs2_value,
    input IE_mux2_SEL,
    input IE_mux2_EN,
    output reg [31:0] rs2_ALU_in
);

always_comb @ (IE_mux2_SEL, IE_mux2_EN)
begin
    if (IE_mux2_EN)
        rs2_ALU_in = (IE_mux2_SEL === 0) : rs2_value ? {20'h00000, immediate};
end

endmodule