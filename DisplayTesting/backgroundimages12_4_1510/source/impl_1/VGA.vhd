library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is port (
        clk : in std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        row : out unsigned (9 downto 0); -- includes vsync rows
        col : out unsigned (9 downto 0); -- includes hsync rows
        valid : out	 std_logic
);
end entity vga;


architecture synth of vga is
	signal counter_row :  unsigned(9 downto 0); -- vsync vertical
	signal counter_col :  unsigned(9 downto 0); -- hsync horizontal
	
	begin
		process(clk)
		begin
			if rising_edge(clk) then
				if counter_col = 799 then
					counter_col <= "0000000000";
					if counter_row = 524 then
						counter_row <= "0000000000";
					else
						counter_row <= counter_row + 1;
					end if;
				else 
					counter_col <= counter_col + 1;
					
				end if;
			end if;
		
		end process;
		hsync <= '0' when counter_col >= 656 and counter_col < 752 else '1';
		vsync <= '0' when counter_row >= 490 and counter_row < 492 else '1';
		row <= counter_row;
		col <= counter_col;
		valid <= '1' when row < 480 and col < 640 else '0';
		


end architecture synth;