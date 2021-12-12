// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module imm_decode (
    input clk,                                  
    input imm_decode_enable,                
    input [31:0] instruction,                                        
    output reg [31:0] immediate_value            // Sign extended value, even if it represents unsigned number        
);

always @ (posedge clk and imm_decode_enable)
begin
    if (instruction[6:0] === 7'b0000011 || instruction[6:0] === 7'b0010011 || instruction[6:0] === 7'b1100111) // I-type
        immediate_value = {{20{instruction[31]}},instruction [31:20]};
    
    else if (instruction[6:0] === 7'b0100011)                                           // S-type
        immediate_value = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};

    else if (instruction[6:0] === 7'b0010111 || instruction[6:0] === 7'b0110111)        // U-type
        immediate_value = {instruction[31:12],12'b0};
    
    else if (instruction[6:0] === 7'b1101111)                                           // UJ-type
        immediate_value = {{19{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
    
    else if (instruction[6:0] === 7'b1100011)                                           // SB-type
        immediate_value = {{19{instruction[20]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}

end

endmodule