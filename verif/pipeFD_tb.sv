module pipeFD_tb;
	logic		clk;
	logic		stallD;
	logic[31:0]	dataIO_in;
	wire[31:0]	dataIO_out;
	
pipeFD L1(
		.clk(clk),
		.stallD(stallD),
		.dataIO_in(dataIO_in),
		.dataIO_out(dataIO_out)
		);

initial begin
	stallD = 1'b0;
	dataIO_in = 32'b00000000000000000000000000000000;
	clk = 1'b0;
		#100;
	dataIO_in = 32'b11111111111111111111111111111111;
	clk = 1'b1;
		#100;
	dataIO_in = 32'b01010101010101010101010101010101;
	clk = 1'b0;
		#100;
	clk = 1'b1;
		#100;
	stallD = 1'b1;
	clk = 1'b0;
		#100;
	clk = 1'b1;
		#100;	
		
end
endmodule