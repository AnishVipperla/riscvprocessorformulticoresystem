module ID_Register2 (
    input clk,
    input [4:0] rs1_address_i,
    input [4:0] rs2_address_i,
    input [31:0] inst_CCD_i,
    input [31:0] imm_decode_i,
    output reg [4:0] rs1_address_o,
    output reg [4:0] rs2_address_o,
    output reg [31:0] inst_CCD_o,
    output reg [31:0] imm_decode_o
);

always @ (posedge clk)
begin
    rs1_address_o <= rs1_address_i;
    rs2_address_o <= rs2_address_i;
    inst_CCD_o    <= inst_CCD_i;
    imm_decode_o  <= imm_decode_i;
end
    
endmodule