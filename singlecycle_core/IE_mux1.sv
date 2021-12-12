// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module IE_mux1 (
    input [10:0] inst_mem_addr,
    input [31:0] rs1_value,
    input IE_mux1_SEL,
    input IE_mux1_EN,
    output reg [31:0] rs1_ALU_in
);

always_comb @ (IE_mux1_SEL, IE_mux1_EN)
begin
    if (IE_mux1_EN)
        rs1_ALU_in = (IE_mux1_SEL === 0) : rs1_value ? {21'h000000, inst_mem_addr};
end

endmodule