module topmodule (
    input reg clk,

);

// define control bits
wire branch;
wire PC_EN;
wire IMEM_EN;
wire IMEM_LD;
wire WEN;
wire RF_EN;
wire ID_mux1_SEL;
wire IE_mux1_SEL;
wire IE_mux2_SEL;
wire BRANCHCMP_EN;


// FLAGS
wire EQ_FLAG;
wire NEQ_FLAG;
wire LT_FLAG;
wire GE_FLAG;
wire LTU_FLAG;
wire GEU_FLAG;

// define other input and output signals
wire [31:0] ALU_out;
wire [10:0] IMEM_addr;
wire [4:0] rs1_ADDR;
wire [4:0] rs2_ADDR;
wire [31:0] imm_decode;
wire [31:0] inst_CCD;
wire [10:0] IMEM_addr_ID_out;
wire [10:0] IMEM_addr_IE_out;
wire [4:0] rs1_ADDR_out;
wire [4:0] rs2_ADDR_out;
wire [31:0] imm_decode_ID_out;
wire [31:0] inst_CCD_ID_out;
wire [31:0] imm_decode_IE_out;
wire [31:0] inst_CCD_IE_out;
wire [31:0] rs1_VAL;
wire [31:0] rs2_VAL;
wire [31:0] rs1_VAL_out;
wire [31:0] rs2_VAL_out;
wire [31:0] DATA;
wire [31:0] rs1_ALU_in;
wire [31:0] rs2_ALU_in;
wire [11:0] IMM_VAL;


// CPU module instantiations

// IF stage
// IF MUX and +4 PC adder integrated into Program Counter PC

program_counter PC (
    .clk (clk),                                 // Input clock signal
    .ALU_out (ALU_out),                         // Input
    .PC_enable (PC_EN),                         // Input
    .branch (branch),                           // Input
    .inst_mem_addr (IMEM_addr)                  // Output
    );

imem IMEM(
    .clk (clk),                                 // Input clock signal
    .inst_mem_addr (IMEM_addr),                 // Input
    .imem_enable (IMEM_EN),                     // Input 
    .load_imem (IMEM_LD),                       // Input
    .rs1_address (rs1_ADDR),                    // Output
    .rs2_address (rs2_ADDR),                    // Output
    .imm_decode (imm_decode),                   // Output
    .inst_CCD (inst_CCD)                        // Output
    );


ID_register1 ID_REG1(
    .clk (clk),                                 // Input clock signal
    .inst_mem_addr_i(IMEM_addr),                // Input
    .inst_mem_addr_o(IMEM_addr_ID_out)          // Output
);

ID_register2 ID_REG2(
    .clk (clk),                                 // Input clock signal
    .rs1_address_i (rs1_ADDR),                  // Input
    .rs2_address_i (rs2_ADDR),                  // Input
    .inst_CCD_i (inst_CCD),                     // Input
    .imm_decode_i (imm_decode),                 // Input
    .rs1_address_o (rs1_ADDR_out),              // Output
    .rs2_address_o (rs2_ADDR_out),              // Output
    .inst_CCD_o (inst_CCD_ID_out),              // Output
    .imm_decode_o (imm_decode_ID_out)           // Output
);

// ID stage

register_file RF(
    .clk (clk),                                 // Input clock signal
    .rs1_address (rs1_ADDR_out),                // Input 
    .rs2_address (rs2_ADDR_out),                // Input
    .rd_address (rd_ADDR_out),                  // Input (yet to be defined)
    .data (DATA),                               // Input
    .wen (WEN),                                 // Input
    .register_file_enable (RF_EN),              // Input
    .rs1_value (rs1_VAL),                       // Output
    .rs2_value (rs2_VAL)                        // Output

);


IE_Register1 IE_REG1(
    .clk (clk),                                 // Input clock signal
    .inst_mem_addr (IMEM_addr_ID_out),          // Input
    .inst_mem_addr_o (IMEM_addr_IE_out)         // Output
);

IE_Register2 IE_REG2(
    .clk (clk),                                 // Input clock signal
    .rs1_value(rs1_VAL),                        // Input
    .rs1_value_o(rs1_VAL_out)                   // Output
);

IE_Register3 IE_REG3(   
    .clk (clk),                                 // Input clock signal
    .rs2_value(rs2_VAL),                        // Input
    .rs2_value_o(rs2_VAL_out)                   // Output
);


IE_Register4 IE_REG4(
    .clk (clk),                                 // Input clock signal
    .inst_CCD (inst_CCD_ID_out),                // Input
    .imm_decode (imm_decode_ID_out),            // Input
    .inst_CCD_o (inst_CCD_IE_out),              // Output
    .imm_decode_o (imm_decode_IE_out)           // Output
);

ID_mux1 ID_MUX1 (
    .IO_input (IO_IN),                          // Input from I/P (yet to be defined)   //32 bit
    .ALU_output (ALU_WB_out),                   // Input (yet to be defined)    // 32 bit
    .ID_mux1_SEL (ID_mux1_SEL),                   // Input (mux select)
    .data_to_rf (DATA)                          // Output Data to be written to RF
);

// IE stage

branch_cmp BRANCHCMP(
    .clk (clk),                                 // Input clock
    .enable_branch_cmp (BRANCHCMP_EN),          // Input
    .rs1_value (rs1_VAL_out),                   // Input
    .rs2_value (rs2_VAL_out),                   // Input
    .EQ_flag (EQ_FLAG),                         // Output
    .NEQ_flag (NEQ_FLAG),                       // Output
    .LT_flag (LT_FLAG),                         // Output
    .GE_flag (GE_FLAG),                         // Output
    .LTU_flag (LTU_FLAG),                       // Output
    .GEU_flag (GEU_FLAG)                        // Output

);

imm_decode IMM_DEC(

);

IE_mux1 IE_MUX1(
    .ALU_out_IM_REG2 (),                        // Input Yet to be defined 32 bit
    .inst_mem_addr_IE_REG1 (IMEM_addr_IE_out),  // Input
    .rs1_value_IE_REG2 (rs1_VAL_out),           // Input
    .IE_mux1_SEL (IE_mux1_SEL),                 // Input
    .rs1_ALU_in (rs1_ALU_in)                    // Output
);

IE_mux2 IE_MUX2(
    .immediate (IMM_VAL),                       // Input
    .rs2_value_IE_REG3 (rs2_VAL_out),           // Input
    .IE_mux2_SEL(IE_mux2_SEL),                  // Input
    .rs2_ALU_in (rs2_ALU_in)                    // Output
);


alu ALU(

);
