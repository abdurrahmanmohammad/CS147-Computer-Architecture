`include "prj_definition.v"
module REGISTER_FILE_32x32_TB;
// Storage list
reg [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W; 
// Reset
reg READ, WRITE, RST;
reg [`DATA_INDEX_LIMIT:0] DATA_W; // Data register
// Variables
integer i; // index for memory operation
integer no_of_test, no_of_pass;

// Wire lists
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1;
wire [`DATA_INDEX_LIMIT:0] DATA_R2;

assign DATA_R1 = ((READ===1'b0)&&(WRITE===1'b1))?DATA_W:{`DATA_WIDTH{1'bz} };
assign DATA_R1 = ((READ===1'b0)&&(WRITE===1'b1))?DATA_W:{`DATA_WIDTH{1'bz} };

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// 32x32 register file instance
REGISTER_FILE_32x32 reg_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), 
	.ADDR_R2(ADDR_R2), .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), .WRITE(WRITE), 
	.CLK(CLK), .RST(RST));


initial begin
RST = 1'b1;
READ = 1'b0;
WRITE = 1'b0;
DATA_W = {`DATA_WIDTH{1'b0} };
no_of_test = 0;
no_of_pass = 0;

// Start the operation
#10    RST=1'b0;
#10    RST=1'b1;
// Write cycle
READ = 1'b0; // READ = 0
WRITE = 1'b1; // WRITE = 1
for (i = 1; i < 32; i = i + 1) begin
#10     DATA_W = i; ADDR_W = i; // R[i] = i
end
// Read Cycle
#10   READ = 1'b0; WRITE = 1'b0;
#5    no_of_test = no_of_test + 1;
      ADDR_R1 = 0; // Read the 0th address
      if (DATA_R1 !== {`DATA_WIDTH{1'bx}})
        $write("[TEST] Read %1b, Write %1b, expecting 32'hxxxxxxxx, got %8h [FAILED]\n", READ, WRITE, DATA_R1);
      else 
	no_of_pass  = no_of_pass + 1;

// Test of write data (Test using R1)
for (i = 1; i < 16; i = i + 1) begin
#5      READ = 1'b1; WRITE = 1'b0; ADDR_R1 = i;
#5      no_of_test = no_of_test + 1;
        if (DATA_R1 !== i)
	    $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [FAILED]\n", READ, WRITE, i, DATA_R1);
        else 
	    no_of_pass  = no_of_pass + 1;

end
// Test of write data (Test using R2)
for (i = 16; i < 32; i = i + 1) begin
#5      READ = 1'b1; WRITE = 1'b0; ADDR_R2 = i;
#5      no_of_test = no_of_test + 1;
        if (DATA_R2 !== i)
	    $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [FAILED]\n", READ, WRITE, i, DATA_R2);
        else 
	    no_of_pass  = no_of_pass + 1;

end
#10    READ=1'b0; WRITE=1'b0; // No op

#10 $write("\n");
    $write("\tTotal number of tests %d\n", no_of_test);
    $write("\tTotal number of pass  %d\n", no_of_pass);
    $write("\n");
    $writememh("reg_dump.dat", reg_inst.REGISTERS, 'h0000000, 'h000001f); // Dump all 32 registers
    $stop;
end
endmodule
