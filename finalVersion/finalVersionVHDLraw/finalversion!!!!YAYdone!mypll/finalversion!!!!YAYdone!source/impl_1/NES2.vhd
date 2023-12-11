library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NES2 is
  port(
		    latch2 : out std_logic;     			
			data2 : in std_logic;
			dataout2 : out unsigned(7 downto 0);
			nesclk2 : out std_logic;
			clk32 : in std_logic

--	controllerclk : out std_logic
  );
end NES2;

architecture synth of NES2 is

	--component HSOSC is
	--	generic (
	--		CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2�N (0-3)
	--	port(
	--		CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up
	--		CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
	--		CLKHF : out std_logic := 'X'); -- Clock output
	--end component;
	
	


signal count : unsigned(20 downto 0);
signal nescount : unsigned(7 downto 0);
signal inputs : unsigned(7 downto 0) := "00000000";
--signal clk : std_logic;
begin  


	--osc : HSOSC generic map ( CLKHF_DIV => "0b00")
	--	port map (CLKHFPU => '1',
	--		CLKHFEN => '1',
	--		CLKHF => clk);

process (clk32) begin
	if rising_edge(clk32) then
		count <= count + '1';
	end if;
	nesclk2 <= count(8) when nescount = 8d"2" else
			  count(8) when nescount = 8d"3" else
			  count(8) when nescount = 8d"4" else
			  count(8) when nescount = 8d"5" else
			  count(8) when nescount = 8d"6" else
			  count(8) when nescount = 8d"7" else
			  count(8) when nescount = 8d"8" else
			  count(8) when nescount = 8d"9" else '0';	
	

	if rising_edge(nesclk2) then
		inputs <= inputs(6 downto 0) & (not data2);
	end if;

	nescount <= count(16 downto 9);

	latch2 <= '1' when nescount = 8d"1" else '0';
	if latch2 then 
		dataout2 <= inputs;
		
	end if;
	

end process;

end;