// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, DATA_W, ADDR_W, READ, WRITE, CLK, RST);
// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

// Task 1: Add registers for corresponding output ports
reg [`DATA_INDEX_LIMIT:0] DATA_R1; // Register to return R1
reg [`DATA_INDEX_LIMIT:0] DATA_R2; // Register to return R2
// Task 2: Add 32x32 memory storage
reg [`DATA_INDEX_LIMIT:0] REGISTERS [0:`REG_INDEX_LIMIT]; // There are 32 32-bit registers
// Task 3: Add 'initial' block for initializing content of all 32 registers as 0
integer k; // k controls the for loops below
initial begin // When you start off, clear the memory by setting all address values to 0's
	for (k = 0; k <= `DATA_INDEX_LIMIT; k = k + 1)
    	REGISTERS[k] = {`DATA_WIDTH{1'b0}}; // Set all data to 0's
end

always @ (negedge RST or posedge CLK) begin // Whenever RST or CLK change, do:
// Task 4: Register block is reset on a negative edge of RST signal
if (RST == 1'b0) begin // Reset is done at -ve edge of the RST signal
	for (k = 0; k <= `DATA_INDEX_LIMIT; k = k + 1)
	REGISTERS[k] = {`DATA_WIDTH{1'b0}}; // Set all data to 0's (code makes 32 0's and stores them)
end
else begin // If RST is not on -ve, do:
// Task 5: On read request, both the content from address ADDR_R1 and ADDR_R2 are returned.
	if ((READ == 1'b1) && (WRITE == 1'b0)) begin // Read on, Write off
	// Read data
	DATA_R1 = REGISTERS[ADDR_R1]; // Read data at address ADDR_R1 and store it in the DATA_R1 output register
	DATA_R2 = REGISTERS[ADDR_R2]; // Read data at address ADDR_R2 and store it in the DATA_R2 output register
	end
// Task 6: On write request, ADDR_W content is modified to DATA_W
	else if ((READ == 1'b0) && (WRITE == 1'b1)) begin // Read off, Write on
	// Write data
	REGISTERS[ADDR_W] = DATA_W; // Store passed in DATA_W at ADDR_W in the register file
	end
// Do not handle read, write = 00 or 11	
end
end
endmodule
