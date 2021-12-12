module IE_mux1 (
    input [31:0] ALU_out_IM_REG2,
    input [10:0] inst_mem_addr_IE_REG1,
    input [31:0] rs1_value_IE_REG2,
    input [1:0] IE_mux1_SEL,
    output reg [31:0] rs1_ALU_in
);

always_comb @ (IE_mux1_SEL)
begin
    rs1_ALU_in = (IE_mux1_SEL === 1'b00) : rs1_value_IE_REG2 ? (
        (IE_mux1_SEL === 1'b01): {21'h000000, inst_mem_addr_IE_REG1} ? (
        (IE_mux1_SEL === 1'b10): ALU_out_IM_REG2 ? rs1_value_IE_REG2    
        ));
end

endmodule