library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY alu IS
	PORT (
		Func_in 	: IN std_logic_vector (5 DOWNTO 0);
		A_in 		: IN std_logic_vector (31 DOWNTO 0);
		B_in 		: IN std_logic_vector (31 DOWNTO 0);
		O_out 		: OUT std_logic_vector (31 DOWNTO 0);
		Branch_out 	: OUT std_logic
	);
END alu;

ARCHITECTURE arch_alu OF alu IS
	signal temp: std_logic_vector(32 downto 0);
	signal A_in_s : signed(A_in'length downto 0);
	signal B_in_s : signed(B_in'length downto 0);

begin
	process(A_in, B_in, Func_in) is
	begin
		case Func_in(5 downto 0) is
			-- Arithmetic/Logic
			when "100000"	=>	--add
				O_out 	<= std_logic_vector((signed(A_in) + signed(B_in)));
				Branch_out	<= '0';
			when "100010"	=>	--sub
				O_out 	<= std_logic_vector(signed(A_in) - signed(B_in));
				Branch_out	<= '0';
			when "100100"	=>	--and
				O_out	<= A_in AND B_in;
				Branch_out	<= '0';
			when "100101"	=>	--or
				O_out	<= A_in OR B_in;
				Branch_out	<= '0';
			when "100110"	=>	--xor
				O_out	<= A_in XOR B_in;
				Branch_out	<= '0';
			when "100111"	=>	--nor
				O_out	<= A_in NOR B_in;
				Branch_out	<= '0';
			when "101010"	=>	--slt
				if to_integer(signed(A_in)) < to_integer(signed(B_in)) then
					O_out	<= (others=>'0');
					O_out(0)<= '1';
				else
					O_out	<= (others=>'0');
				end if;
				Branch_out	<= '0';
			
			-- Branching
			when "110010"	=>	--beq
				if to_integer(signed(A_in)) = to_integer(signed(B_in)) then
					Branch_out <= '1';
				else
					Branch_out <= '0';
				end if;
				O_out	<=	A_in;

			-- Others
			when others =>
				O_out	<= (others => '0');
				Branch_out	<= '0';
			
		end case;	

	end process;
	
end arch_alu;