`timescale 1ns/1ps
module half_adder_tb;
	reg A, B;
	wire Y, C;
	HALF_ADDER ha_inst(.Y(Y), .C(C), .A(A), .B(B));
	initial begin
		#5 A=0; B=0; // Initial values of OP1 and OP2
		#5 $write("\nOP1 = %d,\tOP2 = %d,\t==> OP1 + OP2 = %d,\tCO = %d", A, B, Y, C);
		#5 A=0; B=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\t==> OP1 + OP2 = %d,\tCO = %d", A, B, Y, C);
		#5 A=1; B=0;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\t==> OP1 + OP2 = %d,\tCO = %d", A, B, Y, C);
		#5 A=1; B=1;
		#5 $write("\nOP1 = %d,\tOP2 = %d,\t==> OP1 + OP2 = %d,\tCO = %d", A, B, Y, C);
		#5;
	end
endmodule 