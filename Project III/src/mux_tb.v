`timescale 1ns/1ps
module mux_tb;
	reg operand1, operand2, control;
	wire result;
	MUX1_2x1 m1(.Y(result), .I0(operand1), .I1(operand2), .S(control));
	initial begin
		#5 control=0; operand1=0; operand2=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=0; operand1=1; operand2=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=0; operand1=0; operand2=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=0; operand1=1; operand2=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=1; operand1=0; operand2=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=1; operand1=1; operand2=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=1; operand1=0; operand2=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
		#5 control=1; operand1=1; operand2=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d, \tS = %d\t==> Result = %d", operand1, operand2, control, result);
	end
endmodule