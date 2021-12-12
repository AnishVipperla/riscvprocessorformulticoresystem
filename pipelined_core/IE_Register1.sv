module IE_Register1 (
    input clk,
    input reg [10:0] inst_mem_addr,
    output reg [10:0] inst_mem_addr_o
);

always @ (posedge clk)
begin
    inst_mem_addr_o = inst_mem_addr;
end
    
endmodule