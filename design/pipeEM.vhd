LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipeEM IS
	PORT (
		clk: IN STD_LOGIC;
		RegWriteE: IN STD_LOGIC;
		MemtoRegE: IN STD_LOGIC;
		WriteRegE IN STD_LOGIC;
		MemWriteE IN STD_LOGIC;
		WriteDataE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUInE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegWriteM: OUT STD_LOGIC;
		MemtoRegM: OUT STD_LOGIC;
		WriteRegM: OUT STD_LOGIC;
		MemWriteM: OUT STD_LOGIC;
		WriteDataM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUOutM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END pipeEM;

ARCHITECTURE arch_pipe of pipeEM IS
BEGIN

END arch_pipe;