LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipeFD IS
	PORT (
		clk: IN STD_LOGIC;
		stallD: IN STD_LOGIC;
		dataIO_in: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataIO_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END pipeFD;

ARCHITECTURE arch_pipe of pipeFD IS
	SIGNAL dataIO_temp: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others=>'0');
BEGIN
	PROCESS(clk, stallD)
	BEGIN
		IF stallD = '0' THEN
			dataIO_out <= dataIO_temp;
		ELSIF clk'EVENT AND clk = '1' AND stallD = '0' THEN
			dataIO_temp <= dataIO_in;
		ELSIF stallD = '1' THEN
			dataIO_out <= (others=>'0');
		END IF;
	END PROCESS;
END arch_pipe;