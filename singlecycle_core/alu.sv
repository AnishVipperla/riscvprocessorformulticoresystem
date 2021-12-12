// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------


module alu (
    input alu_enable,
    input IE_mux1_value,
    input IE_mux2_value,
    input inst_CCD,
    output alu_output,
);
reg [2:0] fun3;

    always_comb @ (alu_enable) 
    begin
        fun3 = inst_CCD [14:12]
        fun7 = inst_CCD [6:0]
        opcode = inst_CCD [6:0]
        
        case ({fun3, opcode})
            10'b0000110011: // ADD / SUB / MUL / MULH / MULHSU / MULHU
            10'b0000010011: // ADDI
            : // AND / ANDI
            : // OR / ORI
            : // XOR / XORI
            : // SLT
            : // SLTU
            : // SLTI
            : // SLTIU
            : // SLL
            : // SRL
            : // SRA
            : // SLLI
            : // SRLI
            : // SRAI
            default: 
        endcase
    end
    
endmodule