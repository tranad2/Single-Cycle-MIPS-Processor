library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY alu IS
	PORT (
		Func_in 	: IN std_logic_vector (5 DOWNTO 0);
		A_in 		: IN std_logic_vector (31 DOWNTO 0);
		B_in 		: IN std_logic_vector (31 DOWNTO 0);
		O_out 		: OUT std_logic_vector (31 DOWNTO 0);
		Branch_out 	: OUT std_logic;
		Jump_out 	: OUT std_logic
	);
END alu;

ARCHITECTURE arch_alu OF alu IS
	--signal temp: std_logic_vector(32 downto 0);

begin
	process(A_in, B_in, Func_in) is
	begin
		case Func_in(5 downto 4) is
			when "10" =>
				case Func_in(3 downto 0) is
					when "0000" =>	--add
						--temp 	<= std_logic_vector((unsigned("0" & A_in) + unsigned(B_in)));
						O_out 	<= std_logic_vector((unsigned(A_in) + unsigned(B_in)));
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "0010"	=>	--sub
						O_out 	<= std_logic_vector(unsigned(A_in) - unsigned(B_in));
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "0100"	=>	--and
						O_out	<= A_in AND B_in;
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "0101"	=>	--or
						O_out	<= A_in OR B_in;
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "0110"	=>	--xor
						O_out	<= A_in XOR B_in;
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "0111"	=>	--nor
						O_out	<= A_in NOR B_in;
						Branch_out	<= '0';
						Jump_out	<= '0';
					when "1000"	=>	--slt unsigned
						if to_integer(unsigned(A_in)) < to_integer(unsigned(B_in)) then
							O_out	<= (others=>'0');
							O_out(0)<= '1';
						else
							O_out	<= (others=>'0');
						end if;
						Branch_out	<= '0';
						Jump_out	<= '0';
					when others =>
						O_out    	<= (others => '0');
						Branch_out	<= '0';
						Jump_out   	<= '0';
				end case;
			when "11" =>			--branching
				case Func_in(3 downto 0) is
					when "1000"=>	--bltz
						O_out<=A_in;
						if to_integer(signed(A_in)) < 0 then
							Branch_out<='1';
						else
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when "1001"=>	--bgez
						O_out<=A_in;
						if to_integer(signed(A_in)) >= 0 then
							Branch_out<='1';
						else
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when "1010"=>	--jump
						O_out<=A_in;
						Branch_out<='0';
						Jump_out<='1';
					when "1011"=>	--jump
						O_out<=A_in;
						Branch_out<='0';
						Jump_out<='1';
					when "1100"=>	--beq
						O_out<=A_in;
						if to_integer(signed(A_in)) = to_integer(signed(B_in)) then
							Branch_out<='1';
						else
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when "1101"=>	--bne
						O_out<=A_in;
						if to_integer(signed(A_in)) /= to_integer(signed(B_in)) then
							Branch_out<='1';
						else
							O_out<= (others=>'0');
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when "1110"=>	--blez
						O_out<=A_in;
						if to_integer(signed(A_in)) <= 0 then
							Branch_out<='1';
						else
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when "1111"=>	--bgtz
						O_out<=A_in;
						if to_integer(signed(A_in)) > 0 then
							Branch_out<='1';
						else
							Branch_out<='0';
						end if;
						Jump_out<='0';
					when others =>
						O_out	<=	A_in;
						Branch_out	<= '0';
						Jump_out   	<= '0';
				end case;
			when others =>
				O_out    	<= (others => '0');
				Branch_out	<= '0';
				Jump_out   	<= '0';
		end case;
	end process;
	
end arch_alu;