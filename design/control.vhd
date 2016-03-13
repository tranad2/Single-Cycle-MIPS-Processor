LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ControlUnit IS
	PORT(
		Opcode: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		Func: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		ALUOp: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);

		MemRead: OUT STD_LOGIC;
		MemWrite: OUT STD_LOGIC;
		MUX_MemToReg: OUT STD_LOGIC;
		Branch: OUT STD_LOGIC;
		Branch_NE: OUT STD_LOGIC;
		ALUSrc: OUT STD_LOGIC;
		RegDst: OUT STD_LOGIC;
		RegWrite: OUT STD_LOGIC;
		Jump: OUT STD_LOGIC;
		JAL_addr_ctrl: OUT STD_LOGIC;
		JAL_data_ctrl: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		JR_out: OUT STD_LOGIC;
		Load: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		SB_out: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	
	);
	
END ControlUnit ;

ARCHITECTURE arch_ControlUnit OF ControlUnit IS
	SIGNAL R_TYPE, SW, LW, BEQ, BNE, J, ADDI, SLL_c, SRL_c, SRA_c, JAL, LINK, JR: STD_LOGIC;
	SIGNAL SB: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN
	
	R_TYPE <= '1' WHEN Opcode = "000000" ELSE '0';
	LW <= '1' WHEN Opcode = "100011" ELSE '0';
	SW <= '1' WHEN Opcode = "101011" ELSE '0';
	BEQ <= '1' WHEN Opcode = "000100" ELSE '0';
	BNE <= '1' WHEN Opcode = "000101" ELSE '0';
	J <= '1' WHEN Opcode = "000010" ELSE '0';
	ADDI <= '1' WHEN Opcode ="001000" ELSE '0';
	JAL <= '1' WHEN Opcode = "000011" ELSE '0';
	LINK <= R_TYPE OR JAL;
	JAL_addr_ctrl<= '1' WHEN JAL = '1' ELSE '0';
	JAL_data_ctrl<= "00" WHEN LINK = '1' ELSE	--jalr or jal
					"01" WHEN Opcode = "001111" ELSE	--lui
					"10" WHEN LW = '1';	--lw
	
	JR<= '1' WHEN Opcode = "001000" ELSE '0';
	
	SB <= 
		"00" WHEN Opcode = "101000" ELSE
		"01" WHEN Opcode = "101001" ELSE
		"11" WHEN Opcode = "101011" ELSE
		"00";
 


	Branch <= BEQ;
	Branch_NE <= BNE;
	MUX_MemToReg <= LW;
	ALUSrc <= LW OR SW OR ADDI OR SLL_c OR SRA_c OR SRL_c;
	RegDst <= R_TYPE;
	MemRead <= LW;
	MemWrite <= SW;
	RegWrite <= (R_TYPE OR LW OR ADDI) XOR JR;
	Jump <= J;
	Load <= 
			"001" WHEN Opcode = "100100" ELSE	--lbu
			"010" WHEN Opcode = "100001" ELSE	--lh
			"011" WHEN Opcode = "100101" ELSE	--lhu
			"100" WHEN Opcode = "100011" ELSE	--lw
			"101" WHEN Opcode = "100000" ELSE	--lb
			"000";
	JR_out <= JR;
	SB_out <= SB;
	
	process(Opcode)
	begin
		if(Opcode="000000") then	--R_type
			ALUOp <= Func;
			if(Func="000000") then
				SLL_c <= '1';
				SRL_c <= '0';
				SRA_c <= '0';
			elsif(Func="000010") then
				SRL_c <= '1';
				SLL_c <= '0';
				SRA_c <= '0';
			elsif(Func="000011") then
				SRA_c <= '1';
				SLL_c <= '0';
				SRL_c <= '0';
			else
				SLL_c <= '0';
				SRL_c <= '0';
				SRA_c <= '0';
			end if;
		elsif(Opcode="001000") then --addi
			ALUOp <="100000";
		elsif(Opcode="001001") then	--addiu
			ALUOp <="100001";
		elsif(Opcode="001100") then	--andi
			ALUOp <="100100";
		elsif(Opcode="001101") then	--ori
			ALUOp <="100101";
		elsif(Opcode="001110") then	--xori
			ALUOp <="100110";
		elsif(Opcode="001010") then	--slti
			ALUOp <="101010";
		elsif(Opcode="001011") then	--sltiu
			ALUOp <="101011";
		elsif(Opcode="001111") then	--lui
			ALUOp <="001111";
		elsif(Opcode="000100") then	--beq
			ALUOp <="110010";
		elsif(Opcode="100011") then --lw
			ALUOp <="100001";
		elsif(Opcode="101011") then --sw
			ALUOp <="100001";
		end if;
	end process;	
END arch_ControlUnit;	