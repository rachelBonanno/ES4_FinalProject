library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity GameLogic is
  port(
    clk : in std_logic;
    Start_Button : in std_logic;
	PlayingScreen : out std_logic;
	StartScreen : out std_logic;
	player : out std_logic := '0' ;
	hit: in std_logic
  );
end;

architecture synth of GameLogic is
type state is (Start,Playing,GameOver,Loaded);
signal s : state;
signal endthegame : std_logic;

begin
process(clk) begin
if rising_edge(clk) then 
case s is 
       when Loaded =>
	   if not Start_Button  then
		    s <= Start;
			end if;
    when Start =>
	
 		if Start_Button  then
			s <= Playing;
			
		end if;       

    when Playing =>    
	    
		if hit then
			
			s <= GameOver;
		end if;         
		 
	when GameOver =>
	
		if Start_Button   then
			s <= Start;
			player <= not player;
		end if;
	when others =>
		s <= Loaded;
        PlayingScreen <= '0';
        StartScreen <= '1' ;
end case;
end if;
end process;

PlayingScreen <= '1' when s = Playing else '0';
StartScreen <= '1' when s = STart else '0';
-- player <= '0' ;
end;