module IE_mux2 (
    input [11:0] immediate,
    input [31:0] rs2_value_IE_REG3,
    input IE_mux2_SEL,
    output reg [31:0] rs2_ALU_in
);

always_comb @ (IE_mux2_SEL)
begin
    rs1_ALU_in = (IE_mux1_SEL === 1'b0) : rs2_value_IE_REG2 ? {20'h00000, immediate};
end

endmodule