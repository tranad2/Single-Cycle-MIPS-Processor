LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY processor_tb IS
END processor_tb;

ARCHITECTURE arch_processor_tb OF processor_tb IS

COMPONENT processor IS
	PORT (
		ref_clk 	: IN std_logic;
		reset 		: IN std_logic
	);
END COMPONENT processor;

SIGNAL clk_tb, reset_tb: STD_LOGIC;

BEGIN

	--Port map
	inst: processor PORT MAP(
		ref_clk => clk_tb,
		reset => reset_tb
	);

	clk_process: PROCESS
	BEGIN
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
		clk_tb <= '1';
		WAIT FOR 10 ns;
		clk_tb <= '0';
		WAIT FOR 10 ns;
	
	
	END PROCESS;
	
	

END arch_processor_tb;