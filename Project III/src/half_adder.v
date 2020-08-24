// Name: half_adder.v
// Module: HALF_ADDER
//
// Output: Y : Sum
//         C : Carry
//
// Input: A : Bit 1
//        B : Bit 2
//
// Notes: 1-bit half adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module HALF_ADDER(Y,C,A,B);
output Y,C;
input A,B;

xor xor_gate(Y, A, B); // Task 1: Half adder adds with XOR
and and_gate(C, A, B); // Task 2: Calculate carry

endmodule