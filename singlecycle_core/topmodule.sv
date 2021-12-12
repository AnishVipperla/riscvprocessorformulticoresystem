// -------------------------------------------------------------------------------------------------------------------------
// (c) Anish Vipperla, Ninoo Susan Cherian
// 2021 Arizona State University
// Date first created: 6th November 2021
// The following software/program would be licensed under GNU General Public License
// -------------------------------------------------------------------------------------------------------------------------

// STATUS - DESIGN (D), FIXED (F), STABLE (S), TESTED (T), BUG (B)

// PE core top module

// STATUS - DESIGN (CONTROL CODE GENERATION MODULE CHECK)


`timescale 1ns/1ps

module topmodule (
    input reg clk,
);

// define control bits
wire PC_SEL;                        // Select PC (mux)                      (DONE)
wire PC_EN;                         // Enable PC                            (DONE)
wire IMEM_EN;                       // Enable IMEM                          (DONE)
wire DMEM_EN;                       // Enable DMEM                          (DONE)
wire IMEM_LD;                       // LOAD IMEM                            (DONE)
wire DMEM_LD;                       // LOAD DMEM                            (DONE)
wire WEN;                           // Enable WRITE/READ                    (DONE)
wire DMEM_WR;                       // Enable DMEM WRITE                    (DONE)
wire RF_EN;                         // ENABLE RF                            (DONE)
wire IMM_EN;                        // ENBALE IMMEDIATE                     (DONE)
wire ALU_EN;                        // ENABLE ALU                           (DONE)
wire BRANCHCMP_EN;                  // Enable Branch Comparator             (DONE)
wire IO_CNTRL_EN;                   // Enable IO Controller                 (DONE)
wire ID_mux1_SEL;                   // Select Instruction Decode MUX 1      (DONE)
wire IE_mux1_SEL;                   // Select Instruction Execute MUX 1     (DONE)
wire IE_mux2_SEL;                   // Select Instruction Execute MUX 2     (DONE)
wire [1:0] IWB_mux1_SEL;            // Select Instruction Write Back MUX 1  (DONE)
wire ID_mux1_EN;                    // Enable Instruction Decode MUX 1      (DONE)
wire IE_mux1_EN;                    // Enable Instruction Execute MUX 1     (DONE)
wire IE_mux2_EN;                    // Enable Instruction Execute MUX 2     (DONE)
wire IWB_mux1_EN;                   // Enable Instruction Write-Back MUX 1  (DONE)




// FLAGS
wire EQ_FLAG;                       // Equal (signed) Flag                  (DONE)
wire NEQ_FLAG;                      // Not Equal (signed) Flag              (DONE)
wire LT_FLAG;                       // Less Than (signed) Flag              (DONE)
wire GE_FLAG;                       // Greater than / Equal (signed) Flag   (DONE)
wire LTU_FLAG;                      // Less than (Unsigned) Flag            (DONE)
wire GEU_FLAG;                      // Greater than / Equal (Unsigned) Flag (DONE)

// define other input and output signals
wire [31:0] ALU_out;
wire [31:0] ALU_WB_out;
wire [31:0] IMEM_addr;
wire [31:0] DMEM_addr;
wire [4:0] rs1_ADDR;
wire [4:0] rs2_ADDR;
wire [4:0] rd_ADDR;
wire [31:0] imm_decode;
wire [31:0] inst_CCD;
wire [31:0] rs1_VAL;
wire [31:0] rs2_VAL;
wire [31:0] DATA;
wire [31:0] DATA_out;
wire [31:0] IMM_VAL;
wire [31:0] rs1_ALU_in;
wire [31:0] rs2_ALU_in;
wire [31:0] IO_IN;


// CPU module instantiations

// IF (Instruction Fetch) stage
// IF MUX and +4 PC adder integrated into Program Counter PC

program_counter PC (                            // STATUS - F, S
    .clk (clk),                                 // Input clock signal
    .ALU_out (ALU_out),                         // Input
    .PC_enable (PC_EN),                         // Input
    .PC_Sel (PC_SEL),                           // Input
    .inst_mem_addr (IMEM_addr)                  // Output
    );

imem IMEM(                                      // STATUS - F, S
    .clk (clk),                                 // Input clock signal
    .inst_mem_addr_in (IMEM_addr),              // Input
    .imem_enable (IMEM_EN),                     // Input 
    .load_imem (IMEM_LD),                       // Input
    .rs1_address (rs1_ADDR),                    // Output
    .rs2_address (rs2_ADDR),                    // Output
    .rd_address (rd_ADDR)                       // Output
    .imm_decode (imm_decode),                   // Output
    .inst_CCD (inst_CCD)                        // Output
    );

// ID (Instruction Decode) stage

ID_mux1 ID_MUX1 (                               // STATUS - F, S
    .IO_input (IO_IN),                          // Input
    .ALU_output (ALU_WB_out),                   // Input
    .ID_mux1_SEL (ID_mux1_SEL),                 // Input
    .ID_mux1_EN (ID_mux1_EN),                   // Input
    .data_to_rf (DATA)                          // Output
);

register_file RF(                               // STATUS - F, S
    .clk (clk),                                 // Input clock signal
    .rs1_address (rs1_ADDR),                    // Input 
    .rs2_address (rs2_ADDR),                    // Input
    .rd_address (rd_ADDR),                      // Input
    .data (DATA),                               // Input
    .wen (WEN),                                 // Input
    .register_file_enable (RF_EN),              // Input
    .rs1_value (rs1_VAL),                       // Output
    .rs2_value (rs2_VAL)                        // Output

);


branch_cmp BRANCHCMP(                           // STATUS - F, S
    .clk (clk),                                 // Input clock
    .enable_branch_cmp (BRANCHCMP_EN),          // Input
    .rs1_value (rs1_VAL),                       // Input
    .rs2_value (rs2_VAL),                       // Input
    .EQ_flag (EQ_FLAG),                         // Output
    .NEQ_flag (NEQ_FLAG),                       // Output
    .LT_flag (LT_FLAG),                         // Output
    .GE_flag (GE_FLAG),                         // Output
    .LTU_flag (LTU_FLAG),                       // Output
    .GEU_flag (GEU_FLAG)                        // Output

);

imm_decode IMM_DEC(                             // STATUS - F, S
    .clk(clk),                                  // Input clock
    .imm_decode_enable (IMM_EN),                // Input
    .instruction (imm_decode),                  // Input
    .immediate_value (IMM_VAL)                  // Output
);

// IE (Instruction Execute) stage

IE_mux1 IE_MUX1(                                // STATUS - F, S
    .inst_mem_addr (IMEM_addr),                 // Input
    .rs1_value (rs1_VAL),                       // Input
    .IE_mux1_SEL (IE_mux1_SEL),                 // Input
    .IE_mux1_EN (IE_mux1_EN),                   // Input
    .rs1_ALU_in (rs1_ALU_in)                    // Output
);

IE_mux2 IE_MUX2(                                // STATUS - F, S
    .immediate (IMM_VAL),                       // Input
    .rs2_value (rs2_VAL),                       // Input
    .IE_mux2_SEL(IE_mux2_SEL),                  // Input
    .IE_mux2_EN (IE_mux2_EN),                   // Input
    .rs2_ALU_in (rs2_ALU_in)                    // Output
);


alu ALU(

);

// Memory access (MA) stage 

dmem DMEM(                                      // STATUS - F, S
    .clk(clk),                                  // Input clock signal
    .dmem_enable(DMEM_EN),                      // Input
    .dmem_WR(DMEM_WR),                          // Input
    .load_dmem(DMEM_LD),                        // Input
    .data (rs2_VAL),                            // Input
    .write_address(DMEM_addr),                  // Input
    .data_read(DATA_out)                        // Output
);

// Register Write Back (WB) stage

IWB_mux1 IWB_MUX1(                              // STATUS - F, S
    .alu_output (ALU_out),                      // Input
    .dmem_output (DATA_out),                    // Input
    .PC_output (IMEM_addr),                     // Input
    .IWB_mux1_SEL(IWB_mux1_SEL),                // Input         
    .IWB_mux1_EN(IWB_mux1_EN),                  // Input
    .mux_out(ALU_WB_out)                        // Output
    
);

CCG controlcodegen(                             // STATUS - DESIGN
    .clk(clk),                                  // Input clock signal

);

endmodule