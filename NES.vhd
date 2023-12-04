library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NES is
  port(
    latch : out std_logic;     
	
	data : in std_logic := '0';
	dataout : out unsigned(7 downto 0):= "00000000";
	nesclk : out std_logic

--	controllerclk : out std_logic
  );
end NES;

architecture synth of NES is

	component HSOSC is
		generic (
			CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2ˆN (0-3)
		port(
			CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up
			CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
			CLKHF : out std_logic := 'X'); -- Clock output
	end component;
	
	


signal count : unsigned(20 downto 0);
signal nescount : unsigned(7 downto 0);
signal inputs : unsigned(7 downto 0) := "00000000";
signal clk : std_logic;
begin  


	osc : HSOSC generic map ( CLKHF_DIV => "0b00")
		port map (CLKHFPU => '1',
			CLKHFEN => '1',
			CLKHF => clk);

process (clk) begin
	if rising_edge(clk) then
		count <= count + '1';
	end if;
	nesclk <= count(8) when nescount = 8d"2" else
			  count(8) when nescount = 8d"3" else
			  count(8) when nescount = 8d"4" else
			  count(8) when nescount = 8d"5" else
			  count(8) when nescount = 8d"6" else
			  count(8) when nescount = 8d"7" else
			  count(8) when nescount = 8d"8" else
			  count(8) when nescount = 8d"9" else '0';	
	

	if rising_edge(nesclk) then
		inputs <= inputs(6 downto 0) & (not data);
	end if;

	nescount <= count(16 downto 9);

	latch <= '1' when nescount = 8d"1" else '0';
	if latch then 
		dataout <= inputs;
		
	end if;
	

end process;

end;