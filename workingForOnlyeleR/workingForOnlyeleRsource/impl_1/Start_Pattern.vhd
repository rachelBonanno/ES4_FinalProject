library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is port(
    frame_clk : in std_logic; -- reduntant
	--frame_clk_acc : in std_logic;
	clk : in std_logic;
	row_idx : in unsigned(9 downto 0); -- max 479
	col_idx : in unsigned(9 downto 0); -- max 639
	
	  tank_x1 : in unsigned(9 downto 0):= 10d"400";
	  tank_y1 : in unsigned(9 downto 0):= 10d"100";
      ball_x1 : in unsigned(9 downto 0) ; -- row
      ball_y1 : in unsigned(9 downto 0) ; -- col
	  
	  tank_x2 : in unsigned(9 downto 0):= 10d"400";
	  tank_y2 : in unsigned(9 downto 0) := 10d"600";
      ball_x2 : in unsigned(9 downto 0) ; -- row
      ball_y2 : in unsigned(9 downto 0) := 10d"600" ; -- col
	  
	hit : out std_logic;
	
	R_hit : out std_logic := '0';
	L_hit : out std_logic := '0';
	
	valid_input: in std_logic;
	rgb : out std_logic_vector(5 downto 0);
	start_screen : in std_logic ;
	playing_screen : in std_logic;
	
	Game_overscreen : in std_logic;
	fire: in std_logic
);
end entity pattern_gen;




architecture synth of pattern_gen is



-- Pixels to display for start screen
signal startscreen : std_logic_vector(5 downto 0);

-- Pixels to display for game background
signal background : std_logic_vector(5 downto 0);

-- pixels to outut
signal outputscreen : std_logic_vector(5 downto 0);
-- pixels want to dispaly in game setting
signal gamepixels : std_logic_vector(5 downto 0);

-- game over
signal gop1 : std_logic_vector(5 downto 0);
signal gop2 : std_logic_vector(5 downto 0);
signal gotie : std_logic_vector(5 downto 0);
signal gameover: std_logic_vector(5 downto 0);

-- instructions
signal instruct : std_logic_vector(5 downto 0);


component start_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(6 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component start_rom;

component background_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(7 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component background_rom;

component ele_L_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(7 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component ele_L_rom;

component ele_R_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(7 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component ele_R_rom;

component gameoverp1_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(6 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component gameoverp1_rom;

component gameoverp2_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(6 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component gameoverp2_rom;

component gameovertie_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(6 downto 0);
	  col_idx: in unsigned(5 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component gameovertie_rom;

component instructions_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(8 downto 0);
	  col_idx: in unsigned(7 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
	  );
end component instructions_rom;

signal start_pixels: std_logic_vector(5 downto 0);

signal row_idx_rom : unsigned(5 downto 0);
signal col_idx_rom : unsigned(6 downto 0);
signal ball_signal : std_logic_vector(5 downto 0) := "111111";
signal ball_display : std_logic_vector(5 downto 0);
signal back_display : std_logic := '1';
signal tank_player : std_logic ;
signal ball_player : std_logic ;
signal backgroundsignal : std_logic;
signal elL: std_logic_vector(5 downto 0);
signal elR: std_logic_vector(5 downto 0);
signal elleRow: unsigned(9 downto 0);
signal ellCol: unsigned(9 downto 0);
signal elleRow2: unsigned(9 downto 0);
signal ellCol2: unsigned(9 downto 0);


signal actual_hit_row_1 : unsigned(9 downto 0);
signal actual_hit_col_1 : unsigned(9 downto 0);
signal actual_hit_row_2 : unsigned(9 downto 0);
signal actual_hit_col_2 : std_logic_vector(5 downto 0);
--signal doitnow : std_logic;

begin


row_idx_rom <= row_idx(9 downto 4);
col_idx_rom <= col_idx(9 downto 3);
ellCol <= col_idx - tank_y1;
elleRow <= row_idx - 375;




ellCol2 <= col_idx - tank_y2 - 430;
elleRow2 <= row_idx - 375;
   
	start_rommap: start_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 3)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => startscreen
		
		);

	background_rommap: background_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 2)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => background
		
		);
 
	ele_L_rommap: ele_L_rom port map (
		clk => clk,
		row_idx =>  unsigned(ellCol(9 downto 2)),
		col_idx  =>  unsigned(elleRow(8 downto 3)),
		rgb => elL
		
		);
		
	ele_R_rommap: ele_R_rom port map (
		clk => clk,
		row_idx =>  unsigned(ellCol2(9 downto 2)),
		col_idx  =>  unsigned(elleRow2(8 downto 3)),
		rgb => elR
		
		);

	gameoverp1_rommap: gameoverp1_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 3)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => gop1
		
		);
		
	gameoverp2_rommap: gameoverp2_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 3)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => gop2
		
		);
		
	gameovertie_rommap: gameovertie_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 3)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => gotie
		
		);
		
	instructions_rommap: instructions_rom port map (
		clk => clk,
		row_idx =>  unsigned(col_idx(9 downto 1)),
		col_idx  =>  unsigned(row_idx(8 downto 1)),
		rgb => instruct
		
		);
 
	--process(valid_input) begin

				
		
		--if valid_input = '1' then
			--ball_signal <= elL when (row_idx > ball_x1 and row_idx < ball_x1 + 10 and col_idx > ball_y1 and col_idx < ball_y1 + 10) or (row_idx > ball_x2 and row_idx < ball_x2 + 10 and col_idx > ball_y2 and col_idx < ball_y2 + 10) else elL;
			
			    --rgb <= startscreen ;
		-- elsif hit = '1' then
		-- player <= not player;
		 --rgb <= "001100" when col_idx > 400;
		 --player <= not player;
            --if start_screen = '1' then
           -- rgb <= startscreen;

			    --rgb <= background;
			--rgb <= background; 
					
				--rgb <= "110000" when row_idx > tank_x and row_idx < tank_x + 10 and col_idx > tank_y and col_idx < tank_y +10 ;
	       
			--else
			--    rgb <= startscreen;
			--end if;
			
		

  --end if;




--end process;

--tank_player <= (row_idx > tank_x1 and row_idx < tank_x1 + 10 and col_idx > tank_y1 and col_idx < tank_y1 +10) or (row_idx > tank_x2 and row_idx < tank_x2 + 10 and col_idx > tank_y2 and col_idx < tank_y2 +10);

process(all) begin

if start_screen = '1' then

R_hit <= '0';
L_hit <= '0';
--doitnow <= '0';
else

if (ball_y1 > tank_y2 + 400 and  ball_y1 < tank_y2 + 430) and ( ball_x1 > 370 and ball_x1 <  400 )  then

R_hit <= '1' ;
--doitnow <= '1';
end if;

if (ball_y2 > tank_y1  and  ball_y2 < tank_y1 + 30) and ( ball_x2 > 370 and ball_x2 < 400 ) then

L_hit <= '1' ;
--doitnow <= '1';
else

end if;
end if;




end process;

hit <= '1' when (ball_y1 > tank_y2 + 400 and  ball_y1 < tank_y2 + 430) and ( ball_x1 > 370 and ball_x1 <  400 )  else
       '1' when (ball_y2 > tank_y1  and  ball_y2 < tank_y1 + 30) and ( ball_x2 > 370 and ball_x2 < 400 )  else '0';

--R_hit <= '1' when (ball_y1 > tank_y2 + 400 and  ball_y1 < tank_y2 + 430) and ( ball_x1 > 370 and ball_x1 <  400 ) or R_hit = '1' else '0';
--L_hit <= 	   '1' when (ball_y2 > tank_y1  and  ball_y2 < tank_y1 + 30) and ( ball_x2 > 370 and ball_x2 < 400 ) or L_hit = '1' else '0';
--actual_hit_col_2 <= "110000" when (col_idx > tank_y2 + 430 and  col_idx < tank_y2 + 460) and ( row_idx > 370 and row_idx <  400 ) else
               --     "001100" when (col_idx > tank_y1  and  col_idx < tank_y1 + 30) and ( row_idx > 370 and row_idx < 400 ) else "000011";
--hit <= '0' ;
	backgroundsignal <= '0' when (fire = '1' or start_screen = '1') else '1';
	-- (fire = '1' and playing_screen = '1')
		
		gamepixels <= ball_signal when (row_idx > ball_x1 and row_idx < ball_x1 + 10 and col_idx > ball_y1 + 27 and col_idx + 10 < ball_y1 + 50) or 
		(row_idx > ball_x2 and row_idx < ball_x2 + 10 and col_idx  > ball_y2 and col_idx < ball_y2 +10) 
		else elL when (row_idx + 25 > tank_x1 and row_idx + 5 < tank_x1 + 20 and col_idx > tank_y1 and col_idx < tank_y1 + 30) else
		
		elR when (row_idx + 25 > tank_x2 and row_idx + 5 < tank_x2 + 20 and col_idx > tank_y2 + 430 and col_idx < tank_y2 + 460) else background;
--		background; --else elL when (playing_screen = '1' and backgroundsignal = '1') 
		
		gameover <= gop1 when (R_hit = '1' and L_hit = '0') else gop2 when (R_hit = '0' and L_hit = '1') else gotie ;--when (R_hit = '1' and L_hit = '1') else instruct;
	 
		-- what we want to output
		outputscreen <= gamepixels when (playing_screen = '1') else startscreen when (start_screen = '1') else gameover when (R_hit = '1' ) else instruct;
		rgb <= outputscreen when valid_input = '1' else 6d"0";
		-- outputscreen <= startscreen;

end architecture synth;


