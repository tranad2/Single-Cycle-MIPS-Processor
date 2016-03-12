module control_tb;
	logic[5:0]	Opcode;
	logic[5:0]	Func;
	wire[5:0]	ALUOp;

	wire	MemRead;
	wire	MemWrite;
	wire	MUX_MemToReg;
	wire	Branch;
	wire	ALUSrc;
	wire	RegDst;
	wire	RegWrite;
	
ControlUnit L1(
		.Opcode(Opcode),
		.Func(Func),
		.ALUOp(ALUOp),

		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.MUX_MemToReg(MUX_MemToReg),
		.Branch(Branch),
		.ALUSrc(ALUSrc),
		.RegDst(RegDst),
		.RegWrite(RegWrite)
		);

initial begin
	Func = 6'b000000;
	Opcode = 6'b000000;
		#100;
	Opcode = 6'b100011;
		#100;
	Opcode = 6'b101011;
		#100;
	
end
endmodule
	