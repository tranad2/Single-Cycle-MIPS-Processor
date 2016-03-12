LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram IS
	port (
		clk : IN std_logic; 						--Clock
		we : IN std_logic; 							--Write Enable
		addr : IN std_logic_vector (31 DOWNTO 0); 	--Address
		dataI : IN std_logic_vector (31 DOWNTO 0); 	--Data Input
		dataO : OUT std_logic_vector (31 DOWNTO 0) 	--Data Output
	);
END ram;

ARCHITECTURE arch_ram OF ram IS

Type ram_array IS ARRAY (511 DOWNTO 0) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL MATRIX1: ram_array := (OTHERS => (OTHERS => '0'));	--2048x32 or 512wordx32bit
SIGNAL readAddr: STD_LOGIC_VECTOR(31 DOWNTO 0); --Holds the address for read

BEGIN
	PROCESS(clk) 	--Dependent on edges of clock and write enable
		BEGIN
			IF clk'event and clk = '1' THEN
				dataO <= MATRIX1(to_integer((unsigned(readAddr(31 DOWNTO 0))))); --Read data from the ram
			END IF;
			
			IF clk'EVENT and clk = '0' THEN	
				IF(we = '1') THEN
					MATRIX1(to_integer(unsigned(addr(31 DOWNTO 0)))) <= dataI;
				END IF;
			END IF;				
	END PROCESS;	
END arch_ram;