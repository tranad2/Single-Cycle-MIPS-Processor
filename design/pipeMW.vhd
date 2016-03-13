LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipeMW IS
	PORT (
		clk: IN STD_LOGIC;
		--Control--
		RegWriteM: IN STD_LOGIC;
		MemtoRegM: IN STD_LOGIC;
		WriteRegM: IN STD_LOGIC;
		--Data
		ReadDataM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUInM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		--Outputs--
		RegWriteW: OUT STD_LOGIC;
		MemtoRegW: OUT STD_LOGIC;
		WriteRegW: OUT STD_LOGIC;
		ReadDataW: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUOutW: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END pipeMW;

ARCHITECTURE arch_pipe of pipeMW IS
SIGNAL ReadData_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
SIGNAL ALU_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
SIGNAL RegWrite_temp: STD_LOGIC := 0;
SIGNAL MemtoReg_temp: STD_LOGIC := 0;
SIGNAL WriteReg_temp: STD_LOGIC := 0;
BEGIN
	PROCESS(clk)
	BEGIN
		--Read stored value--
		ReadDataW <= ReadData_temp;
		ALUOutW <= ALU_temp;
		RegWriteW <= RegWrite_temp;
		MemtoRegW <= MemtoReg_temp;
		WriteRegW <= WriteReg_temp;
		
		--Store value--
		IF clk'EVENT AND clk = '1' THEN
			ReadData_temp <= WriteDataM;
			ALU_temp <= ALUInM;
			RegWrite_temp <= RegWriteM;
			MemtoReg_temp <= MemtoRegM;
			WriteReg_temp <= WriteRegM;
		END IF;
	END PROCESS;
END arch_pipe;