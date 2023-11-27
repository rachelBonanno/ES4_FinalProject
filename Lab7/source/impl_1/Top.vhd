library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;
entity Top is
	port(
		
		dataout : out unsigned(7 downto 0);
	    nesclk : out std_logic;
		latch : out std_logic;
	    data : in std_logic;
		clk : out std_logic
		--controllerclk : out std_logic
	);
end;

architecture synth of Top is
	
	component NES is	
		port(		
		    latch : out std_logic;     			
			data : in std_logic;
			dataout : out unsigned(7 downto 0);
			nesclk : out std_logic;
			clk : out std_logic
		--	controllerclk : out std_logic
		);
	
	end component;	
	
	
	
begin
	NES0: NES
	port map(
		    latch => latch, 			
			data => data,
			dataout => dataout,
			nesclk => nesclk,

			clk => clk
			--controllerclk => controllerclk
	);

    

end;