  `timescale 1ns/1ps
module full_adder_tb;
	reg operand1, operand2, carryIn; 
	wire sum, carryOut;
	FULL_ADDER fa_inst(.S(sum), .CO(carryOut), .A(operand1), .B(operand2), .CI(carryIn));
	// OP1 = A, OP2 = B, Carry In = CI, SUM = S, Carry Out = CO
	initial begin
		#5 operand1 = 0; operand2 = 0; carryIn = 0;  // Initial values of OP1 and OP2
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=1; operand2=0; carryIn=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=0; operand2=1; carryIn=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=1; operand2=1; carryIn=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=0; operand2=0; carryIn=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=1; operand2=0; carryIn=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=0; operand2=1; carryIn=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5 operand1=1; operand2=1; carryIn=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\tCI = %d,\t==> OP1 + OP2 = %d,\tCO = %d", operand1, operand2, carryIn, sum, carryOut);
		#5;
	end
endmodule