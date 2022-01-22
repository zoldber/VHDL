library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity processor is

	port(
		set		:	in std_logic;
		clk		:	in std_logic;
		byte_in 	: 	in std_logic_vector(7 downto 0);
		byte_out :	out std_logic_vector(7 downto 0)
	);
	
end processor;

architecture behavioral of processor is

	signal reg_val : std_logic_vector(7 downto 0);
	
	signal buf_val : std_logic_vector(7 downto 0);
	
	begin
		
		process(set, clk)
		
		begin
			
			if set = '1' and rising_edge(clk) then
			
				reg_val <= byte_in;
				
			elsif set = '0' and rising_edge(clk) then
			
				reg_val <= reg_val + 1;
				
			end if;
			
		end process;
		
		byte_out <= reg_val;
		
end behavioral;