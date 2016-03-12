library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY program_counter IS
	PORT(
		reset: IN STD_LOGIC;
		clk: IN STD_LOGIC;
		stallF: IN STD_LOGIC;
		o: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END program_counter;
	
ARCHITECTURE behaviorial OF Program_Counter IS
	SIGNAL temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
BEGIN

	PROCESS(reset, clk)
	BEGIN
		IF reset = '1' THEN --Resets on reset flag
			o <= "00000000000000000000000000000000";
		ELSIF clk'event and clk = '1' THEN 
			o <= temp;
			temp <= temp + "00000000000000000000000000000001";
		END IF;
	END PROCESS;
END behaviorial;