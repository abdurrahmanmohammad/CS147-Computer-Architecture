`timescale 1ns/1ps
module rc_add_sub_32_tb;
	reg [31:0] operand1, operand2;
	reg SnA;
	wire [31:0] result;
	wire carryOut;
	RC_ADD_SUB_32 rc_inst(.Y(result), .CO(carryOut), .A(operand1), .B(operand2), .SnA(SnA));
	initial begin
		#5 operand1 = 0; operand2 = 0; SnA = 0; // 0 + 0 = 0
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 0; operand2 = 0; SnA = 1; // 0 - 0 = 0
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 10; operand2 = 5; SnA = 0; // 10 + 5 = 15
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 10; operand2 = 5; SnA = 1; // 10 - 5 = 5
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 5; operand2 = 10; SnA = 0; // 5 + 10 = 15
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 5; operand2 = 10; SnA = 1; // 5 - 10 = -5 = 4294967291???
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);
		#5 operand1 = 0; operand2 = 1; SnA = 1; // 0 - 1 = -1
		#5 $write("\nOP1 = %d, OP2 = %d, SnA = %d\t ==> OP1 + OP2 = %d, CO = %d", operand1, operand2, SnA, result, carryOut);

	end
endmodule