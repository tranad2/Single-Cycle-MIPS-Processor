library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY processor IS
	PORT (
		ref_clk 	: IN std_logic;
		reset 		: IN std_logic := '0'
	);
END processor;

architecture pcArch of processor is 

component rom 
	PORT(
			addr            : IN std_logic_vector (31 DOWNTO 0);
			dataIO          : INOUT std_logic_vector (31 DOWNTO 0)
	);
end component rom;

component alu
	PORT (
            Func_in         : IN std_logic_vector (5 DOWNTO 0);
            A_in            : IN std_logic_vector (31 DOWNTO 0);
            B_in            : IN std_logic_vector (31 DOWNTO 0);
            O_out           : OUT std_logic_vector (31 DOWNTO 0);
            Branch_out      : OUT std_logic
        );
end component alu; 

component regfile
	GENERIC (	NBIT : INTEGER := 32;
                NSEL : INTEGER := 5
            );

	PORT(
			clk             : IN std_logic ;
            rst_s           : IN std_logic ; -- synchronous reset
            we              : IN std_logic ; -- write enable
            raddr_1         : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 1
            raddr_2         : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 2
            waddr           : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- write address
            rdata_1         : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 1
            rdata_2         : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 2
            wdata           : IN std_logic_vector ( NBIT -1 DOWNTO 0) -- write data 1
	); 
end component regfile;

component ram
	PORT(
			clk : IN std_logic;                             --Clock
            we : IN std_logic;                              --Write Enable
            addr : IN std_logic_vector (31 DOWNTO 0);       --Address
            dataI : IN std_logic_vector (31 DOWNTO 0);      --Data Input
            dataO : OUT std_logic_vector (31 DOWNTO 0)      --Data Output
	);
end component ram;

component program_counter
	PORT(
		reset: IN STD_LOGIC;
		clk: IN STD_LOGIC;
		stallF: IN STD_LOGIC;
		o: OUT STD_LOGIC_VECTOR
	);
end component program_counter;

component multiplexer_32
	PORT(
		in0: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		in1: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Output: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		sel: IN STD_LOGIC
	);
end component multiplexer_32;

component multiplexer_5
	PORT(
		in0: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		in1: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Output: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		sel: IN STD_LOGIC
	);
end component multiplexer_5;

component mux_3to1 IS
	PORT(
	in0: IN STD_LOGIC_VECTOR(31 downto 0);
	in1: IN STD_LOGIC_VECTOR(31 downto 0);
	in2: IN STD_LOGIC_VECTOR(31 downto 0);
	Output: OUT STD_LOGIC_VECTOR(31 downto 0);
	sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
end component mux_3to1;



component ControlUnit
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
end component;

component sign_extender 
	PORT(
		input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

component pipeFD 
	PORT (
		clk: IN STD_LOGIC;
		stallD: IN STD_LOGIC;
		dataIO_in: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataIO_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;
component pipeDE 
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
		ALUSrcD: IN	 STD_LOGIC;
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
end component;

component pipeEM 
	PORT (
		clk: IN STD_LOGIC;
		RegWriteE: IN STD_LOGIC;
		MemtoRegE: IN STD_LOGIC;
		WriteRegE: IN STD_LOGIC_VECTOR(4 DOwnto 0);
		MemWriteE: IN STD_LOGIC;
		WriteDataE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUInE: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegWriteM: OUT STD_LOGIC;
		MemtoRegM: OUT STD_LOGIC;
		WriteRegM: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		MemWriteM: OUT STD_LOGIC;
		WriteDataM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUOutM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END component;


component pipeMW 
	PORT (
		clk: IN STD_LOGIC;
		RegWriteM: IN STD_LOGIC;
		MemtoRegM: IN STD_LOGIC;
		WriteRegM: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		ReadDataM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUInM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegWriteW: OUT STD_LOGIC;
		MemtoRegW: OUT STD_LOGIC;
		WriteRegW: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		ReadDataW: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALUOutW: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

component hazard_unit
	port(
		--Logic Inputs
		Branch: 		in std_logic;							--Branch control
		MemToRegE: 		in std_logic;							--Asserted for lw instruction
		MemToRegM:		in std_logic;							--Asserted for branch instruction
		RsD:			in std_logic_vector(4 downto 0);
		RtD:			in std_logic_vector(4 downto 0);
		RtE:			in std_logic_vector(4 downto 0);
		RsE:			in std_logic_vector(4 downto 0);
		RegWriteW: 		in std_logic;
		RegWriteM:		in std_logic;
		RegWriteE:		in std_logic;
		WriteRegM:		in std_logic_vector(4 downto 0);
		WriteRegE:		in std_logic_vector(4 downto 0);
		
			
		--Logic Outputs
		forwardAE: 		out std_logic_vector(1 DOWNTO 0)	:= "00";
		forwardBE: 		out std_logic_vector(1 DOWNTO 0)	:= "00";
		stallIF: 		out std_logic						:= '0';
		stallID: 		out std_logic						:= '0';
		flushE: 		out std_logic						:= '0'
	);
end component;

signal Branch_out_1, MemRead_1, MemWrite_1, MTM_1, Branch_1, ALUSrc_1, RegDst_1, RegWrite_1:std_LOGIC;
signal dataIO_1, O_out_1,rdata_1_1, rdata_2_1,  dataO_1, PC_Output,Mult1_Output , Mult2_Output, SignImmD_O:std_logic_vector (31 DOWNTO 0);  
signal ALUOp_1: std_logic_vector (5 DOWNTO 0);
signal Mult3_Output, WriteRegE_O: std_logic_vector (4 DOWNTO 0);
--PIPEFD SIGNAL
signal dataIO_OUT, ResultW, SrcAE_O,SrcBE_O, BOT_OUT:std_logic_vector(31 DOWNTO 0);

--PIPEDE SIGNALS
signal rdata_1_out_1, rdata_2_out_1, SignImmE_O: STD_LOGIC_VECTOR(31 DOWNTO 0); 
signal ALUControlE_O: STD_LOGIC_VECTOR(5 DOWNTO 0);
signal RsE_O, RtE_O, RdE_O,WriteRegM_O:STD_LOGIC_VECTOR(4 DOWNTO 0); 
signal  MemtoRegE_O, MemWriteE_O, ALUSrcE_O, RegDstE_O,RegWriteE_O:std_logic; --PIPEEM SIGNALS
signal RegWriteM_O,MemtoRegM_O, MemWriteM_O:std_logic;
signal WriteDataM_O, ALUOutM_O:std_logic_vector(31 DOWNTO 0);

--PIPEMW SIGNALS
signal RegWriteW_O, MemtoRegW_O: std_logic;
signal WriteRegW_O: std_logic_vector(4 DOWNTO 0);
signal ReadDataW_O, ALUOutW_O:std_logic_vector(31 DOWNTO 0);

--DATA HAZARD
signal forwardAE_O, forwardBE_O:std_logic_vector(1 DOWNTO 0);
signal stallIF_O, stallID_O, flushE_O: std_logic;
	
signal temp3, temp6, temp2, mult5_Output, mult4_Output: std_logic_vector(31 DOWNTO 0);

begin

	--Control Unit	
	Control: ControlUnit port map
		(
		Opcode=>dataIO_1(31 DOWNTO 26), 
		Func=> dataIO_1(5 DOWNTO 0), 
		ALUOp=>ALUOp_1, 
		MemRead=>MemRead_1, 
		MUX_MemToReg=>MTM_1, 
		Branch=>Branch_1, 
		ALUSrc=>ALUSrc_1, 
		RegDst=>RegDst_1,
	    RegWrite=>RegWrite_1,
		MemWrite=>MemWrite_1
		);  
	--Program Counter	
	PC: program_counter port map
		(
		reset=>reset, clk=>ref_clk, 
		stallf=> stallIF_O,
		o=>PC_Output
		);
	--ROM
	ROM_1: rom port map
		(
		addr=>PC_Output, 
		dataIO=>dataIO_1
		);
	--REG FILE
	REG: regfile port map
		(
		clk=>ref_clk, 
		rst_s=>reset, 
		we=>RegWrite_1,
		raddr_1=>dataIO_1(25 DOWNTO 21), 
		raddr_2=>dataIO_1(20 DOWNTO 16), 
		waddr=>Mult3_Output, 
		rdata_1=>rdata_1_1, 
		rdata_2=>rdata_2_1, 
		wdata=>ResultW
		); 
	--ALU
	ALU_1: alu port map
		(
		Func_in=>ALUOp_1,
		A_in=>SrcAE_O, 
		B_in=>SrcBE_O, 
		O_out=>O_out_1, 
		Branch_out=>Branch_out_1
		);
	--RAM
	RAM_1: ram port map
		(
		clk=>ref_clk, 
		we=>MemRead_1, 
		addr=>O_out_1,
		dataI=>rdata_2_1, 
		dataO=>dataO_1
		);  
	--MULTIPLEXER 1 for REG->ALU
	MULT: multiplexer_32 port map
		(
		in0=>rdata_2_1, 
		in1=> dataIO_1, 
		Output=>Mult1_Output, 
		sel=>ALUSrc_1
		);
	--MULTIPLEXER 2 for RAM->RegFile
	MULT2: multiplexer_32 port map
		(
		in0=>dataO_1, 
		in1=>O_out_1, 
		Output=>Mult2_Output, 
		sel=>MTM_1
		);
		--Multiplexer 3 for ALU->ROM
	Mult3: multiplexer_5 port map
		(
		in0=>dataIO_1(20 DOWNTO 16),
		in1=> dataIO_1(15 DOWNTO 11),
		Output=>Mult3_Output,
		sel=>RegDst_1
		);
	
	FD: pipeFD port map
		(
		clk=>ref_clk,
		stallD=>stallID_O,
		dataIO_in=>dataIO_1,
		dataIO_out=>dataIO_Out
		);

	SE: sign_extender port map
	(
		input=> DataIO_1(15 DOWNTO 0), 
		output=> SignImmD_O 
	);

	DE: pipeDE port map
		(
		--INPUTS
		--clock
		clk=>ref_clk,
		--hazard unit
		FlushE=>FlushE_O ,
		--register file
		rdata_1_in=>rdata_1_1,
		rdata_2_in=>rdata_2_1,
		--pipeFD
		RsD=>DataIO_1(25 DOWNTO 21),
		RtD=>DataIO_1(20 DOWNTO 16),
		RdD=>DataIO_1(15 DOWNTO 11),
		SignImmD=>SignImmD_O ,
		--control
		RegWriteD=>RegWrite_1,
		MemtoRegD=>MTM_1,
		MemWriteD=> MemWrite_1,
		ALUControlD=>ALUOp_1,
		ALUSrcD=>ALUSrc_1,
		RegDstD=>RegDst_1,

		--OUTPUTS
		rdata_1_out=>rdata_1_out_1,
		rdata_2_out=>rdata_2_out_1,
		RsE=>RsE_O,
		RtE=> RtE_O,
		RdE=> RdE_O,
		SignImmE=>SignImmE_O,
		RegWriteE=>RegWriteE_O,
		MemtoRegE=>MemtoRegE_O,
		MemWriteE=>MemWriteE_O,
		ALUControlE=>ALUControlE_O,
		ALUSrcE=> ALUSrcE_O,
		RegDstE=> RegDstE_O
	);

	--SrcAE
	TOP_3_MUX: mux_3to1 port map
		(
		in0=>rdata_1_out_1,
		in1=>ResultW,
		in2=>ALUOutM_O,
		Output=>SrcAE_O,
		sel=>forwardAE_O
		);

	BOT_3_MUX: mux_3to1 port map 
		(
		in0=> rdata_2_out_1,
		in1=>ResultW,
		in2=>ALUOutM_O,
		Output=> BOT_OUT, 
		sel=>forwardBE_O
		);
	BOT_MUX: multiplexer_32 port map
	(
		in0=> BOT_OUT,
		in1=> SignImmE_O,
		Output=> SrcBE_O,
		sel=>ALUSrcE_O
	);

	Mult_5: multiplexer_5 port map
	(
		in0=>RtE_O,
		in1=>RdE_O,
		Output=>WriteRegE_O,
		sel=> RegDstE_O
	);


	EM: pipeEM port map
		(
		clk=>ref_clk,
		RegWriteE=>RegWriteE_O,
		MemtoRegE=>MemtoRegE_O,
		MemWriteE=>MemWriteE_O,
		WriteRegE=>WriteRegE_O, 
		WriteDataE=> BOT_OUT, 
		ALUInE=> O_out_1,
		RegWriteM=>RegWriteM_O,
		MemtoRegM=>MemToRegM_O,
		WriteRegM=>WriteRegM_O,
		MemWriteM=>MemWriteM_O,
		WriteDataM=>WriteDataM_O,
		ALUOutM=>ALUOutM_O
		);

	
MW: pipeMW port map
		(
		clk=>ref_clk,
		RegWriteM=>RegWriteM_O,
		MemtoRegM=>MemToRegM_O,
		WriteRegM=>WriteRegM_O,
		ReadDataM=>dataO_1,
		ALUInM=>ALUOutM_O,
		RegWriteW=>RegWriteW_O,
		MemtoRegW=>MemtoRegW_O,
		WriteRegW=>WriteRegW_O,
		ReadDataW=>ReadDataW_O,
		ALUOutW=>ALUOutW_O 
		);

	PIPE_MW_MULT: multiplexer_32 port map
		(
		in0=>ReadDataW_O, 
		in1=>ALUOutW_O, 
		Output=>ResultW, 
		sel=>MemtoRegW_O
		);

	HazardUnit: hazard_unit port map
		(
		--Logic Inputs
		Branch=>Branch_1,
		MemToRegE=>MemToRegE_O,
		MemToRegM=>MemToRegM_O,

		RsD=>DataIO_1(25 DOWNTO 21),
		RtD=>DATAIO_1(20 DOWNTO 16),
		RtE=>RtE_O,
		RsE=>RsE_O,
		RegWriteW=>RegWriteW_O,
		RegWriteM=>RegWriteM_O,
		RegWriteE=>RegWriteE_O,
		WriteRegM=>WriteRegM_O,
		WriteRegE=>WriteRegE_O,
		
		
		--Logic Outputs
		forwardAE=>forwardAE_O,
		forwardBE=> forwardBE_O,
		stallIF=>stallIF_O,
		stallID=>stallID_O,
		flushE=>flushE_O
		);
		

	--ALU for ADD
	temp3 <= SE_OUTPUT(29 DOWNTO 0)&"00";
	ALU_2: alu port map
		(
		Func_in=>"100000",
		A_in=>temp6,
		B_in=>temp3,
		O_out=>O_Out_2,
		Branch_Out=> FF_2b_o_br  
		);
	
	temp6<= std_logic_vector(unsigned(PC_OUTPUT)+1);
-- Multiplexer 4 for Add and AND gate
	Mult4: multiplexer_32 port map
		(
		in0=>temp6,
		in1=>O_out_2,
		Output=>Mult4_Output,
		sel=> add_out_1
		);
	--Multiplexer 5 for Multiplexer and ROM_OUTPUT 
	temp2<= PC_Output(31 DOWNTO 28)&(DataIO_1(25 DOWNTO 0)&"00");
	Mult5: multiplexer_32 port map
		(
		in0=>temp2,
		in1=>Mult4_Output,
		Output=>Mult5_Output,
		sel=>jump_out_1
		);


end pcArch;
