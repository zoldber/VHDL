library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mul3_add1 is

	port(
		byte_in 	: 	in std_logic_vector(7 downto 0);
		byte_out :	out std_logic_vector(7 downto 0)
	);
	
end mul3_add1;

architecture behavioral of mul3_add1 is

	signal two_times_byte_in : std_logic_vector(7 downto 0);

	begin
	
		process(byte_in)
		
		begin
			
			two_times_byte_in <= byte_in(6 downto 0) & "0";
			
			byte_out <= two_times_byte_in + byte_in + "00000001";
			
		end process;
		
end behavioral;