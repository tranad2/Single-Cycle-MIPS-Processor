LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity hazard_unit is

	port(
		--Logic Inputs
		Branch: 		in std_logic;							--Branch control
		reg_writeM: 	in std_logic;							--EX/MEM.RegWrite
		reg_writeW: 	in std_logic;							--MEM/WB.RegWrite
		reg_writeE:		in std_logic;
		MemToRegE: 		in std_logic;							--Asserted for lw instruction
		MemToRegM:		in std_logic;							--Asserted for branch instruction
		
		RegSourceD:		in std_logic_vector(5 DOWNTO 0);
		RegTargetD: 	in std_logic_vector(5 DOWNTO 0);
		RegSourceE: 	in std_logic_vector(5 DOWNTO 0);		--ID/EX.RegisterRs
		RegTargetE: 	in std_logic_vector(5 DOWNTO 0);		--ID/EX.RegisterRt

		
		RegToM: 		in std_logic_vector(5 DOWNTO 0);		--EX/MEM.RegisterRd
		RegToW: 		in std_logic_vector(5 DOWNTO 0);		--MEM/WB.RegisterRd
		RegToE:			in std_logic_vector(5 DOWNTO 0);
		
		--Logic Outputs
		forwardAE: 		out std_logic_vector(1 DOWNTO 0);
		forwardBE: 		out std_logic_vector(1 DOWNTO 0);
		forwardAD:		out std_logic_vector(1 DOWNTO 0);
		forwardBD:		out std_logic_vector(1 DOWNTO 0);
		stallIF: 		out std_logic;
		stallID: 		out std_logic;
		flushE: 		out std_logic
	);
end hazard_unit;

architecture behavior of hazard_unit is
begin
	process(branch, reg_writeM, reg_writeW, reg_writeE, MemToRegE, MemToRegM)
	begin
		--Execution Hazard
		if((reg_writeM = '1') and (RegToM /= "000000") and (RegToM = RegSourceE)) then
			forwardAE <= "10";
		elsif((reg_writeM = '1') and (RegToM /= "000000") and (RegToM = RegSourceE)) then
			forwardBE <= "10";	
			
		--Memory Hazard
		elsif((reg_writeW = '1') and (RegToW /= "000000") and (RegToW = RegSourceE)) then
			forwardAE <= "01";
		elsif((reg_writeW = '1') and (RegToW /= "000000") and (RegToW = RegTargetE)) then
			forwardBE <= "01";
		
		--Stall hazard for LW instruction
		elsif(MemToRegE = '1') and ((RegSourceD = RegTargetE) or (RegTargetD = RegTargetE)) then
			stallIF <= '1';
			stallID <= '1';
			flushE 	<= '1';
		--Stall hazard for branch instruction
		elsif(Branch = '1') then
			if((reg_writeE = '1') and ((RegToE = RegSourceD) or (RegToE = RegTargetD))) then
				stallIF <= '1';
				stallID <= '1';
				flushE 	<= '1';
			elsif((MemToRegM = '1') and ((RegToM = RegSourceD) or (RegToM = RegTargetD)))then
				stallIF <= '1';
				stallID <= '1';
				flushE 	<= '1';
			end if;
		else
			forwardAE <= "00";
			forwardBE <= "00";
			stallIF <= '0';
			stallID <= '0';
			flushE 	<= '0';		
		end if;
	end process;
end behavior;