// Name: logic.v
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
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

// --- My work below ---
wire[63:0] not_w;
wire empty;
reg add = 0;
reg [63:0] adding = 1;

genvar i;
generate
for(i = 0; i < 64; i = i + 1) begin
	not not_inst(not_w[i], A[i]);
end
endgenerate
RC_ADD_SUB_64 rc_add_sub_32_inst(Y, empty, not_w, adding, add);
endmodule



// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

// --- My work below ---
wire [31:0] not_w ;
wire empty;
reg addZero = 0;
reg [31:0] addOne = 1;

genvar i;
generate
for(i = 0; i < 32; i = i + 1) begin
	not not_inst(not_w[i], A[i]);
end
endgenerate
RC_ADD_SUB_32 rc_add_sub_32_inst(Y, empty, not_w, addOne, addZero);
endmodule



// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;
input CLK, LOAD;
input [31:0] D;
input RESET;

// --- My work below ---
genvar i;
generate
for(i = 0; i < 32; i = i + 1)begin : reg32_loop
	wire Qbar; 
	REG1 reg1_inst(.Q(Q[i]), .Qbar(Qbar), .D(D[i]), 
	.L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
end
endgenerate 
endmodule



// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

// --- My work below ---
wire mux_w;
MUX1_2x1 mux_inst(mux_w, Q, D, L);
D_FF dff(.Q(Q), .Qbar(Qbar), .D(mux_w), .C(C), .nP(nP), .nR(nR));
endmodule



// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

// --- My work below ---
wire Y, Ybar, inv_C;
not not_inst(inv_C, C);
D_LATCH dlatch_inst(.Q(Y), .Qbar(Ybar), .D(D), .C(inv_C), .nP(nP), .nR(nR));
SR_LATCH srlatch_inst(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));
endmodule



// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

// --- My work below ---
wire inv_D_w, and_1_w, and_2_w;
not not_inst(inv_D_w, D);
nand nand_inst1(and_1_w, D, C);
nand nand_inst2(and_2_w, inv_D_w, C);
nand nand_inst3(Q, Qbar, and_1_w, nP); // nR
nand nand_inst4(Qbar, Q, and_2_w, nR); // nP
endmodule



// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

// --- My work below ---
wire and_1_w, and_2_w;
nand nand_inst1(and_1_w, S, C);
nand nand_inst2(and_2_w, R, C);
nand nand_inst3(Q, Qbar, and_1_w, nP);
nand nand_inst4(Qbar, Q, and_2_w, nR);
endmodule


// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

// --- My work below ---
wire [16:0] inv_I;
DECODER_4x16 decoder4x16_inst(inv_I[15:0], I[3:0]);
not not_inst(inv_I[16], I[4]);
genvar i;
generate
for(i = 0; i < 16; i = i + 1) begin : decoder4x16_loop
	and and_inst0(D[i], inv_I[i], inv_I[16]);
	and and_inst1(D[i + 16], inv_I[i], I[4]);
end
endgenerate
endmodule    



// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

// --- My work below ---
wire [8:0] inv_I;
DECODER_3x8 decoder3x8_inst(inv_I[7:0], I[2:0]);
not not_inst(inv_I[8], I[3]);
genvar i;
generate
for(i = 0; i < 8; i = i + 1) begin : decoder3x8_loop
	and and_inst0(D[i], inv_I[i], inv_I[8]); // D[0] to D[7] = decoder3x8_w[i] AND ~I[3]
	and and_inst1(D[i + 8], inv_I[i], I[3]); // D[8] to D[15] = decoder3x8_w[i] AND I[3]
end
endgenerate
endmodule



// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

// --- My work below ---
wire [4:0] inv_I;
not not_inst(inv_I[4], I[2]);
DECODER_2x4 decoder2x4_inst(inv_I[3:0], I[1:0]);
genvar i;
generate
for(i = 0; i < 4; i = i + 1) begin : decoder2x4_loop
	and and_inst0(D[i], inv_I[i], inv_I[4]);
	and and_inst1(D[i + 4], inv_I[i], I[2]);
end
endgenerate
endmodule


// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

// --- My work below ---
wire [1:0] inv_I;
// The 2 NOT gates
not not_0(inv_I[0], I[0]); // NOT I0
not not_1(inv_I[1], I[1]); // NOT I1
// The 4 AND gates
and and_0(D[0], inv_I[0], inv_I[1]); // D0 = ~I1 AND ~I0
and and_1(D[1], inv_I[1], I[0]);  // D1 = ~I1 AND I0
and and_2(D[2], inv_I[0], I[1]); // D2 = I1 AND ~I0
and and_3(D[3], I[0], I[1]); // D3 = I1 AND I0
endmodule 

