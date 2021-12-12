module IE_Register3 (
    input clk,
    input reg [31:0] rs2_value,
    output reg [31:0] rs2_value_o
);

always @ (posedge clk)
begin
    rs2_value_o = rs2_value;
end
    
endmodule