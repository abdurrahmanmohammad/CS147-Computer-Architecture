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
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
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

// Task 1: Add registers for corresponding output ports
// Simulates internal storage (registers) 
reg [`DATA_INDEX_LIMIT:0] OUT; // We need a register for the output OUT
reg ZERO; // We need a register for the zero flag
// Task 1 Finish


always @(OP1 or OP2 or OPRN) begin
// Task 2: Define operations
    case (OPRN) // Start of case block
	 // Operations are defined below according to 'CS147DV' Instruction Set
        `ALU_OPRN_WIDTH'h20 : OUT = (OP1 + OP2); // Addition
	`ALU_OPRN_WIDTH'h22 : OUT = (OP1 - OP2); // Subtraction
        `ALU_OPRN_WIDTH'h2c : OUT = (OP1 * OP2); // Multiplication
	`ALU_OPRN_WIDTH'h24 : OUT = (OP1 & OP2); // Bitwise AND
	`ALU_OPRN_WIDTH'h25 : OUT = (OP1 | OP2); // Bitwise OR
	`ALU_OPRN_WIDTH'h27 : OUT = ~(OP1 | OP2); // Bitwise NOR
	`ALU_OPRN_WIDTH'h2a : OUT = (OP1 < OP2) ? 1 : 0; // Set less than
	`ALU_OPRN_WIDTH'h01 : OUT = (OP1 << OP2); // Shift_Left
	`ALU_OPRN_WIDTH'h02 : OUT = (OP1 >> OP2); // Shift_Rigth
        default: OUT = `DATA_WIDTH'hxxxxxxxx; 
    endcase // End of case block
// Task 2 Finish
end

// Task 3: Extend the functionality to set the 'ZERO' output
always @(OUT) begin // Whenever the output changes, evaluate zero flag
	ZERO = (OUT == 0) ? 1'b1 : 1'b0; // The zero flag is evaluated
end
// Task 3 Finish
endmodule
