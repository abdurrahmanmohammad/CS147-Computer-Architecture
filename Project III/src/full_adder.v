// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;

// Task 1: Create wires
wire ha1_result; // Half adder 1 operand
wire ha1_co; // Half adder 1 carry out
wire ha2_co; // Half adder 2 carry out
// Task 2: Instantiate 2 half adders and connect them
HALF_ADDER ha_inst_1(.Y(ha1_result), .C(ha1_co), .A(A), .B(B));
HALF_ADDER ha_inst_2(.Y(S), .C(ha2_co), .A(ha1_result), .B(CI));
// Task 3: Calculate carry out: CO = (ha1_co || ha2_co)
or or_inst(CO, ha1_co, ha2_co);
endmodule
