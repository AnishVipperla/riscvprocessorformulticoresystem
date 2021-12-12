module IE_Register2 (
    input clk,
    input reg [31:0] rs1_value,
    output reg [31:0] rs1_value_o
);

always @ (posedge clk)
begin
    rs1_value_o = rs1_value;
end
    
endmodule