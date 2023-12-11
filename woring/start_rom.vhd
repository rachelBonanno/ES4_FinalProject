
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity start_screen_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(5 downto 0);
	  yadr : in unsigned(6 downto 0); -- 0-1023
	  to_screen : out std_logic_vector(5 downto 0)
      );
end start_screen_rom;

architecture synth of start_screen_rom is
signal totaladr : std_logic_vector(12 downto 0);
begin
   process (clk) begin
	if rising_edge(clk) then
		case totaladr is




when "0010000000110" => to_screen <= "100001";


when others => to_screen <= "110000";

end case;
	end if;
   end process;
   totaladr <= std_logic_vector(xadr) & std_logic_vector(yadr);
end;