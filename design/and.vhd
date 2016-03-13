library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
ENTITY and_gate IS 
	PORT ( IN1 : in STD_LOGIC; -- AND gate input 
	IN2 : in STD_LOGIC; -- AND gate input 
	OUT1 : out STD_LOGIC); -- AND gate output 
END and_gate; 
ARCHITECTURE Behavioral of and_gate IS 
BEGIN 
	OUT1 <= IN1 AND IN2; -- 2 input AND gate 
END Behavioral;
