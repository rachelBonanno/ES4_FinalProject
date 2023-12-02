library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- physics is responsible for updating the current x and y position
entity physics is
  port(
	  fire: in std_logic;
      ball_x : out unsigned(9 downto 0) := 10d"400"; -- row
      ball_y : out unsigned(9 downto 0) := 10d"100"; -- col
      frame_clk : in std_logic
  );
end;

architecture synth of physics is

signal v_col_p1 : integer := 0;
signal v_row_p1 : integer := 0;
constant g : integer := 1;
signal angle : unsigned(2 downto 0) := "001"; -- 15 degrees
signal fired : std_logic := '0';

begin
process(frame_clk) begin
	-- after setting initial col and row velocity
	if rising_edge(frame_clk) then
		if fired = '1' then
			--ball_y <= ball_y - 1 ;
			ball_y <= ball_y+ v_col_p1;
			ball_x <= ball_x + v_row_p1;
			-- update vertical velocity
			v_row_p1 <= v_row_p1 + g;
			if ball_y > 640 or ball_x > 480 then
				v_col_p1 <= 19; v_row_p1 <= -11;
				ball_x <= 10d"400"; ball_y <= 10d"100";
				fired <= '0';
			end if;
		end if;
	end if;
	if fire = '1' then 
		fired <= '1';
		-- set up initial velocity of the ball
		v_col_p1 <= 19;  v_row_p1 <= -11;
	
	end if;
	end process;

end synth;