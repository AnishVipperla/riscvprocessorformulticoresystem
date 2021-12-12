// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module ID_mux1 (
    input [31:0] IO_input,         // Input from I/P
    input [31:0] ALU_output,       // Output from ALU
    input ID_mux1_SEL,             // Select input
    input ID_mux1_EN,
    output reg [31:0] data_to_rf   // Data to be written to RF
);

always_comb @ (ID_mux1_SEL, ID_mux1_EN)
begin
    if (ID_mux1_EN)
        data_to_rf = (ID_mux1_SEL === 1'b1) IO_input: ALU_output;
end
endmodule