library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity div2 is

	port(
		byte_in 	: 	in std_logic_vector(7 downto 0);
		byte_out :	out std_logic_vector(7 downto 0)
	);
	
end div2;

architecture behavioral of div2 is

	begin
	
		process(byte_in)
		
		begin

			byte_out <= "0" & byte_in(7 downto 1);
						
		end process;
		
end behavioral;