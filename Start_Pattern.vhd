library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is port(
    frame_clk : in std_logic;
	
	row_idx : in unsigned(9 downto 0); -- max 479
	col_idx : in unsigned(9 downto 0); -- max 639
	
	ball_x : in unsigned(9 downto 0); -- Player 1 max 479
	ball_y : in unsigned(9 downto 0); -- Player 1 max 639
	
	valid_input: in std_logic;
	rgb: out std_logic_vector(5 downto 0)
	
);
end entity pattern_gen;

architecture synth of pattern_gen is






begin
		process(valid_input,frame_clk) begin
		
			if valid_input = '1' then
				rgb <= "110000" when row_idx > ball_x and row_idx < ball_x + 10 and col_idx > ball_y and col_idx < ball_y + 10 else 
					    "110000" when row_idx > 395 and row_idx < 405 and col_idx > 565 and col_idx < 575 else
						"110000" when row_idx > 395 and row_idx < 405 and col_idx > 95 and col_idx < 105 else
				        "000011";
			else
			    rgb <= "000011";
			end if;




    

end process;


end architecture synth;

