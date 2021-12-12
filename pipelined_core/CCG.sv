
`timescale 1ns/1ps

`define fetch    000
`define decode   001
`define execute  010
`define memory   011
`define regwrite 100


module CCG(
input  clk,
input  [31:0] inst_CCD, // From Instruction memory
output E_reg,           // Enable register file
output E_ALU,           // Enable ALU
output E_Imm_decode,    // Enable immediate decode register
output E_DMEM,          // Enable DMEM
output L_DMEM,          // Load DMEM
output E_branch_cmp,    // Enable branch comparator
output E_PC,            // Enable/ Load program counter (EPC = 0 for load, EPC = 1 for enable)
output E_ECM,           // Enable error correction module
output E_IO_CNTRL,      // Enable IO controller
output E_branch,        // Make branch bit HIGH/LOW
output wen              // Make write enable bit HIGH/LOW
);

/* 
State Machine for the Control Code Generator
5 stage pipeline.
State 0 (000) - Instruction Fetch (IF)
State 1 (001) - Instruction Decode (ID)
State 2 (010) - Execute (EXE)
State 3 (011) - Data Memory Access
State 4 (1xx) - Register Write Back
*/

reg [1:0] inst_type;
reg [10:0] control_bits;
reg inst_ALU;
reg [2:0] fun;
reg [2:0] state;

// Instruction types - 
// R (Register), 
// I (Immediate), 
// S (Store), 
// SB, U (Upper Immediate), UJ type 

assign  {E_reg, E_ALU, E_Imm_decode, E_DMEM, L_DMEM, E_branch_cmp, E_PC, E_ECM, E_IO_CNTRL, E_branch, wen} = control_bits; 

always @ (posedge clk)
begin
   if (inst_CCD[4:2] === 3'b000)
   begin
       inst_ALU = 1'b0;
       if (inst_CCD[6:5] === 2'b00)
            inst_type = 2'b00;              // Load instruction
        else if (inst_CCD[6:5] === 2'b01)
            inst_type = 2'b01;              // Store instruction
        else if (inst_CCD[6:5] === 2'b11)
            inst_type = 2'b11;              // Branches
    end
    else if (inst_CCD[4:2] === 3'b100) 
    begin
        inst_ALU = 1'b1;
        if (inst_CCD[6:5] === 2'b00)
            inst_type = 2'b00;              // Arithmetic instruction
        else if (inst_CCD[6:5] === 2'b01)   
            inst_type = 2'b01;              // Arithmetic instruction
    end 
end

// stage IF (Instruction Fetch integrated in Instruction Memory)

always @(posedge clk)
begin

if (inst_ALU === 1'b0) 
    begin
        if (inst_type === 0)                // Load Instruction
            begin
                case (fun)
                    3'b000: control_bits = ; // LB
                    3'b001: control_bits = ; // LH
                    3'b010: control_bits = ; // LW
                    3'b100: control_bits = ; // LBU
                    3'b101: control_bits = ; // LHU
                endcase
            end
        else if (inst_type === 1)           // Store instruction
            begin
                case (fun)
                    3'b000: control_bits = ; // SB
                    3'b001: control_bits = ; // SH
                    3'b010: control_bits = ; // SW 
                endcase
            end
        else if (inst_type === 3)           // Branches
            begin
                case(fun)
                    3'b000: control_bits = ; // BEQ
                    3'b001: control_bits = ; // BNE
                    3'b100: control_bits = ; // BLT
                    3'b101: control_bits = ; // BGE
                    3'b110: control_bits = ; // BLTU
                    3'b111: control_bits = ; // BGEU  
                endcase
            end
        else if (inst_CCD[4:0] === 5'b10111)
            control_bits = (inst_CCD[6:5] === 1) : ? ; // 1 for LUI and 0 for AUIPC

    end

else if (inst_ALU === 1'b1)                 // Arithmetic instruction
    begin
        if (inst_type === 0)
        begin
            case (fun)
                3'b000: control_bits = ; //ADDI
                3'b010: control_bits = ; //SLTI
                3'b011: control_bits = ; //SLTIU
                3'b100: control_bits = ; //XORI
                3'b110: control_bits = ; //ORI
                3'b111: control_bits = ; //ANDI
                3'b001: control_bits = ; //SLLI
                3'b101: control_bits = (inst_CCD[30] == 0) :  ?   ; // SRLI (inst_CCD[30] = 0) and SRAI (inst_CCD[30] = 1) 
            endcase
        end

        else if (inst_type === 1)
            case (fun)
            /*
                3'b000: control_bits = 11'b10000000000 ; //ADD
                3'b010: control_bits = 11'b10000000000; //SLT
                3'b011: control_bits = 11'b10000000000; //SLTU
                3'b100: control_bits = 11'b10000000000; //XOR
                3'b110: control_bits = 11'b10000000000; //OR
                3'b111: control_bits = 11'b10000000000; //AND
                3'b001: control_bits = 11'b10000000000; //SLL
                3'b101: control_bits = (inst_CCD[30] == 0) : 11'b10000000000 ? 11'b10000000000  ; // SRL (inst_CCD[30] = 0) and SRA (inst_CCD[30] = 1) 
            endcase
            */
            control_bits = 11'b10000000000;
            state = execute;
    end

else        // NOP Instruction
    control_bits = 11'b00000000000;

end

