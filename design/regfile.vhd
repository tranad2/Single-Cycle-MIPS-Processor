LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY regfile IS
	GENERIC ( 	NBIT : INTEGER := 32;
				NSEL : INTEGER := 5
			);
	PORT (
		clk 		: IN std_logic ;
		rst_s 		: IN std_logic ; -- synchronous reset
		we 			: IN std_logic ; -- write enable
		raddr_1 	: IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 1
		raddr_2 	: IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 2
		waddr 		: IN std_logic_vector ( NSEL -1 DOWNTO 0); -- write address
		rdata_1 	: OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 1
		rdata_2 	: OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 2
		wdata 		: IN std_logic_vector ( NBIT -1 DOWNTO 0) -- write data 1
	);
END regfile;

ARCHITECTURE Sequential OF regfile IS
BEGIN
	process(clk)
	type reg_array is array (2**NSEL - 1 DOWNTO 0) of std_logic_vector(NBIT-1 DOWNTO 0);	--define variable array type (8 registers containing 32-bit vectors)
	variable temp : reg_array := (others=>(others=>'0'));									--initialize array of std_logic_vectors
	begin
		if(clk'EVENT and clk='1') then								--at rising edge
			if(rst_s='1') then
				temp(to_integer(unsigned(waddr))):=(others=>'0');	--synchronous reset variable temp				
			end if;
			rdata_1<=temp(to_integer(unsigned(raddr_1)));			--read data 1 at read address 1 in temp at every clock cycle
			rdata_2<=temp(to_integer(unsigned(raddr_2)));			--read data 2 at read address 2 in temp at every clock cycle
		end if;
		if(clk'EVENT and clk='0') then
			if(we = '1') then
				temp(to_integer(unsigned(waddr))):=wdata;				--write wdata into waddr(write address) at falling edge
			end if;
		end if;
	end process;
END Sequential;