// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire [31:0] shift_result_w; //Shifter result wire
wire or_w; // Or result wire
BARREL_SHIFTER32 barrelShifter32_inst(shift_result_w, D, S[4:0], LnR);
or or_inst(or_w, S[5], S[6], S[7], S[8], S[9], S[10], S[11], S[12], S[13], 
	S[14], S[15], S[16], S[17], S[18], S[19], S[20], S[21], S[22], 
	S[23], S[24], S[25], S[26], S[27], S[28], S[29], S[30], S[31]);
MUX32_2x1 mux32_inst(Y, shift_result_w, 32'h0, or_w);
endmodule



// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;

wire [31:0] left_w; //result from LShift
wire [31:0] right_w; //result from RShift
SHIFT32_R r_shifter_inst(right_w, D, S);
SHIFT32_L l_shifter_inst(left_w, D, S);
MUX32_2x1 mux32_inst(Y, right_w, left_w, LnR);
endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

// Wires between the multiplexers
wire [31:0] wire0; // Shift 1-bit Y/N Result
wire [31:0] wire1; // Shift 2-bit Y/N Result
wire [31:0] wire2; // Shift 4-bit Y/N Result
wire [31:0] wire3; // Shift 8-bit Y/N Result

MUX32_2x1 mux_inst0(wire0, D, {1'b0,D[31:1]}, S[0]); // (Shift 1-bit <<1) Choose between D and shifted D
MUX32_2x1 mux_inst1(wire1, wire0, {2'b0,wire0[31:2]}, S[1]);// (Shift 2-bit <<2) Choose between D and shifted D
MUX32_2x1 mux_inst2(wire2, wire1, {4'b0,wire1[31:4]}, S[2]); // (Shift 4-bit <<4) Choose between D and shifted D
MUX32_2x1 mux_inst3(wire3, wire2, {8'b0,wire2[31:8]}, S[3]); // (Shift 8-bit <<8) Choose between D and shifted D
MUX32_2x1 mux_inst4(Y, wire3, {16'b0,wire3[31:16]}, S[4]); // (Shift 16-bit <<16) Choose between D and shifted D
endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

// Wires between the multiplexers
wire [31:0] wire0; // Shift 1-bit Y/N Result
wire [31:0] wire1; // Shift 2-bit Y/N Result
wire [31:0] wire2; // Shift 4-bit Y/N Result
wire [31:0] wire3; // Shift 8-bit Y/N Result

MUX32_2x1 mux_inst0(wire0, D , {D[30:0],1'b0}, S[0]); // (Shift 1-bit <<1) Choose between D and shifted D
MUX32_2x1 mux_inst1(wire1, wire0, {wire0[29:0],2'b0}, S[1]); // (Shift 2-bit <<2) Choose between D and shifted D
MUX32_2x1 mux_inst2(wire2, wire1, {wire1[27:0],4'b0}, S[2]); // (Shift 4-bit <<4) Choose between D and shifted D
MUX32_2x1 mux_inst3(wire3, wire2, {wire2[23:0],8'b0}, S[3]); // (Shift 8-bit <<8) Choose between D and shifted D
MUX32_2x1 mux_inst4(Y, wire3, {wire3[15:0],16'b0}, S[4]); // (Shift 16-bit <<16) Choose between D and shifted D
endmodule

