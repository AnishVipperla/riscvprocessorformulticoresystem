// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module CCG(
input  clk,
input  [31:0] inst_CCD,       // From Instruction memory
input  system_reset,          // FULL RESET (synchronous)
input  branch_cmp_output,     // If branch_cmp_output is true, take a branch for next cycle

// Total number of control bits - 27

// ENABLE and LOAD BITS

output logic E_reg,           // Enable register file                              (DONE)
output logic E_ALU,           // Enable ALU                                        (DONE)
output logic E_Imm_decode,    // Enable immediate decode register                  (DONE)
output logic E_IMEM,          // Enable IMEM                                       (DONE)
output logic L_IMEM,          // Load IMEM                                         (DONE)
output logic E_DMEM,          // Enable DMEM                                       (DONE)
output logic L_DMEM,          // Load DMEM                                         (DONE)
output logic dmem_WE,         // DMEM write enable                                 (DONE)
output logic E_branch_cmp,    // Enable branch comparator                          (DONE)
output logic E_PC,            // Enable program counter                            (DONE)
output logic E_IO_CNTRL,      // Enable IO controller                              (DONE)
output logic wen,             // Make write enable bit HIGH/LOW  for RF            (DONE)
output logic E_ID_mux1;       // Enable Instruction Decode MUX 1                   (DONE)
output logic E_IE_mux1;       // Enable Instruction Execute MUX 1                  (DONE)
output logic E_IE_mux2;       // Enable Instruction Execute MUX 2                  (DONE)
output logic E_IWB_mux1;      // Enable Instruction Write-Back MUX 1               (DONE)

// MUX SELECT BITS
output logic select_programcounter,    // Select PC (mux)                          (DONE)
output logic select_ID_mux1,           // Select ID (mux1)                         (DONE)
output logic select_IE_mux1,           // Select IE (mux1)                         (DONE)
output logic select_IE_mux2,           // Select IE (mux2)                         (DONE)
output logic [1:0] select_IWB_mux1,    // Select IWB (mux1)                        (DONE)

// FLAG BITS
output logic EQ_FLAG,                  // Equal (signed) Flag                      (DONE)
output logic NEQ_FLAG,                 // Not Equal (signed) Flag                  (DONE)
output logic LT_FLAG,                  // Less Than (signed) Flag                  (DONE)
output logic GE_FLAG,                  // Greater than / Equal (signed) Flag       (DONE)
output logic LTU_FLAG,                 // Less than (Unsigned) Flag                (DONE)
output logic GEU_FLAG                  // Greater than / Equal (Unsigned) Flag     (DONE)

);

reg [26:0] control_bits;

// Instruction types - 
// R (Register), 
// I (Immediate), 
// S (Store), 
// SB, U (Upper Immediate), UJ type 

assign  {E_reg, E_ALU, E_Imm_decode, E_IMEM, L_IMEM, E_DMEM, L_DMEM, 
        dmem_WE, E_branch_cmp, E_PC, E_IO_CNTRL, wen, E_ID_mux1, 
        E_IE_mux1, E_IE_mux2, E_IWB_mux1, select_programcounter, select_ID_mux1,
        select_IE_mux1, select_IE_mux2, select_IWB_mux1, EQ_FLAG, NEQ_FLAG,
        LT_FLAG, GE_FLAG, LTU_FLAG, GEU_FLAG} = control_bits; 

always @ (posedge clk)
begin
    control_bits = 27'b000000000000000000000000000;
    if (system_reset === 1'b1)
        control_bits = 27'b000000000000000000000000000;
    else
    begin
        case (opcode)
        7'b0000011: begin   // LOAD Instructions
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_DMEM                <= 1;
                        L_DMEM                <= 0;
                        dmem_WE               <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 0;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 0;
                    end
        
        7'b0100011: begin  // STORE Instructions
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_DMEM                <= 1;
                        L_DMEM                <= 0;
                        dmem_WE               <= 1;
                        E_PC                  <= 1;
                        wen                   <= 0;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        select_programcounter <= 0;
                        select_IE_mux1        <= 0;
                        select_IE_mux2        <= 1;
                    end
        
        7'b0110011: begin  // ALU Instructions
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 0;
                        select_IE_mux2        <= 0;
                        select_IWB_mux1       <= 1;  
                    end
        
        7'b0010011: begin   // ALU IMM Instructions
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 0;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 1;
                    end
        
        7'b0110111: begin   // LUI Instruction
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 0;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 0;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 1;
                    end
        
        7'b1100011: begin   // BRANCH Instructions
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_branch_cmp          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 0;
                        E_ID_mux1             <= 0;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 0;
                        select_programcounter <= 1;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 1;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 0;
                    end

        7'b1101111: begin   // JUMP (JAL) Instruction
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 1;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 2;
                    end 
        
        7'b1100111: begin   // JUMP (JALR) Instruction  (IS NOT SUPPORTED CURRENTLY, WILL PERFORM SYSTEM RESET IN THIS CASE)
                        control_bits = 27'b000000000000000000000000000;
                    end
        
        7'b0010111: begin   // AUIPC Instruction
                        E_reg                 <= 1;
                        E_ALU                 <= 1;
                        E_Imm_decode          <= 1;
                        E_IMEM                <= 1;
                        L_IMEM                <= 0;
                        E_PC                  <= 1;
                        wen                   <= 1;
                        E_ID_mux1             <= 1;
                        E_IE_mux1             <= 1;
                        E_IE_mux2             <= 1;
                        E_IWB_mux1            <= 1;
                        select_programcounter <= 0;
                        select_ID_mux1        <= 0;
                        select_IE_mux1        <= 1;
                        select_IE_mux2        <= 1;
                        select_IWB_mux1       <= 1;
                    end

        default: control_bits = 27'b000000000000000000000000000;
        endcase
    end 
end