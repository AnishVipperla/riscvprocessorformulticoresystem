module ID_mux1 (
    input [31:0] IO_input,         // Input from I/P
    input [31:0] ALU_output,       // Output from ALU
    input ID_mux1_SEL,        // Select input
    output reg [31:0] data_to_rf       // Data to be written to RF
);

always_comb @ (ID_mux1_SEL)
begin
    data_to_rf = (ID_mux1_SEL === 1'b1) IO_input: ALU_output;
end
endmodule