// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

// Copy of the table in lecture 11s
// Wires involved in datapath
wire [31:0] pc_load;
wire [31:0] pc_sel_1;
wire [31:0] pc_sel_2;
wire [31:0] pc_sel_3;
wire [31:0] mem_r;
wire [31:0] mem_w;
wire [31:0] r1_sel_1;
wire [31:0] reg_r;
wire [31:0] reg_w;
wire [31:0] wa_sel_1;
wire [31:0] wa_sel_2;
wire [31:0] wa_sel_3;
wire [31:0] wd_sel_1;
wire [31:0] wd_sel_2;
wire [31:0] wd_sel_3;
wire [31:0] sp_load;
wire [31:0] op1_sel_1;
wire [31:0] op2_sel_1;
wire [31:0] op2_sel_2;
wire [31:0] op2_sel_3;
wire [31:0] op2_sel_4;
wire [31:0] alu_oprn;
wire [31:0] ma_sel_1;
wire [31:0] dmem_r;
wire [31:0] dmem_w;
wire [31:0] md_sel_1;
// Additional intermediate wires
wire [31:0] OUT;
wire [31:0] program_ctr;
wire [31:0] stack_ptr;
wire [31:0] pc_immediate;
wire [31:0] pc_plus_1;
wire [31:0] R1_data,R2_data;

// ***** Define the additional components first and connect *****
// ALU
ALU alu_inst(.OUT(OUT), .ZERO(ZERO), .OP1(op1_sel_1), .OP2(op2_sel_4), .OPRN( CTRL[27:22]  ) );

// Register File
REGISTER_FILE_32x32 REGISTERS(.DATA_R1(R1_data), .DATA_R2(R2_data), 
	.ADDR_R1(r1_sel_1[4:0] ), .ADDR_R2(INSTRUCTION[20:16]) , 
	.DATA_W(wd_sel_3), .ADDR_W(wa_sel_3[4:0]), .READ(CTRL[8]), 
	.WRITE(CTRL[9]), .CLK(CLK), .RST(RST) );

// Program Counter
REG32 pc_reg(.Q(program_ctr ), .D( pc_sel_3  ), .LOAD( CTRL[0] ), .CLK(CLK), .RESET(RST));

// Stack Pointer
REG32 sp_reg(.Q(stack_ptr), .D(OUT), .LOAD( CTRL[16] ), .CLK(CLK), .RESET(RST));

// Instruction Register
REG32 instruction_reg(.Q(INSTRUCTION), .D(DATA_IN), .LOAD(CTRL[4]), .CLK(CLK), .RESET(RST));

// Adder 1
RC_ADD_SUB_32 adder_1(.Y(pc_plus_1) , .CO(blank_w1) , .A(program_ctr), .B(32'b1), .SnA(1'b0));

// Adder 2
RC_ADD_SUB_32 adder_2(.Y(pc_immediate) , .CO(blank_w2) , .A(pc_plus_1), .B( {{16{INSTRUCTION[15]}} ,INSTRUCTION[15:0]}), .SnA(1'b0));


// *** Connections for each mux in datapath ***

// pc_load - Done in CU

// pc_sel_1
MUX32_2x1 mux_pc_sel_1_inst(.Y(pc_sel_1) , .I0(R1_data), .I1(pc_plus_1), .S(CTRL[1]));
// pc_sel_2
MUX32_2x1 mux_pc_sel_2_inst(.Y(pc_sel_2) , .I0(pc_sel_1), .I1(pc_immediate), .S(CTRL[2]));
// pc_sel_3
MUX32_2x1 mux_pc_sel_3_inst(.Y(pc_sel_3) , .I0({{6'b0} ,INSTRUCTION[25:0]}), .I1(pc_sel_2), .S(CTRL[3]));
// mem_r - Done in CU

// mem_w - Done in CU

// r1_sel_1
MUX32_2x1 mux_r1_sel_1_inst(.Y(r1_sel_1) , .I0({{27{1'b0}}, INSTRUCTION[25:21]}), .I1(32'b00000), .S(CTRL[7]));
// reg_r - Done in CU

// reg_w - Done in CU

// wa_sel_1
MUX32_2x1 mux_wa_sel_1_inst(.Y(wa_sel_1), .I0({{27{1'b0}}, INSTRUCTION[15:11]}), .I1({{27{1'b0}}, INSTRUCTION[20:16]}), .S(CTRL[10]));
// wa_sel_2
MUX32_2x1 mux_wa_sel_2_inst(.Y(wa_sel_2), .I0(32'h00000000), .I1(32'b11111), .S(CTRL[11]));
// wa_sel_3
MUX32_2x1 mux_wa_sel_3_inst(.Y(wa_sel_3), .I0(wa_sel_2), .I1(wa_sel_1), .S(CTRL[12]));
// wd_sel_1
MUX32_2x1 mux_wd_sel_1_inst(.Y(wd_sel_1), .I0(OUT), .I1(DATA_IN), .S(CTRL[13]));
// wd_sel_2
MUX32_2x1 mux_wd_sel_2_inst(.Y(wd_sel_2), .I0(wd_sel_1), .I1({INSTRUCTION[15:0],{16'b0}}), .S(CTRL[14]));
// wd_sel_3
MUX32_2x1 wd_sel_3_inst(.Y(wd_sel_3), .I0(pc_plus_1), .I1(wd_sel_2), .S(CTRL[15]));
// sp_load - Done in CU

// op1_sel_1
MUX32_2x1 mux_op1_sel_1_inst(.Y(op1_sel_1) , .I0(R1_data), .I1(stack_ptr), .S(CTRL[17]));
// op2_sel_1
MUX32_2x1 mux_op2_sel_1_inst(.Y(op2_sel_1) , .I0(32'b1), .I1({{27'b0} ,INSTRUCTION[10:6]}), .S(CTRL[18]));
// op2_sel_2
MUX32_2x1 mux_op2_sel_2_inst(.Y(op2_sel_2) , .I0({{16'b0} ,INSTRUCTION[15:0]}), .I1({{16{INSTRUCTION[15]}} ,INSTRUCTION[15:0]}), .S(  CTRL[19]));
// op2_sel_3
MUX32_2x1 mux_op2_sel_3_inst(.Y(op2_sel_3) , .I0(op2_sel_2), .I1(op2_sel_1), .S(CTRL[20]));
// op2_sel_4
MUX32_2x1 mux_op2_sel_4_inst(.Y(op2_sel_4) , .I0(op2_sel_3), .I1(R2_data), .S(CTRL[21]));
// alu_oprn - Done in CU

// ma_sel_1
MUX32_2x1 mux_ma_sel_1_inst(.Y(ma_sel_1) , .I0(OUT), .I1(stack_ptr), .S(CTRL[28]));
// ma_sel_2
MUX32_2x1 mux_ma_sel_2_inst(.Y(ADDR) , .I0(ma_sel_1), .I1(program_ctr), .S(CTRL[29]));
// dmem_r - Done in CU

// dmem_w - Done in CU

// md_sel_1
MUX32_2x1 mux_md_sel_1_inst(.Y(DATA_OUT) , .I0(R2_data), .I1(R1_data), .S(CTRL[30]));

endmodule
