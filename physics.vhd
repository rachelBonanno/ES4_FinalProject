library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity physics is
  port(
    clk_VGA : in std_logic;
    Player1 : in std_logic;
    Player2 : in std_logic;
    angle : in unsigned(2 downto 0);
	clk_Physics : out std_logic;
    x : out unsigned(8 downto 0);
    y : out unsigned(8 downto 0)
  );
end;

architecture synth of physics is

signal count : unsigned(20 downto 0);

signal Delta : unsigned(2 downto 0);
signal T : unsigned(5 downto 0);
begin


process (clk_VGA) begin
	if rising_edge(clk_VGA) then
		count <= count + '1';
	end if;
	clk_Physics <= count(8);
	

	If rising_edge(clk_physics) then 

		T <= T + 1;
        Y <= 479 - 3*T + 3*T*T;
		
		
		If Player1 then
			X <= 1 + Delta;
			
		Elsif player2 then 
			x<= 640 - Delta;
		End if;

	End if;
End process;
Delta <= "000" when angle = "111" else
     3b"0" when angle = "110" else
	 3b"0" when angle = "101" else
	 3b"0" when angle = "100" else
	 3b"0" when angle = "011" else
	 3b"0" when angle = "001" else
	 3b"0" ;
	 
    T <= 6b"0" when y = 9b"0";
	x <= 6b"0" when y = 9b"0";
end;


