library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is port(
    frame_clk : in std_logic;
	clk : in std_logic;
	row_idx : in unsigned(9 downto 0); -- max 479
	col_idx : in unsigned(9 downto 0); -- max 639
	
	  tank_x1 : in unsigned(9 downto 0):= 10d"400";
	  tank_y1 : in unsigned(9 downto 0):= 10d"100";
      ball_x1 : in unsigned(9 downto 0) ; -- row
      ball_y1 : in unsigned(9 downto 0) ; -- col
	  
	  tank_x2 : in unsigned(9 downto 0):= 10d"400";
	  tank_y2 : in unsigned(9 downto 0):= 10d"600";
      ball_x2 : in unsigned(9 downto 0) ; -- row
      ball_y2 : in unsigned(9 downto 0) ; -- col
	  
	hit : out std_logic;
	
	
	valid_input: in std_logic;
	rgb : out std_logic_vector(5 downto 0);
	start_screen : in std_logic ;
	playing_screen : in std_logic 
);
end entity pattern_gen;




architecture synth of pattern_gen is


component start_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(5 downto 0);
	  yadr : in unsigned(6 downto 0); -- 0-1023
	  to_screen : out std_logic_vector(5 downto 0)
      );
end component;

signal start_pixels: std_logic_vector(5 downto 0);

signal row_idx_rom : unsigned(5 downto 0);
signal col_idx_rom : unsigned(6 downto 0);


begin


row_idx_rom <= row_idx(9 downto 4);
col_idx_rom <= col_idx(9 downto 3);
   
start_screen_map : start_rom port map(
					 clk => clk,
					 xadr => row_idx_rom, -- col / 8,
					 yadr => col_idx_rom, --row / 8,
					 to_screen => start_pixels
			 );
   
 
 
		process(valid_input,frame_clk) begin
		
			if valid_input = '1' then
			
			if start_screen = '1' then
			    rgb <= "000000";
			
			
		elsif hit = '1' then
		-- player <= not player;
		 rgb <= "001100" when col_idx > 400;
		 --player <= not player;	
			elsif playing_screen = '1'  then 
				rgb <= "110000" when (row_idx > ball_x1 and row_idx < ball_x1 + 10 and col_idx > ball_y1 and col_idx < ball_y1 + 10) or (row_idx > tank_x1 and row_idx < tank_x1 + 10 and col_idx > tank_y1 and col_idx < tank_y1 +10) or
			                       	(row_idx > ball_x2 and row_idx < ball_x2 + 10 and col_idx > ball_y2 and col_idx < ball_y2 + 10) or (row_idx > tank_x2 and row_idx < tank_x2 + 10 and col_idx > tank_y2 and col_idx < tank_y2 +10);
				--rgb <= "110000" when row_idx > tank_x and row_idx < tank_x + 10 and col_idx > tank_y and col_idx < tank_y +10 ;

				       
			else
			    rgb <= "000011";
			end if;
			
		

end if;




end process;

hit <= '1' when ball_y1 = tank_y2 and ball_x1 = tank_x2 else       '1' when ball_y2 = tank_y1 and ball_x2 = tank_x1 else '0';

--hit <= '0' ;

end architecture synth;


