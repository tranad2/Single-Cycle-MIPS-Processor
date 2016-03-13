LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_3to1 IS
PORT(
	in0: IN STD_LOGIC_VECTOR(31 downto 0);
	in1: IN STD_LOGIC_VECTOR(31 downto 0);
	in2: IN STD_LOGIC_VECTOR(31 downto 0);
	Output: OUT STD_LOGIC_VECTOR(31 downto 0);
	sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END mux_3to1;

ARCHITECTURE arch_multiplexer OF mux_3to1 IS
BEGIN
	Output<=in0 when sel = "00" else
			in1 when sel = "01" else
			in2 when sel = "10";
			
END arch_multiplexer; 
