LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity hazard_unit is

	port(
		--Logic Inputs

		Branch: 		in std_logic;
		MemToRegE:		in std_logic;
		MemToRegM:		in std_logic;
		
		
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
end hazard_unit;

architecture behavior of hazard_unit is
begin
	process(Branch, MemToRegE, MemToRegM, RsD, RtD, RtE, RsE, RegWriteW, RegWriteM, RegWriteE, WriteRegE, WriteRegM)
	begin
		--Execution Hazard
		if((RsE = "00001") and (RegWriteM /= '0') and (RsE = WriteRegM)) then
			forwardAE <= "10";
		elsif((RtE = "00001") and (RegWriteM /= '0') and (RtE = WriteRegM)) then
			forwardBE <= "10";	
			
		--Memory Hazard
		elsif((RsE = "00001") and (RegWriteW /= '0') and (RsE = WriteRegM)) then
			forwardAE <= "01";
		elsif((RtE = "00001") and (RegWriteW /= '0') and (RtE = WriteRegM)) then
			forwardBE <= "01";
		
		--Stall hazard for LW instruction
		elsif(MemToRegE = '1') and ((RsD = RtE) or (RtD = RtE)) then
			stallIF <= '1';
			stallID <= '1';
			flushE 	<= '1';
		--Stall hazard for branch instruction
		elsif(Branch = '1') then
			if((RegWriteE = '1') and ((WriteRegE = RsD) or (WriteRegE = RtD))) then
				stallIF <= '1';
				stallID <= '1';
				flushE 	<= '1';
			elsif((MemToRegM = '1') and ((WriteRegM = RsD) or (WriteRegM = RtD)))then
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