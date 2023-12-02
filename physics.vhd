library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- physics is responsible for updating the current x and y position
entity physics is
  port(
    clk_VGA : in std_logic; -- conditioned on VGA's full_frame_clk
    Player1 : in std_logic;
    Player2 : in std_logic;
    angle : in unsigned(2 downto 0); -- 15, 20, 45, 60, 75
	fire: : in std_logic; -- after one player has fired the projectile
	game_start: in std_logic; -- after one player has click game start
	game_over: in std_logic: -- supplid by game logic, if this is triggered, freeze the update
	-- clk_Physics : out std_logic;
    x1 : out unsigned(9 downto 0); -- current row of player 1
    y1 : out unsigned(9 downto 0); -- current col of player 1
	x2 : out unsigned(9 downto 0); -- current row of player 2
	y2 : out unsigned(9 downto 0); -- current col of player 2
  );
end;

architecture synth of physics is

signal count : unsigned(20 downto 0);

signal Delta : unsigned(2 downto 0);
signal T : unsigned(5 downto 0); --for debug, check how many physic update have been made

signal x1Init : unsigned(9 downto 0) := 10d"390"; -- hard coded x position for the ball of player1
signal y1Init : unsigned(9 downto 0) := 10d"100"; -- hard coded y position for the ball of player1
signal x2Init : unsigned(9 downto 0) := 10d"390";-- hard coded x position for the ball of player2
signal y2Init : unsigned(9 downto 0) := 10d"500";-- hard coded y position for the ball of player2
signal v_col_p1, v_row_p1 : integer := 0;
signal v_col_p1, v_row_p1 : integer := 0;
constant g : integet := 1;
signal wait : std_logic := '1';
begin


process (clk_VGA, fire) begin
	if rising_edge(clk_VGA) then
		if fire = '1' then
			wait <= '0';
		end if;
		if wait = '1' then
			x1 <= x1Init; y1 <= y1Init;
			x2 <= x2Init; y2 <= y2Init;
			case angle is 
				when "001" => -- 15 Degrees
					v_col_p1 <= 19; v_row_p1 <= -11;
					v_col_p2 <= -19; v_row_p2 <= -11;
				when "010" => -- 30 Degrees
					v_col_p1 <= 15; v_row_p1 <= -14;
					v_col_p2 <= -15; v_row_p2 <= -14;
				when "011" => -- 45 Degrees
					v_col_p1 <= 13; v_row_p1 <= -17;
					v_col_p2 <= -13; v_row_p2 <= -17;
				when "100" => -- 60 Degrees
					v_col_p1 <= 11; v_row_p1 <= -20;
					v_col_p2 <= -11; v_row_p2 <= -20;
				when "101" => -- 75 Degrees
					v_col_p1 <= 9; v_row_p1 <= -23;
					v_col_p2 <= -9; v_row_p2 <= -23;
			end case;
		end if;
		if Player1 = '1' then
			
			if game_over = '0': -- stop updating position once game over
				-- update positions
				y1 <= y1 + v_col_p1;
				x1 <= x1 + v_row_p1;
				-- update vertical velocity
				v_row_p1 <= v_row_p1 + g
				-- x1 = x1 ; -- for integration testing
				-- y1 = y1 + 1; -- for integration testing
				
			end if;
		end if;
		if Player2 = '1' then
			if game_over = '0': -- stop updating position once game over
				-- update positions
				y2 <= y2 + v_col_p2;
				x2 <= x2 + v_row_p2;
				-- update vertical velocity
				v_row_p2 <= v_row_p2 + g
				-- x2 = x2;  -- for integration testing
				-- y2 = y2 - 1 ; -- for integration testing
			end if;
		end if;
	end if;
	
End process;



Delta <= "000" when angle = "111" else
     3b"0" when angle = "110" else
	 3b"0" when angle = "101" else
	 3b"0" when angle = "100" else
	 3b"0" when angle = "011" else
	 3b"0" when angle = "001" else
	 3b"0" ;
	 
    T <= 6b"0" when y = 9b"0";
	x <= 6b"0" when y = 9b"0";
end;