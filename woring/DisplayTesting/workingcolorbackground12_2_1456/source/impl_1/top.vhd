library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Top is port(
	input: in std_logic;
	output_pll_core: out std_logic; --12
	hsync_output : out std_logic;
	vsync_output : out std_logic;
	rgb_output: out std_logic_vector(5 downto 0)
    
);
end entity Top;

architecture synth of Top is 
	component mypll is
    port(
        ref_clk_i: in std_logic;
        rst_n_i: in std_logic;
        outcore_o: out std_logic;
        outglobal_o: out std_logic
    );
end component mypll;
	
	component vga port (
			clk : in std_logic;
			hsync : out std_logic;
			vsync : out std_logic;
			row : out unsigned (9 downto 0); -- includes vsync rows
			col : out unsigned (9 downto 0); -- includes hsync rows
			valid : out std_logic
	);
	end component vga;
	
	component pattern_gen port(
		clk_pattern : in std_logic;
		row_idx : in unsigned(9 downto 0);
		col_idx : in unsigned(9 downto 0);
		valid_input: in std_logic;
		rgb: out std_logic_vector(5 downto 0)
	);
	end component pattern_gen;





signal output_pll_global: std_logic;
signal row_output : unsigned(9 downto 0);
signal col_output : unsigned(9 downto 0);
signal valid_output: std_logic;

begin






	pll_test : mypll port map (
			ref_clk_i => input,
			rst_n_i => '1',
			outcore_o => output_pll_core,
			outglobal_o =>  output_pll_global
	);
	vga_test : vga port map (
		clk => output_pll_global,
		hsync => hsync_output,
		vsync => vsync_output,
		row => row_output,
		col => col_output,
		valid => valid_output
	);

	pattern_gen_test : pattern_gen port map (
		clk_pattern => output_pll_global,
		row_idx => row_output,
		col_idx => col_output,
		valid_input => valid_output,
		rgb => rgb_output
	);






	

end architecture synth;
