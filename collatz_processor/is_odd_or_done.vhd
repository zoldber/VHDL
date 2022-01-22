library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity is_odd_or_done is

	port(
		byte_in 	: in std_logic_vector(7 downto 0);
		is_odd	: out std_logic;
		is_done	: out std_logic
	);
	
end is_odd_or_done;

architecture behavioral of is_odd_or_done is

	begin
	
		process(byte_in)
		
			begin
			
				if byte_in(0) = '1' and byte_in(7 downto 1) = "0000000" then 
				
					is_done <= '1';
					is_odd <= '0';
			
				elsif byte_in(0) = '1' then 
				
					is_done <= '0';
					is_odd <= '1';
		
				else 

					is_done <= '0';
					is_odd <= '0';
				
				end if;
			
		end process;
		
end behavioral;

