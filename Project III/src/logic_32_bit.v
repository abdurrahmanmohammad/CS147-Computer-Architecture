// Name: logic_32_bit.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//

// 32-bit NOR
module NOR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

wire [31:0] or_w; // Wire to transfer the result of 32-bit or
OR32_2x1 or32_inst(.Y(or_w), .A(A), .B(B)); // OR A
INV32_1x1 inv32_inst(.Y(Y), .A(or_w)); // INV (OR A)

endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;
// My work below
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin : and32_gen_loop
	and and_inst(Y[i], A[i], B[i]);
end
endgenerate
endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;

// My work below
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin : inv32_gen_loop
	not not_inst(Y[i], A[i]);
end
endgenerate
endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

// My work below
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin : or32_gen_loop
	or or_inst(Y[i], A[i], B[i]);
end
endgenerate
endmodule
// BUFF 32x32
module BUF32x32(Y, S);
output [31:0] Y;
input [31:0] S;
genvar i;
generate
for(i = 0; i < 32; i = i + 1) begin: buf32x32_loop
	buf buf_inst(Y[i], S[i]);
end
endgenerate
endmodule 