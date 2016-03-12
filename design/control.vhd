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
		ALUSrc: OUT STD_LOGIC;
		RegDst: OUT STD_LOGIC;
		RegWrite: OUT STD_LOGIC
	
	);
	
END ControlUnit;

ARCHITECTURE arch_ControlUnit OF ControlUnit IS
	SIGNAL R_TYPE, SW, LW: STD_LOGIC;
	
BEGIN
PROCESS(Opcode)
	BEGIN
		CASE Opcode(5 DOWNTO 0) IS
			WHEN "000000" => 
				R_TYPE <= '1';
				LW <= '0';
				SW <= '0';
			WHEN "100011" => 
				R_TYPE <= '0';
				LW <= '1';
				SW <= '0';
			WHEN "101011" => 
				R_TYPE <= '0';
				SW <= '1';
				LW <= '0';
			WHEN OTHERS =>
				R_TYPE <= '0';
				LW <= '0';
				SW <= '0';
			
		END CASE;
	END PROCESS;
	
	Branch <= '1';
	MUX_MemToReg <= LW;
	ALUSrc <= LW OR SW;
	RegDst <= R_TYPE;
	MemRead <= LW;
	MemWrite <= SW;
	RegWrite <= R_TYPE OR LW;
	
	ALUOp <= Func;
	
END arch_ControlUnit;