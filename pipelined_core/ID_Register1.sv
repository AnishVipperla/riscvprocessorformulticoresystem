module ID_Register1 (
    input clk,
    input [10:0] inst_mem_addr_i,           // From PC
    output reg [10:0] inst_mem_addr_o;      // TO IE_Register1
);

always @ (posedge clk)
begin
    inst_mem_addr_o = inst_mem_addr_i;
end
endmodule