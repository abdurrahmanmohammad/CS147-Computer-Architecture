// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

// State nets
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

// ---------- My Code Below ----------

// Task 1: Add registers for corresponding output ports
// Registers for Register File
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W_REG;
reg [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W_REG, RF_ADDR_R1_REG, RF_ADDR_R2_REG;
reg RF_READ_REG, RF_WRITE_REG;
// Registers for ALU output
reg [`DATA_INDEX_LIMIT:0]  ALU_OP1_REG, ALU_OP2_REG;
reg  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN_REG;
// Registers for Memory output
reg [`ADDRESS_INDEX_LIMIT:0] MEM_ADDR_REG;
reg MEM_READ_REG, MEM_WRITE_REG;

// Assign outputs to corresponding registers
assign RF_DATA_W = RF_DATA_W_REG;
assign RF_ADDR_W = RF_ADDR_W_REG; 
assign RF_ADDR_R1 = RF_ADDR_R1_REG; 
assign RF_ADDR_R2 = RF_ADDR_R2_REG;
assign RF_READ = RF_READ_REG;
assign RF_WRITE = RF_WRITE_REG;
assign ALU_OP1 = ALU_OP1_REG;
assign ALU_OP2 = ALU_OP2_REG;
assign ALU_OPRN = ALU_OPRN_REG;
assign MEM_ADDR = MEM_ADDR_REG;
assign MEM_READ = MEM_READ_REG;
assign MEM_WRITE = MEM_WRITE_REG;
// Task 1 Finish

// Task 2: Define a register for write data to memory and connect DATA to this register similar to the DATA port in memory model
reg [`DATA_INDEX_LIMIT:0] MEM_DATA_REG;
// For memory read operation DATA must be set to HighZ and for write operation DATA must be set to internal write data register
assign MEM_DATA = ((MEM_READ === 1'b0)&&(MEM_WRITE === 1'b1))? MEM_DATA_REG:{`DATA_WIDTH{1'bz} }; // DATA set to HighZ
// Task 2 Finish

// Task 3: Add internal registers (PC_REG : Holds program counter value, INST_REG : Stores the current instruction, SP_REF : Stack pointer register)
reg [`ADDRESS_INDEX_LIMIT:0] PC_REG;
reg [`ADDRESS_INDEX_LIMIT:0] SP_REF;
reg [`DATA_INDEX_LIMIT:0] INST_REG;
// Task 3 Finish

// Task 4: For parsing an instruction (as mentioned in the guidelines)
reg [5:0] opcode; // 4-bit opcode
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
// Task 4 Finish

// Task 5: Need extra register to store
// Sign extended value of immediate, zero extended value of immediate, LUI value for I-type instruction
// For J-type instruction it would be good to store the 32-bit jump address from the address field
reg [`DATA_INDEX_LIMIT:0] SIGN_EXTENDED;
reg [`DATA_INDEX_LIMIT:0] ZERO_EXTENDED;
reg [`DATA_INDEX_LIMIT:0] LUI;
reg [`DATA_INDEX_LIMIT:0] JUMP_ADDRESS;
// Task 5 Finish

// Task 6: Initialize startup values
initial begin
PC_REG = 'h0001000;
SP_REF = 'h3ffffff;
end
// Task 6 Finish

// Always at the change of processor state set the control signal and address / data signal values properly for memory, register file and ALU
always @ (proc_state) begin // Whenever proc_state changes, do:

// ---------- Code for the control unit model ----------
// Task 7: `PROC_FETCH : Set memory address to program counter, memory control for read operation. 
// Also set the register file control to hold ({r,w} to 00 or 11) operation
if(proc_state === `PROC_FETCH) begin
 	MEM_ADDR_REG = PC_REG; // Set memory address to program counter
 	MEM_READ_REG = 1'b1; // Set memory control for read operation: read = 1
	MEM_WRITE_REG = 1'b0; // Set memory control for read operation: write = 0
 	RF_READ_REG = 1'b0; // Set the register file control to hold ({r,w} to 00 or 11) operation: read = 0
	RF_WRITE_REG = 1'b0; // Set the register file control to hold ({r,w} to 00 or 11) operation: write = 0
	end
// Task 7 Finish

if(proc_state === `PROC_DECODE) begin
	INST_REG = MEM_DATA; // Task 8: Store the memory read data into INST_REG
	print_instruction(INST_REG); // Task 9: You may use the following task code to print the current instruction fetched (defined at end of module)
	// Task 10: Parse the instruction (Code copied directly from guidelines with inst changed to INST_REG)
	{opcode, rs, rt, rd, shamt, funct} = INST_REG; // R-type
	{opcode, rs, rt, immediate } = INST_REG; // I-type
	{opcode, address} = INST_REG; // J-type
	// Task 10 Finish
	// Task 11: Calculate and store sign extended value of immediate, zero extended value of immediate, LUI value for I-type instruction
 	// To extend the sign, take the last bit of the immediate located at index 15. Duplicate it 16 times and append it to immediate.
	SIGN_EXTENDED = {{16{immediate[15]}},immediate};
	ZERO_EXTENDED = {16'b0, immediate}; // To extend zeros, append 16 zeros tot he front of immediate.
	LUI = {immediate, 16'b0}; // LUI instruction from lecture 1: R[rt] = {imm, 16'b0}. Translate it into Verilog.
	// For J-type instruction it would be good to store the 32-bit jump address from the address field
	JUMP_ADDRESS = {6'b0, address}; // Since address is 26 bit and you need a 32 bit value, append 6 zeros to make it 32 bit 
	// Task 11 Finish
	// Task 12: Set the read address of RF as rs and rt field value with RF operation set to reading
 	RF_ADDR_R1_REG = rs; // Set the read address of RF as rs and rt field value
	RF_ADDR_R2_REG = rt; // Set the read address of RF as rs and rt field value
 	RF_READ_REG = 1'b1; // With RF operation set to reading: READ = 1
	// Task 12 Finish
	end

// Task 13: In this stage, set the ALU operands and operation code accordingly the opcode/funct of the instruction
if(proc_state === `PROC_EXE) begin
 	case (opcode) // Switch based on operation code

	// ----- Below are the definitions of the "R-Type" instructions -----
	// Capture instructions which need additional components and define them
 	6'h00 : begin // For opcode = 000000
	if(funct === 6'h01 || funct === 6'h02) begin // For function codes 1 and 2 (shifts)
	ALU_OP1_REG = RF_DATA_R1; // Pass in the data/number to shift to the ALU
   	ALU_OP2_REG = shamt; // Pass in the shift amount
    	ALU_OPRN_REG = funct; // Pass in the function's opn to the ALU
   	end
	
	// PC = R[rs] (0x00 / 0x08) doesn't need any ALU operations. PC = R[rs] is done in WB stage
	else begin  // For all other operations, R[rd] = R[rs] {some operation (arithmetic or logical)} R[rt]
     	ALU_OP1_REG = RF_DATA_R1; // Pass in OP1
     	ALU_OP2_REG = RF_DATA_R2; // Pass in OP2
	ALU_OPRN_REG = funct; // Pass in the function's opn to the ALU
   	end
	end

	// ----- Below are the definitions of the "I-Type" instructions -----
 	6'h08 : begin // R[rt] = R[rs] + SignExtImm
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = SIGN_EXTENDED; // SignExtImm
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h20; // Add
	end
	6'h1d : begin // R[rt] = R[rs] * SignExtImm
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = SIGN_EXTENDED; // SignExtImm
	ALU_OPRN_REG =`ALU_OPRN_WIDTH'h2c; // Multiplication
 	end
	6'h0c : begin // R[rt] = R[rs] & ZeroExtImm
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = ZERO_EXTENDED; // ZeroExtImm
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h24; // Bitwise AND
	end
	6'h0d : begin // R[rt] = R[rs] | ZeroExtImm
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = ZERO_EXTENDED; // ZeroExtImm
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h25; // Bitwise OR
	end
	// R[rt] = {imm, 16'b0} [0x0f] (!!!Don't need ALU!!!) (Done in WB)
	6'h0a : begin // R[rt] = (R[rs] < SignExtImm)? 1:0
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = SIGN_EXTENDED; // SignExtImm
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h2a; // Set less than
	end
	6'h04, 6'h05 : begin
	// If (R[rs] == R[rt]) 			opcode[0x04]
		//PC = PC + 1 + BranchAddress
	//If (R[rs] != R[rt]) 			opcode[0x05]
		//PC = PC + 1 + BranchAddress
	// --- Do a subtractoin between R[rs] and R[rt] and evaluate ZERO flag from ALU ---
     	ALU_OP1_REG = RF_DATA_R1; // Pass in R[rs]
     	ALU_OP2_REG = RF_DATA_R2; // Pass in R[rt]
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h22; // Perform a subtraction (ZERO flag is evaluated at WB)
	end
	6'h23, 6'h2b : begin
	// R[rt] = M[R[rs]+SignExtImm]		opcode[0x23]
	// M[R[rs]+SignExtImm] = R[rt] 		opcode[0x2b]
	// --- Do R[rs]+SignExtImm ---
	ALU_OP1_REG = RF_DATA_R1; // R[rs]
	ALU_OP2_REG = SIGN_EXTENDED; // SignExtImm
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h20; // Addition
	end	

	// ----- Below are the definitions of the "J-Type" instructions -----
	// Some operation may not need ALU operation (like lui, jmp or jal)
	6'h1b : begin // PUSH operation:  M[$sp] = R[0], sp = sp - 1
	// For 'push' operation, the RF ADDR_R1 needs to be set to 0
	RF_ADDR_R1_REG = 0; // Register file address of the memory location to be read for RF_DATA_R1
	// $sp = $sp - 1 done in ALU
	ALU_OP1_REG = SP_REF; // Pass in SP
	ALU_OP2_REG = 1; // Pass in 1
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h22; // Subtraction
	end
	6'h1c : begin // POP operation
	// $sp = $sp + 1 done in ALU
	ALU_OP1_REG = SP_REF; // Pass in SP
	ALU_OP2_REG = 1; // Pass in 1
	ALU_OPRN_REG = `ALU_OPRN_WIDTH'h20; // Addition
	end
	endcase
	end
// Task 12 Finish


// Task 13: Only 'lw', 'sw', 'push' and 'pop' instructions are involved in this stage. 
if(proc_state === `PROC_MEM) begin
 	MEM_READ_REG = 1'b0; // By default, make the memory operation to 00 or 11
 	MEM_WRITE_REG = 1'b0; // By default, make the memory operation to 00 or 11
 	case (opcode) 
	6'h23 : begin // LW instruction
   	MEM_READ_REG = 1'b1; // Memory Read = 1
   	MEM_ADDR_REG = ALU_RESULT; // M[R[rs]+SignExtImm]
 	end
 	6'h2b : begin // SW instruction
  	MEM_WRITE_REG = 1'b1; // Memory Write = 1
   	MEM_ADDR_REG = ALU_RESULT; // M[R[rs]+SignExtImm]. ALU_RESULT = R[rs]+SignExtImm.
   	MEM_DATA_REG = RF_DATA_R2; // M[R[rs]+SignExtImm] = R[rt], R[rt] = RF_DATA_R2
	end  
	6'h1b : begin // PUSH instruction
   	MEM_WRITE_REG = 1'b1; // Memory Write = 1
   	MEM_ADDR_REG = SP_REF; // Access memory address M[$sp]
   	MEM_DATA_REG = RF_DATA_R1; // --> M[$sp] = R[0]
   	SP_REF = ALU_RESULT; // $sp = $sp - 1
 	end
	6'h1c : begin  // POP instruction
   	MEM_READ_REG = 1'b1; // Memory Read = 1
  	SP_REF = ALU_RESULT; // $sp = $sp + 1
   	MEM_ADDR_REG = SP_REF; // Access memory address M[$sp]. We will store data in WB.
 	end
 	endcase
	end
// Task 13 Finish


// Task 14: Write back to RF or PC _REG is done here
if(proc_state === `PROC_WB) begin // For the Write Back stage:
	PC_REG = PC_REG + 1; // Increase PC_REG by 1 by default
	MEM_READ_REG = 1'b0; // Reset the memory read signal to no-op (00 or 11)
	MEM_WRITE_REG = 1'b0; // Reset the memory write signal to no-op (00 or 11)
	// Set RF writing address, data and control to write back into register file. For most of the instruction this is needed.
	RF_READ_REG = 1'b0; // RF Read = 0
	RF_WRITE_REG = 1'b1; // RF Write = 1

  	case (opcode)
 	// ----- R-Type WB -----
 	6'h00 : begin // For opcode 000000
   	if(funct === 6'h08) // The program counter is a special component to this R-Type instruction for WB
	// Earlier, we defined: RF_ADDR_R1_REG = rs
     	PC_REG = RF_DATA_R1; // PC = R[rs]
   	else begin // For the rest of the instructions, store ALU's result at address pointed by R[rd]
	// Store ALU's result: R[rd] = R[rs] x R[rt], x = any arithmetic or logical operation
     	RF_ADDR_W_REG = rd; // Access address R[rd]
    	RF_DATA_W_REG = ALU_RESULT; // Store ALU's result at rs's address in Register File
   	end
 	end

 	// ----- I-Type WB -----
 	6'h08, 6'h1d : begin // R[rt] = R[rs] x SignExtImm, x = {+, *}
  	RF_ADDR_W_REG = rt; // Access address R[rt]
  	RF_DATA_W_REG = ALU_RESULT; // Store ALU's result at R[rt]
 	end

 	6'h0c, 6'h0d : begin // R[rt] = R[rs] x ZeroExtImm, x = {&, |}
  	RF_ADDR_W_REG = rt; // Access address R[rt]
  	RF_DATA_W_REG = ALU_RESULT; // Store ALU's result at R[rt]
 	end
	
	6'h0f : begin // R[rt] = {imm, 16'b0}
	RF_ADDR_W_REG = rt; // Access address R[rt]
  	RF_DATA_W_REG = LUI; // Store {imm, 16'b0} which is calculated and stored in LUI
	end
	6'h0a : begin // R[rt] = (R[rs] < SignExtImm) ? 1 : 0
  	RF_ADDR_W_REG = rt; // Access address R[rt]
  	RF_DATA_W_REG = ALU_RESULT; // Store ALU's result slti at R[rs]
 	end
 	6'h04 : begin
  	if (ZERO) // If (R[rs] == R[rt])
	// Evaluate zero flag. If 2 numbers are equal, their difference is 0. Zero flag should be 1 if result is 0.
    	PC_REG = PC_REG + SIGN_EXTENDED; // PC = PC + 1 + BranchAddress. PC + 1 is already evaluated. Just add BranchAddress.
 	end
 	6'h05 : begin
  	if (~ZERO) // If (R[rs] != R[rt])
	// Evaluate zero flag. If 2 numbers are not equal, their difference is not 0. Zero flag should be 0 if result != 0.
    	PC_REG = PC_REG + SIGN_EXTENDED; // PC = PC + 1 + BranchAddress. PC + 1 is already evaluated. Just add BranchAddress.
 	end
 	6'h23 : begin
	// MEM read = 0, MEM write = 1
   	RF_ADDR_W_REG = rt; // Access address R[rt]
	// MEM_DATA_REG's address M[R[rs]+SignExtImm] was assigned to MEM_ADDR_REG in the memory cycle 
   	RF_DATA_W_REG = MEM_DATA_REG; // Store M[R[rs]+SignExtImm] at R[rt]
 	end
	// M[R[rs]+SignExtImm] = R[rt] [0x2b] !!!already done in MEM step

 	// ----- J-Type WB -----
 	6'h02 : begin // jmp
	PC_REG = JUMP_ADDRESS; // PC = JumpAddress
	end
 	6'h03 : begin // jal
	// R[31] = PC + 1; PC = JumpAddress
   	RF_ADDR_W_REG = 31; // Set address to access R[31]
   	RF_DATA_W_REG = PC_REG; // Assign the current value of PC (PC + 1 to R[31]). R[31] = PC + 1
	PC_REG = JUMP_ADDRESS; // PC = JumpAddress
 	end
	// PUSH instruction (M[$sp] = R[0]; $sp = $sp - 1) was done in memeory and SP was decremented. Not involved in WB.
	6'h1c : begin // POP instruction
	// For 'pop' operation, the RF ADDR_R1 needs to be set to 0. Instead of RF ADDR_R1 = 0, we can set RF_ADDR_W_REG = 0;
	RF_ADDR_W_REG = 0; // Set the address to access as 0. R[0]
   	RF_DATA_W_REG = MEM_DATA; // R[0] = M[$sp]
	end
	endcase
	end
// Task 14 Finish
end
task print_instruction;
input [`DATA_INDEX_LIMIT:0] inst;
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
begin
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = inst;
// I-type
{opcode, rs, rt, immediate } = inst;
// J-type
{opcode, address} = inst;
$write("@ %6dns -> [0X%08h] ", $time, inst);
case(opcode)
// R-Type
6'h00 : begin
case(funct)
6'h20: $write("add r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h22: $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h2c: $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h24: $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h25: $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h27: $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h2a: $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
6'h01: $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
6'h02: $write("srl r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
6'h08: $write("jr r[%02d];", rs);
default: $write("");
endcase
end
// I-type
6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
// J-Type
6'h02 : $write("jmp 0X%07h;", address);
6'h03 : $write("jal 0X%07h;", address);
6'h1b : $write("push;");
6'h1c : $write("pop;");
default: $write("");
endcase
$write("\n");
end
endtask
endmodule

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE, CLK, RST);
input CLK, RST; // list of inputs
output [2:0] STATE; // list of outputs

// ---------- State Machine Implementation Below ----------

// Task 1: Make registers for output
reg [2:0] state; // State register defined. There are 5 states, 3 bits (proc_state was defined as [2:0]
reg [2:0] next_state; // Next state register defined. There are 5 states, 3 bits
assign STATE = state; // Assign state register to STATE
// Task 2: At 'initial' set the next state as `PROC_FETCH and state to 3 bit unknown (3'bxx)
initial begin
	next_state = `PROC_FETCH;
	state = 3'bxx;
end
// Task 3: At reset set the next state as `PROC_FETCH and state to 3 bit unknown (3'bxx)
always @(negedge RST) begin
	next_state = `PROC_FETCH;
	state = 3'bxx;
	end
// Task 4: Determine next_state depending on current state value
always @(posedge CLK) begin
	case(STATE)
	`PROC_FETCH: next_state = `PROC_DECODE;
	`PROC_DECODE: next_state = `PROC_EXE;
	`PROC_EXE: next_state = `PROC_MEM;
	`PROC_MEM: next_state = `PROC_WB;
	`PROC_WB: next_state = `PROC_FETCH;
	endcase
state = next_state; // Task 5: Upon each positive edge of clock, assign state with next_state value
end
endmodule