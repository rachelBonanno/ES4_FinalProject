library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ele_L_rom is
  port(
	  clk : in std_logic;
	  row_idx: in unsigned(7 downto 0);
	  col_idx : in unsigned(5 downto 0);
	  rgb : out std_logic_vector(5 downto 0)
	  );
end ele_L_rom;

architecture synth of ele_L_rom is

signal location : std_logic_vector(13 downto 0);
begin
	process (clk) begin
		if rising_edge(clk) then
			case location is
				when "00000000000010" => rgb <= "111111";
				when "00000000000011" => rgb <= "111111";
				when "00000000000100" => rgb <= "111111";
				when "00000000000101" => rgb <= "111111";
				when "00000000000110" => rgb <= "111111";
				when "00000100000001" => rgb <= "111111";
				when "00000100000010" => rgb <= "111111";
				when "00000100000011" => rgb <= "111111";
				when "00000100000100" => rgb <= "111111";
				when "00000100000110" => rgb <= "111111";
				when "00001000000000" => rgb <= "111111";
				when "00001000000001" => rgb <= "111111";
				when "00001000000010" => rgb <= "111111";
				when "00001000000011" => rgb <= "111111";
				when "00001000000100" => rgb <= "111111";
				when "00001000000101" => rgb <= "111111";
				when "00001000000110" => rgb <= "111111";
				when "00001100000001" => rgb <= "111111";
				when "00001100000010" => rgb <= "111111";
				when "00001100000011" => rgb <= "111111";
				when "00001100000100" => rgb <= "111111";
				when "00001100000101" => rgb <= "111111";
				when "00001100000110" => rgb <= "111111";
				when "00010000000001" => rgb <= "111111";
				when "00010000000010" => rgb <= "111111";
				when "00010000000100" => rgb <= "111111";
				when "00010000000101" => rgb <= "111111";
				when others => rgb <= "000000";
			end case;
		end if;
	end process;
	location <= std_logic_vector(col_idx) & std_logic_vector(row_idx);
end;