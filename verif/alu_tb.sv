module alu_tb;
	logic[5:0]	Func_in;
	logic[31:0]	A_in;
	logic[31:0] B_in;
	wire[31:0]	O_out;
	wire		Branch_out;
	wire		Jump_out;
	
alu L1(
		.Func_in(Func_in),
		.A_in(A_in),
		.B_in(B_in),
		.O_out(O_out),
		.Branch_out(Branch_out),
		.Jump_out(Jump_out)
		);

initial begin
	A_in = 32'b00000000000000000000000000000101;
	B_in = 32'b00000000000000000000000000000001;
	Func_in = 6'b100000;		/*add*/
		#100;
	Func_in = 6'b100010;		/*sub*/
		#100;
	Func_in = 6'b100100;		/*and*/
		#100;
	Func_in = 6'b100101;		/*or*/
		#100;
	Func_in = 6'b100110;		/*xor*/
		#100;
	Func_in = 6'b100111;		/*nor*/
		#100;
	Func_in = 6'b101000;		/*slt*/
		#100;
	A_in = 32'b00000000000000000000000000000001;
	B_in = 32'b00000000000000000000000000000101;
	Func_in = 6'b101000;		/*slt*/
		#100;
	Func_in = 6'b111000;		/*bltz*/
		#100;
	Func_in = 6'b111001;		/*bgez*/
		#100;
	Func_in = 6'b111010;		/*jump*/
		#100;
	Func_in = 6'b111011;		/*jump*/
		#100;
	Func_in = 6'b111100;		/*beq*/
		#100;
	Func_in = 6'b111101;		/*bne*/
		#100;
	Func_in = 6'b111110;		/*blez*/
		#100;
	Func_in = 6'b111111;		/*bgtz*/
		#100;
	
end
endmodule
	