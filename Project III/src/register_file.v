// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [4:0] ADDR_R1, ADDR_R2, ADDR_W;
output [`DATA_INDEX_LIMIT:0] DATA_R1,DATA_R2;

// --- My work below ---
wire inv_RST; // !RST - (reset on 1)
wire [`DATA_INDEX_LIMIT:0] decoder5x32_w; // Result of decoder5x32
wire [`DATA_INDEX_LIMIT:0] and_decoder5x32_w; // Result of (decoder5x32 & WRITE)
wire [`DATA_INDEX_LIMIT:0] REGISTERS [`DATA_INDEX_LIMIT:0]; // Array of 32 count 32-bit registers
wire [`DATA_INDEX_LIMIT:0] reg1_w; // ADDR_R1
wire [`DATA_INDEX_LIMIT:0] reg2_w; // ADDR_R2

// Decode WRITE ADDR
DECODER_5x32 decoder5x32_inst(.D(decoder5x32_w), .I(ADDR_W));
genvar i;
generate
for(i = 0; i < 32; i = i + 1) begin: register_file_w_decode_gen
	and and_inst(and_decoder5x32_w[i], decoder5x32_w[i], WRITE);
end
endgenerate

// Initialize the 32x32 registers
not not_inst(inv_RST, RST);
generate
for(i = 0; i < 32; i = i + 1) begin: register_file_32x32_loop
	REG32 reg32_inst(.Q(REGISTERS[i]), .D(DATA_W), .LOAD(and_decoder5x32_w[i]), .CLK(CLK), .RESET(RST)); // reset each register
end
endgenerate
// The 4 multiplexers in the diagram
// ADDR_R1 selection
MUX32_32x1 mux_inst_1(reg1_w, REGISTERS[0], REGISTERS[1], REGISTERS[2], REGISTERS[3], REGISTERS[4], REGISTERS[5], REGISTERS[6], REGISTERS[7], REGISTERS[8], 
	REGISTERS[9], REGISTERS[10], REGISTERS[11], REGISTERS[12], 
	REGISTERS[13], REGISTERS[14], REGISTERS[15], REGISTERS[16], REGISTERS[17], REGISTERS[18], REGISTERS[19], REGISTERS[20], REGISTERS[21], REGISTERS[22], 
	REGISTERS[23], REGISTERS[24], REGISTERS[25], REGISTERS[26], REGISTERS[27], REGISTERS[28], REGISTERS[29], REGISTERS[30], REGISTERS[31], ADDR_R1);
// ADDR_R2 selection
MUX32_32x1 mux_inst_2(reg2_w, REGISTERS[0], REGISTERS[1], REGISTERS[2], REGISTERS[3], REGISTERS[4], REGISTERS[5], REGISTERS[6], REGISTERS[7], REGISTERS[8], 
	REGISTERS[9], REGISTERS[10], REGISTERS[11], REGISTERS[12], REGISTERS[13], REGISTERS[14], REGISTERS[15], REGISTERS[16], REGISTERS[17], REGISTERS[18], 
	REGISTERS[19], REGISTERS[20], REGISTERS[21], REGISTERS[22], REGISTERS[23], REGISTERS[24], REGISTERS[25], REGISTERS[26], REGISTERS[27], 
	REGISTERS[28], REGISTERS[29], REGISTERS[30], REGISTERS[31], ADDR_R2);
MUX32_2x1 mux_inst_3(DATA_R1, 32'bZ, reg1_w, READ);  // Return data at ADDR_R1 if READ is on
MUX32_2x1 mux_inst_4(DATA_R2, 32'bZ, reg2_w, READ); // Return data at ADDR_R2 if READ is on
endmodule
