library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- physics is responsible for updating the current x and y position
entity physics is
  port(
	  fire : in std_logic;
	  fired_output : out std_logic;
	  angle_up : in std_logic;
	  angle_down : in std_logic;
	  move_right : in std_logic;
	  move_left : in std_logic;
	  		 angle_up2 : in std_logic;
	     angle_down2 : in std_logic;
		 move_right2 : in std_logic;
	     move_left2 : in std_logic;
		 fire2 : in std_logic ;
	  
	  tank_x1 : out unsigned(9 downto 0):= 10d"400";
	  tank_y1 : out unsigned(9 downto 0):= 10d"100";
      ball_x1 : out unsigned(9 downto 0) ; -- row
      ball_y1 : out unsigned(9 downto 0) ; -- col
	  
	  tank_x2 : out unsigned(9 downto 0):= 10d"400";
	  tank_y2 : out unsigned(9 downto 0):= 10d"600";
      ball_x2 : out unsigned(9 downto 0); -- row
      ball_y2 : out unsigned(9 downto 0) ; -- col
	  
	  player : in std_logic  ;
      frame_clk : in std_logic;
	  game_over : in std_logic
  );
end;

architecture synth of physics is

signal v_col_p1 : integer := 0;
signal v_row_p1 : integer := 0;
signal v_col_p1_in : integer := 17;
signal v_row_p1_in : integer := -40;


signal v_col_p2 : integer := 0;
signal v_row_p2 : integer := 0;
signal v_col_p2_in : integer := 17;
signal v_row_p2_in : integer := -40;

constant g : integer := 1;
signal angle : unsigned(2 downto 0) := "001"; -- 15 degrees
signal fired : std_logic := '1';
signal fired2 : std_logic := '1';
begin
process(frame_clk) begin
	-- after setting initial col and row velocity
	
	if rising_edge(frame_clk) then
	
	
		
	
			if move_right = '1' then
				tank_y1 <= tank_y1 + 1;
				ball_y1 <= tank_y1;
			elsif move_left = '1' then
				tank_y1 <= tank_y1 - 1;
				ball_y1 <= tank_y1;
			end if;
		
			if angle_up  then
			v_col_p1_in <= v_col_p1_in + 1;
			v_row_p1_in <= v_row_p1_in - 3;
			elsif angle_down then
			v_col_p1_in <= v_col_p1_in - 1;
			v_row_p1_in <= v_row_p1_in + 3;
			end if;
	
			if fired = '1' then
				--ball_y <= ball_y - 1 ;
				ball_y1 <= ball_y1+ v_col_p1;
				ball_x1 <= ball_x1 + v_row_p1;
				-- update vertical velocity
				v_row_p1 <= v_row_p1 + g;
				if ball_y1 > 640 or ball_x1 > 480 then
					v_col_p1 <= 35; v_row_p1 <= -11;
					ball_x1 <= tank_x1; ball_y1 <= tank_y1;
					fired <= '0';
				end if;
			end if;
		
		
		
		
		
		
		
		
	
			if move_right2 = '1' then
				tank_y2 <= tank_y2 + 1;
				ball_y2 <= tank_y2 ;
			elsif move_left2 = '1' then
				tank_y2 <= tank_y2 - 1;
				ball_y2 <= tank_y2 ;
			end if;
		
			if angle_up2  then
			v_col_p2_in <= v_col_p2_in - 1;
			v_row_p2_in <= v_row_p2_in - 3;
			elsif angle_down2 then
			v_col_p2_in <= v_col_p2_in + 1;
			v_row_p2_in <= v_row_p2_in + 3;
			end if;
	
			if fired2 = '1' then
				--ball_y <= ball_y - 1 ;
				ball_y2 <= ball_y2 - v_col_p2;
				ball_x2 <= ball_x2 + v_row_p2;
				-- update vertical velocity
				v_row_p2 <= v_row_p2 + g;
				if ball_x2 > 480 then   --ball_y2 > 640 or 
					v_col_p2 <= 35; v_row_p2 <= -11;
					ball_x2 <= tank_x2; ball_y2 <= tank_y2;
					fired2 <= '0';
					
			
				end if;
			end if;
	
	

end if;

		
	
	if fire = '1' then 
		fired <= '1';
		-- set up initial velocity of the ball
		v_col_p1 <= v_col_p1_in;  v_row_p1_in <= v_row_p1_in;
	   -- v_col_p2 <= v_col_p2_in;  v_row_p2_in <= v_row_p2_in;
	end if;
	
	      
 	if fire2 = '1' then 
		fired2 <= '1';
		-- set up initial velocity of the ball
	--	v_col_p1 <= v_col_p1_in;  v_row_p1_in <= v_row_p1_in;
	    v_col_p2 <= v_col_p2_in;  v_row_p2_in <= v_row_p2_in;
	end if;
	
	if game_over = '1' then 
		
		tank_y1 <= 10d"100";
		v_col_p1_in <= 17;
		v_row_p1_in <= -40;
		v_col_p1 <= 0;
	    v_row_p1 <= 0;
		
		tank_y2 <= 10d"600";
		v_col_p2_in <= 17;
		v_row_p2_in <= -40;
		v_col_p2 <= 0;
	    v_row_p2 <= 0;		
	end if;
	  
	end process;
	


fired_output <= fired or fired2;

end synth;