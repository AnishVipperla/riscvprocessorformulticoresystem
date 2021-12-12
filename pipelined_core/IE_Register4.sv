module IE_Register4 (
    input clk,
    input reg [31:0] inst_CCD,
    input reg [31:0] imm_decode,
    output reg [31:0] inst_CCD_o,
    output reg [31:0] imm_decode_o
);

always @ (posedge clk)
begin
    inst_CCD_o <= inst_CCD;
    imm_decode_o <= imm_decode;
end

endmodule