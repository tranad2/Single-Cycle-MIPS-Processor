module program_counter_tb;
	logic 		reset;
	logic 		clk;
	wire[31:0] 	o;
	
program_counter L1(
			.reset(reset),
			.clk(clk),
			.o(o)
			);

initial begin
	clk = 1'b0;
		#50;
	clk = 1'b1;
		#50;
	clk = 1'b0;
		#50;
	clk = 1'b1;
		#50;
	clk = 1'b0;
		#50;
	clk = 1'b1;
		#50;
	clk = 1'b0;
		#50;
	clk = 1'b1;
		#50;
	clk = 1'b0;
	reset = 1'b1;
		#50;
	clk = 1'b1;
		#50;

end
endmodule