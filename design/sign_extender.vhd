LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sign_extender IS
	PORT(
		input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);

	
END sign_extender;

ARCHITECTURE arch_extender OF sign_extender IS

BEGIN

	output <= STD_LOGIC_VECTOR(resize(signed(input), output'length));

END arch_extender;
