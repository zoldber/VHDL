library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity assembled is 

	port(
	
		sw : in std_logic_vector(9 downto 0);
		ledr : out std_logic_vector(9 downto 0)
	);

end assembled;

architecture behavioral of assembled is

	----------------------------------------
	--WORKS
	
	component is_odd_or_done
		port(
			byte_in 	: in std_logic_vector(7 downto 0);
			is_odd	: out std_logic;
			is_done	: out std_logic
		);
	end component;

	----------------------------------------
	
	----------------------------------------
	--WORKS
	
	component mul3_add1
		port(
			byte_in 	: 	in std_logic_vector(7 downto 0);
			byte_out :	out std_logic_vector(7 downto 0)	
		);
	end component;
	
	----------------------------------------
	
	----------------------------------------
	--WORKS
	
	component div2
		port(
			byte_in 	: 	in std_logic_vector(7 downto 0);
			byte_out :	out std_logic_vector(7 downto 0)
		);
	end component;
	
	----------------------------------------
	
	----------------------------------------
	component processor
		port(
			set		:	in std_logic;
			clk		:	in std_logic;
			byte_in 	: 	in std_logic_vector(7 downto 0);
			byte_out :	out std_logic_vector(7 downto 0)
		);
	end component;
	----------------------------------------
	
	begin
		
	
end behavioral;