library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity GameLogic is
  port(
    clk : in std_logic;
    Start_Button : in std_logic;
	Select_Button : in std_logic;
	PlayingScreen : out std_logic;
	StartScreen : out std_logic;
	GameoverScreen : out std_logic := '0';
	
	player : out std_logic := '0' ;
	R_hit : in std_logic;
	L_hit : in std_logic ;
	hit: in std_logic
	
  );
end;

architecture synth of GameLogic is
type state is (Start, Instruction, Playing,GameOver,Loaded);
signal s : state;
signal endthegame : std_logic;

begin
process(clk) begin
if rising_edge(clk) then 
case s is 
       when Loaded =>
	   if not Start_Button then
		    s <= Start;
		--	GameoverScreen <= '0';
		--	GameoverScreen <= '0';
			
			end if;
	when Instruction =>
	
		if Select_Button then
			s <= Playing;
		--	GameoverScreen <= '0';
		end if;
    when Start =>
 		-- if Start_Button  then
		if Start_Button then
			s <= Instruction;
		--	GameoverScreen <= '0';
		end if;       

    when Playing =>    
	    
		if hit then
			
			s <= GameOver;
			--GameoverScreen <= '1';
		end if;         
		 
	when GameOver =>
	
		if Select_Button   then
			s <= Start;
			--GameoverScreen <= '0';
			
		end if;
	when others =>
		s <= Loaded;
		--GameoverScreen <= '0';
end case;
end if;

if s = GameOver then 
GameoverScreen <= '1';
else
GameoverScreen <= '0';
end if;

end process;

PlayingScreen <= '1' when s = Playing else '0';

StartScreen <= '1' when s = Start else '0';
--player <= '0' ;
end;