
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is port(
	clk_pattern : in std_logic;
	row_idx : in unsigned(9 downto 0); -- max 479
	col_idx : in unsigned(9 downto 0); -- max 639
	valid_input: in std_logic;
	rgb: out std_logic_vector(5 downto 0)
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



begin
	start_rommap: start_rom port map (
		clk => clk_pattern,
		row_idx =>  unsigned(col_idx(9 downto 3)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => startscreen
		
		);

	background_rommap: background_rom port map (
		clk => clk_pattern,
		row_idx =>  unsigned(col_idx(9 downto 2)),
		col_idx  =>  unsigned(row_idx(8 downto 3)),
		rgb => background
		
		);
		
		-- what we want to output
		outputscreen <= background;
		-- outputscreen <= startscreen;

		-- what actually getoutputted
		rgb <= outputscreen when valid_input = '1' else 6d"0";
		-- rgb <=  "111100" when valid_input = '1' else 6d"0";


end architecture synth;
