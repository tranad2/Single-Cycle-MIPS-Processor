module regfile_tb;
	logic	clk;
	logic	rst_s;
	logic	we;
	logic[4:0]	raddr_1;
	logic[4:0]	raddr_2;
	logic[4:0]	waddr;
	wire[31:0]	rdata_1;
	wire[31:0]	rdata_2;
	logic[31:0]	wdata;
	
regfile L1(
		.clk(clk),
		.rst_s(rst_s),
		.we(we),
		.raddr_1(raddr_1),
		.raddr_2(raddr_2),
		.waddr(waddr),
		.rdata_1(rdata_1),
		.rdata_2(rdata_2),
		.wdata(wdata)
		);

initial begin
	raddr_1 = 5'd5;
	raddr_2 = 5'd7;
	waddr = 5'd5;
	wdata = 32'd10;
	/*First cycle*/
	clk = 0;
	rst_s = 1;
	we = 0;
		#100;
	clk=1;
		#100;
	/*Second cycle*/

	clk = 0;
	rst_s = 1;
	we = 1;
		#100;
	clk = 1;
		#100;
	/*Third cycle*/
	clk = 0;
	rst_s = 0;
	we = 0;
		#100;
	clk = 1;
		#100;
	/*Fourth cycle*/
	/*Write into register R5 with value 10*/
	clk = 0;
	rst_s = 0;
	we = 1;
		#100;
	clk = 1;
		#100;
	/*Fifth cycle*/
	/*Write into register R6 with value 1*/
	raddr_1 = 5'd6;
	raddr_2 = 5'd5;
	wdata = 32'd1;
	waddr = 5'd6;
	clk = 0;
	rst_s = 0;
	we = 1;
		#100;
	clk = 1;
		#100;
end
endmodule
	