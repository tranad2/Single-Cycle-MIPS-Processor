LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY rom IS
	port (
		addr 		: IN std_logic_vector (31 DOWNTO 0);
		dataIO 		: INOUT std_logic_vector (31 DOWNTO 0)
	);
END rom ;


ARCHITECTURE arch_rom OF rom IS

TYPE rom_array IS ARRAY (511 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
CONSTANT rom: rom_array :=(
	--Instruction List, 32 bit
    0 => "00000000001000100001100000100000", -- R3 = R1 + R2
    1 => "00000000001000100001100000100001", -- R3 = R1 - R2
    2 => "00000000001000100001100000100100", -- R3 = R1 AND R2
    3 => "00000000001000100001100000100101", -- R3 = R1 OR R2
	4 => "00000000001000100001100000100110", -- R3 = R1 XOR R2
	5 => "00000000001000100001100000100111", -- R3 = R1 NOR R2
	6 => "00000000001000100001100000101001", -- Unsigned SLT R1 R2 R3
	7 => "10101100001000100000000000010100", -- SW R2 20(R1)
	8 => "10001100001000100000000000010100", -- LW R2 20(R1)
	OTHERS => "00000000000000000000000000000000"
); 

BEGIN

	PROCESS(addr)
	BEGIN
	
		dataIO <= rom(to_integer(unsigned(addr(31 DOWNTO 0))));
	
	END PROCESS;
END arch_rom;