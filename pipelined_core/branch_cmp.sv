module branch_cmp (
    input clk,                  // Clock
    input enable_branch_cmp,    // Control bit ENABLE branch comparator
    input [31:0] rs1_value,            // rs1 value
    input [31:0] rs2_value,            // rs2 value
    output reg EQ_flag,         // Equal
    output reg NEQ_flag,        // Not equal
    output reg LT_flag,         // Less than
    output reg GE_flag,         // Greater than or equal to
    output reg LTU_flag,        // Less than (Unsigned)
    output reg GEU_flag         // Greater than or equal to (Unsigned)
);

always @ (posedge clk and enable_branch_cmp === 1'b1)
begin
    if (rs1_value === rs2_value)    
        EQ_flag = 1'b1;
    if (!(rs2_value === rs2_value))
        NEQ_flag = 1'b1;
    if ($signed(rs1_value) < $signed(rs2_value))
        LT_flag = 1'b1;
    if ($signed(rs1_value) >= $signed(rs2_value))
        GE_flag = 1'b1;
    if (rs1_value < rs2_value)
        LTU_flag = 1'b1;
    if (rs1_value >= rs2_value)
        GEU_flag = 1'b1;
end
endmodule