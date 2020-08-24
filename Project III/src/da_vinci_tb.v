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
wire [`DATA_INDEX_LIMIT:0] DATA_OUT, DATA_IN;

// reset
reg RST;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// DA_VINCI v1.0 instance
defparam da_vinci_inst.mem_init_file = "fibonacci.dat";
//defparam da_vinci_inst.mem_init_file = "RevFib.dat";
DA_VINCI da_vinci_inst(.MEM_DATA_OUT(DATA_OUT), .MEM_DATA_IN(DATA_IN), 
                       .ADDR(ADDR), .READ(READ), 
                       .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin
RST=1'b1;
#5 RST=1'b0;
#5 RST=1'b1;

// TBD: rest of the test code goes here.

//# 20 $stop;
#5000  //$writememh("RevFib_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h03fffff0, 'h03ffffff);
       $writememh("fibonacci_mem_dump.dat", da_vinci_inst.memory_inst.memory_inst.sram_32x64m, 'h01000000, 'h0100000f);
       $stop;

end
endmodule;

