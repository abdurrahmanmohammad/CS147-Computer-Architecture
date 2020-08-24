// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

wire [63:0] xor_result_w, co_w; // Make wires for the xor result (if we are adding or subtracting) and for the carry out
genvar i;
generate
for (i = 0; i < 64; i = i + 1) begin : rc_add_sub_64_loop // Loop 64 times for the 64 bits
	xor xor_inst(xor_result_w[i], SnA, B[i]); // xor every bit of the input: xor_result = SNA xor B[]
	if(i == 0) begin // For the first bit of the input: i = 0
		FULL_ADDER fa_inst(.S(Y[i]), .CO(co_w[i]), .A(A[i]), .B(xor_result_w[i]), .CI(SnA));
	end else if(i != 63 && i!= 0) begin // For all other bits other than first and last
		FULL_ADDER fa_inst(.S(Y[i]), .CO(co_w[i]), .A(A[i]), .B(xor_result_w[i]), .CI(co_w[i - 1]));
	end else if(i == 63) begin // For the last bit
		FULL_ADDER fa_inst(.S(Y[i]), .CO(CO), .A(A[i]), .B(xor_result_w[i]), .CI(co_w[i - 1])); // Transfer the CO
	end
	end
endgenerate
endmodule


module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [31:0] Y;
output CO;
// input list
input [31:0] A;
input [31:0] B;
input SnA;

wire [31:0] xor_result_w, co_w; // Make wires for the xor result (if we are adding or subtracting) and for the carry out
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin : rc_add_sub_31_loop // Loop 32 times for the 64 bits
	xor xor_inst(xor_result_w[i], SnA, B[i]); // xor every bit of the input: xor_result = SNA xor B[]
	if(i == 0) begin // For the first bit of the input: i = 0
		FULL_ADDER fa_inst(.S(Y[i]), .CO(co_w[i]), .A(A[i]), .B(xor_result_w[i]), .CI(SnA));
	end else if(i != 31 && i!= 0) begin // For all other bits other than first and last
		FULL_ADDER fa_inst(.S(Y[i]), .CO(co_w[i]), .A(A[i]), .B(xor_result_w[i]), .CI(co_w[i - 1]));
	end else if(i == 31) begin // For the last bit
		FULL_ADDER fa_inst(.S(Y[i]), .CO(CO), .A(A[i]), .B(xor_result_w[i]), .CI(co_w[i - 1])); // Transfer the CO
	end
	end
endgenerate
endmodule


