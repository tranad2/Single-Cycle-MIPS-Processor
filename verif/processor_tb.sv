module processor_tb;
	logic ref_clk;
		
processor L1(
		.ref_clk(ref_clk),
		.reset(reset)
		);

initial begin
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
	ref_clk = 1'b0;
		#50;
	ref_clk = 1'b1;
		#50;
end
endmodule