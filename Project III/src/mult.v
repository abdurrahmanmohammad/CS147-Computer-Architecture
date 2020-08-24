// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; // Multiplicand
input [31:0] B; // Multiplier
// Task 1: Create wires to store/transfer intemediate results
wire [31:0] signed_A_w; // Wire for signed A
wire [31:0] signed_B_w; // Wire for signed B
wire [31:0] choice_A_w; // Wire for signed A
wire [31:0] choice_B_w; // Wire for signed B
wire [63:0] unsigned_output_w; // Make a 64-bit wire for unsigned output
wire [63:0] twos_complement_w; // Make a 64-bit wire for signed output/2's complement of the output
wire [63:0] mux_output_w; // Make a 64-bit wire for the 64-bit multiplexer
wire xor_output_w; // Make a wire for the result of the xor gate's result

// Task 2: Calculate the sign of the output
xor xor_inst(xor_output_w, A[31], B[31]); // Calculate if the result is + or - based on the MSB's
// Task 3: Find 2's complement of A, B, and their product
TWOSCOMP32 twoscomp32_inst_1(signed_A_w, A); // Find the 2's complement of A and store it
MUX32_2x1 mux_inst1(choice_A_w, A, signed_A_w, A[31]); // Create a 32-bit 2x1 mux to choose signed or unsigned
TWOSCOMP32 twoscomp32_inst_2(signed_B_w, B); // Find the 2's complement of B and store it
MUX32_2x1 mux_inst2(choice_B_w, B, signed_B_w, B[31]); // Create a 32-bit 2x1 mux to choose signed or unsigned
MULT32_U multiplierU_inst(unsigned_output_w[63:32], unsigned_output_w[31:0], choice_A_w, choice_B_w); // Multiply: MULT32_U(HI, LO, A, B)
TWOSCOMP64 twoscomp64_inst(twos_complement_w, unsigned_output_w); // Find the 2's complement of the unsigned product and store it
// Task4: Instantiate a 64-bit 2x1 mux. Choose between unsigned or signed result based on xor calculation.
MUX64_2x1 mux64(mux_output_w, unsigned_output_w, twos_complement_w, xor_output_w);
BUF32x32 buff_1(LO, mux_output_w[31:0]); // First portion of 64 bit mux [0, 31] are LO portion of the product
BUF32x32 buff_2(HI, mux_output_w[63:32]); // Second portion of 64 bit mux [32, 63] are HI portion of the product
endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

// Unsigned Multiplication: Multiplicand = A, Multiplier = B
// Unsigned multiplication's diagram is implemented below
wire [31:0] carry_out_w;
wire [31:0] remainder_w [31:0];
AND32_2x1 and32_inst_int(remainder_w[0], A, {32{B[0]}});
buf buf_1(carry_out_w[0], 1'b0); // Wipe out carry_out_w
buf buf_2(LO[0], remainder_w[0][0]); // LO[0] = operand_2_wire[0][0]
genvar i;
generate
for (i = 1; i < 32; i = i + 1) begin : mul_U_32_loop
	wire [31:0] operand_w;
	AND32_2x1 and32_inst(operand_w, A, {32{B[i]}});
	RC_ADD_SUB_32 adder32_inst(remainder_w[i], carry_out_w[i], operand_w, 
		{carry_out_w[i - 1], {remainder_w[i - 1][31:1]}}, 1'b0);
	buf buf_inst(LO[i], remainder_w[i][0]); 
end
endgenerate
// Store carry out and remainder in HI
BUF32x32 buff_inst_last(HI, {carry_out_w[31],
	{remainder_w[31][31:1]}}); // Located in logic32bit file
endmodule

