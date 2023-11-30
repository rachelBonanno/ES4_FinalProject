
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is port(
	row_idx : in unsigned(9 downto 0); -- max 479
	col_idx : in unsigned(9 downto 0); -- max 639
	valid_input: in std_logic;
	rgb: out std_logic_vector(5 downto 0)
);
end entity pattern_gen;

architecture synth of pattern_gen is

signal ball_x : unsigned(9 downto 0) := "0000000000";
signal ball_y : unsigned(9 downto 0);
signal count : unsigned(14 downto 0) := 15d"0";
signal int
component mypll is
		port(
			ref_clk_i: in std_logic;
			rst_n_i: in std_logic;
			outcore_o: out std_logic;
			outglobal_o: out std_logic
		);
	end component mypll;

begin
		process(valid_input)
		begin
			if valid_input = '1' then
				rgb <= "110000" when row_idx > ball_x and row_idx < ball_x + 10 and col_idx > 300 and col_idx < 310 else "000011";
			else
			    rgb <= "000011";
			end if;
			
			if row_idx = 481 and col_idx = 641 then
				count <= count + 1;
				
			end if;
			


		end process;
ball_x <= ball_x + 1 when count(13) ;

end architecture synth;
