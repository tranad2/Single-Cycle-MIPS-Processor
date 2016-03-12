LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY multiplexer_32 IS
PORT(
	in0: IN STD_LOGIC_VECTOR(31 downto 0);
	in1: IN STD_LOGIC_VECTOR(31 downto 0);
	Output: OUT STD_LOGIC_VECTOR(31 downto 0);
	sel: IN STD_LOGIC);
END multiplexer_32;

ARCHITECTURE arch_multiplexer OF multiplexer_32 IS
BEGIN
	Output<=in0 when sel = '0' else
			in1 when sel = '1';
END arch_multiplexer; 