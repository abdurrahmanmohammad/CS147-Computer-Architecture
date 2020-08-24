// Name: da_vinci_tb.v
// Module: DA_VINCI_TB
// 
// Outputs are for testbench observations only
//
// Monitors:  DATA : Data to be written at address ADDR
//            ADDR : Address of the memory location to be accessed
//            READ : Read signal
//            WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - Testbench for DA_VINCI system
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module DA_VINCI_TB;
// output list
wire [`ADDRESS_INDEX_LIMIT:0] ADDR;
wire READ, WRITE, CLK;
// inout list
wire [`DATA_INDEX_LIMIT:0] DATA;

// reset
reg RST;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// DA_VINCI v1.0 instance

// --- Provided Test Cases ---
//defparam da_vinci_inst.mem_init_file = "fibonacci.dat";
//defparam da_vinci_inst.mem_init_file = "RevFib.dat";
// ---Additional Test Cases ---
//defparam da_vinci_inst.mem_init_file = "Test_R-Type.dat";
//defparam da_vinci_inst.mem_init_file = "Test_I-Type.dat";
//defparam da_vinci_inst.mem_init_file = "Test_J-Type.dat";
defparam da_vinci_inst.mem_init_file = "Test_System.dat";

DA_VINCI da_vinci_inst(.DATA(DATA), .ADDR(ADDR), .READ(READ), 
                       .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial begin
RST=1'b1;
#5 RST=1'b0;
#5 RST=1'b1;

//#20 $stop;
#5000 
	// --- Provided Test Cases --- 
	//$writememh("fibonacci_mem_dump.dat", da_vinci_inst.memory_inst.sram_32x64m, 'h01000000, 'h0100000f);
	//$writememh("RevFib_mem_dump.dat", da_vinci_inst.memory_inst.sram_32x64m, 'h03fffff0, 'h03ffffff);
	// ---Additional Test Cases ---
	//$writememh("Dump_Test_R-Type.dat", da_vinci_inst.processor_inst.rf_inst.REGISTERS, 'h00000000, 'h0000000f); // Dump the registers
	//$writememh("Dump_Test_I-Type.dat", da_vinci_inst.processor_inst.rf_inst.REGISTERS, 'h00000000, 'h0000000f); // Dump the registers
	// --- J-Type test can dump memory and registers. Be sure to seect both ---	
	//$writememh("Dump_REG_Test_J-Type.dat", da_vinci_inst.processor_inst.rf_inst.REGISTERS, 'h00000000, 'h0000000f); // Dump the registers
	//$writememh("Dump_MEM_Test_J-Type.dat", da_vinci_inst.memory_inst.sram_32x64m, 'h03fffff0, 'h03ffffff); // Dump the memory
	// --- System Test Below ---
	$writememh("Dump_Test_System.dat", da_vinci_inst.memory_inst.sram_32x64m, 'h02000000, 'h0200000f);
        $stop;
end
endmodule

