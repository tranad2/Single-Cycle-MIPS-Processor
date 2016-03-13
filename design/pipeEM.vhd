LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipeEM IS
	PORT (
		clk: IN STD_LOGIC;
		--Control--
		RegWriteE: IN STD_LOGIC;
		MemtoRegE: IN STD_LOGIC;
		WriteRegE: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		MemWriteE: IN STD_LOGIC;
		--Data--
		WriteDataE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUInE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		--Outputs--
		RegWriteM: OUT STD_LOGIC;
		MemtoRegM: OUT STD_LOGIC;
		WriteRegM: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		MemWriteM: OUT STD_LOGIC;
		WriteDataM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUOutM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END pipeEM;

ARCHITECTURE arch_pipe of pipeEM IS
SIGNAL WriteData_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
SIGNAL ALU_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
SIGNAL RegWrite_temp: STD_LOGIC := '0';
SIGNAL MemtoReg_temp: STD_LOGIC := '0';
SIGNAL WriteReg_temp: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others=>'0');
SIGNAL MemWrite_temp: STD_LOGIC := '0';
BEGIN
	PROCESS(clk)
	BEGIN
		--Read stored value--
		WriteDataM <= WriteData_temp;
		ALUOutM <= ALU_temp;
		RegWriteM <= RegWrite_temp;
		MemtoRegM <= MemtoReg_temp;
		WriteRegM <= WriteReg_temp;
		MemWriteM <= MemWrite_temp;
		
		--Store value--
		IF clk'EVENT AND clk = '1' THEN
			WriteData_temp <= WriteDataE;
			ALU_temp <= ALUInE;
			RegWrite_temp <= RegWriteE;
			MemtoReg_temp <= MemtoRegE;
			WriteReg_temp <= WriteRegE;
			MemWrite_temp <= MemWriteE;
		END IF;
	END PROCESS;
END arch_pipe;