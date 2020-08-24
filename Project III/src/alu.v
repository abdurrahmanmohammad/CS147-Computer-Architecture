// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

// Task 1: Create wires
wire [31:0] HI, LO; // For multiplication
wire [`DATA_INDEX_LIMIT:0] shift_result; // For shift
wire [`DATA_INDEX_LIMIT:0] add_sub_result; // For addition and subtraction
wire [31:0] and_result; // For AND operation
wire [31:0] or_result; // For OR operation
wire [31:0] nor_result; // For NOR operation
wire add_sub_co; // Carry out from addition and subtraction
wire SnA_or_w; // SnA or
wire SnA_not_w; // SnA not
wire SnA_and_w; // SnA and

// Task 2: Implement operations
MULT32 mult32_inst(HI, LO, OP1, OP2); // Multiplcation
SHIFT32 shift32_inst(shift_result, OP1, OP2, OPRN[0]); // Shifting

// Addition / Subtraction
not inv_inst(SnA_not_w, OPRN[0]);
and and_inst(SnA_and_w, OPRN[0], OPRN[3]);
or or_inst(SnA_or_w, SnA_not_w, SnA_and_w);
RC_ADD_SUB_32 rc_add_sub_inst(add_sub_result, add_sub_co, OP1, OP2, SnA_or_w);

// 32-bit logical operations: AND, OR, NOR 
AND32_2x1 and32_inst(.Y(and_result), .A(OP1), .B(OP2));
OR32_2x1 or32_inst(.Y(or_result), .A(OP1), .B(OP2));
NOR32_2x1 nor32_inst(.Y(nor_result), .A(OP1), .B(OP2));

// Task 3: Choose the result. Indices of mux determined by diagram. Set the output of mux to the output of the ALU.
MUX32_16x1 mux16x1_inst(.Y(OUT), .I0(32'h00000000), .I1(add_sub_result), .I2(add_sub_result), 
	.I3(LO), .I4(shift_result), .I5(shift_result), .I6(and_result), .I7(or_result), .I8(nor_result), 
	.I9({31'b0, add_sub_result[31]}), .I10(32'h00000000), .I11(32'h00000000), .I12(32'h00000000), 
	.I13(32'h00000000), .I14(32'h00000000), .I15(32'h00000000), .S({OPRN[3:0]}));

// Task 4: Calculate the ZERO flag by NOR-ing the output bits
nor nor_Z_flag(ZERO, OUT[0], OUT[1], OUT[2], OUT[3], OUT[4], OUT[5], OUT[6], OUT[7], OUT[8], OUT[09], OUT[10], OUT[11], OUT[12], 
	OUT[13], OUT[14], OUT[15], OUT[16], OUT[17], OUT[18], OUT[19], OUT[20], OUT[21], OUT[22], OUT[23], OUT[24], 
	OUT[25], OUT[26], OUT[27], OUT[28], OUT[29], OUT[30], OUT[31]);

endmodule
