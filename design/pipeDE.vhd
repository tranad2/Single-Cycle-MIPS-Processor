LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipeDE IS
	PORT (
		--INPUTS
		--clock
		clk: IN STD_LOGIC;
		--hazard unit
		FlushE: IN STD_LOGIC;
		--register file
		rdata_1_in: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		rdata_2_in: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		--pipeFD
		RsD: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RtD: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RdD: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		SignImmD: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		--control
		RegWriteD: IN STD_LOGIC;
		MemtoRegD: IN STD_LOGIC;
		MemWriteD: IN STD_LOGIC;
		ALUControlD: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		ALUSrcD: IN STD_LOGIC;
		RegDstD: IN STD_LOGIC;
		--OUTPUTS
		rdata_1_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		rdata_2_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RsE: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		RtE: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		RdE: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		SignImmE: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegWriteE: OUT STD_LOGIC;
		MemtoRegE: OUT STD_LOGIC;
		MemWriteE: OUT STD_LOGIC;
		ALUControlE: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		ALUSrcE: OUT STD_LOGIC;
		RegDstE: OUT STD_LOGIC
	);
END pipeDE;

ARCHITECTURE arch_pipe of pipeDE IS
	SIGNAL rdata_1_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
	SIGNAL rdata_2_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
	SIGNAL Rs_temp: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others=>'0');
	SIGNAL Rt_temp: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others=>'0');
	SIGNAL Rd_temp: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others=>'0');
	SIGNAL SignImm_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
	SIGNAL RegWrite_temp: STD_LOGIC := '0';
	SIGNAL MemtoReg_temp: STD_LOGIC := '0';
	SIGNAL MemWrite_temp: STD_LOGIC := '0';
	SIGNAL ALUControl_temp: STD_LOGIC_VECTOR(5 DOWNTO 0) := (others=>'0');
	SIGNAL ALUSrc_temp: STD_LOGIC := '0';
	SIGNAL RegDst_temp: STD_LOGIC := '0';

BEGIN
	PROCESS(clk, FlushE)
	BEGIN
		IF FlushE = '0' THEN
			rdata_1_out <= rdata_1_temp;
			rdata_2_out <= rdata_2_temp;
			RsE <= Rs_temp;
			RtE <= Rt_temp;
			RdE <= Rd_temp;
			SignImmE <= SignImm_temp;
			RegWriteE <= RegWrite_temp;
			MemtoRegE <= MemtoReg_temp;
			MemWriteE <= MemWrite_temp;
			ALUControlE <= ALUControl_temp;
			ALUSrcE <= ALUSrc_temp;
			RegDstE <= RegDst_temp;
		END IF;
		IF clk'EVENT AND clk = '1' AND FlushE = '0' THEN
			rdata_1_temp <= rdata_1_in;
			rdata_2_temp <= rdata_2_in;
			Rs_temp <= RsD;
			Rt_temp <= RtD;
			Rd_temp <= RdD;
			SignImm_temp <= SignImmD;
			RegWrite_temp <= RegWriteD;
			MemtoReg_temp <= MemtoRegD;
			MemWrite_temp <= MemWriteD;
			ALUControl_temp <= ALUControlD;
			ALUSrc_temp <= ALUSrcD;
			RegDst_temp <= RegDstD;
		ELSIF FlushE = '1' THEN
			rdata_1_out <= (others=>'0');
			rdata_2_out <= (others=>'0');
			RsE <= (others=>'0');
			RtE <= (others=>'0');
			RdE <= (others=>'0');
			SignImmE <= (others=>'0');
			RegWriteE <= '0';
			MemtoRegE <= '0';
			MemWriteE <= '0';
			ALUControlE <= (others=>'0');
			ALUSrcE <= '0';
			RegDstE <= '0';
		END IF;
	END PROCESS;
END arch_pipe;