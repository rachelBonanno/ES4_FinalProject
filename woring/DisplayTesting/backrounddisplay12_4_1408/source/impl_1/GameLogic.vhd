library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity GameLogic is
  port(
    clk : in std_logic;
    buttons : in unsigned(7 downto 0)
  );
end;

architecture synth of GameLogic is
type state is (Start,Playing,GameOver);
signal s : state;
signal endthegame : std_logic;

begin
process(clk) begin
if rising_edge(clk) then 
case s is 

    when Start =>
 		if buttons(0 downto 0) = "0" then
			s <= Playing;
		end if;       

    when Playing =>    
		if endthegame then
			s <= GameOver;
		end if;         
		 
	when GameOver =>
		if buttons(0 downto 0) = "0"  then
			s <= Start;
		end if;
	when others =>
		s <= Start;

end case;
end if;
end process;

end;