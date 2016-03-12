library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY processor IS
	PORT (
		ref_clk 	: IN std_logic;
		reset 		: IN std_logic
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
            Branch_out      : OUT std_logic;
            Jump_out        : OUT std_logic
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

signal we_1, Branch_out_1, Jump_out_1, MemRead_1, MemWrite_1, MTM_1, Branch_1, ALUSrc_1, RegDst_1, RegWrite_1:std_LOGIC;
signal addr_1, dataIO_1, O_out_1,rdata_1_1, rdata_2_1,  dataO_1, PC_Output,Mult1_Output , Mult2_Output:std_logic_vector (31 DOWNTO 0);  
signal ALUOp_1: std_logic_vector (5 DOWNTO 0);
signal Mult3_Output: std_logic_vector (4 DOWNTO 0);

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
		RegWrite=>RegWrite_1
		);  
	--Program Counter	
	PC: program_counter port map
		(
		reset=>reset, 
		clk=>ref_clk, 
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
		wdata=>Mult2_Output
		); 
	--ALU
	ALU_1: alu port map
		(
		Func_in=>ALUOp_1,
		A_in=>rdata_1_1, 
		B_in=>Mult1_Output, 
		O_out=>O_out_1, 
		Branch_out=>Branch_out_1, 
		Jump_out=>Jump_out_1
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
		sel=>ALUSrc_1);
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
		
end pcArch;
