--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--
--	Main assembly ties together the FSM control unit, 
-- registers A-D, the binary summation unit, 

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--======================================================
entity lab4_main_board is

	generic(ARG_WIDTH : integer := 4);	
	
	port(

		key 	: IN std_logic_vector(1 downto 0);
		sw		: IN std_logic_vector(9 downto 0);
		
		ledr	: OUT std_logic_vector(9 downto 0)										
	);
	
end lab4_main_board;
--======================================================

architecture structural of lab4_main_board is

	component lab4_main
		generic(ARG_WIDTH : integer);
	
		port(
		main_rst				: IN std_logic;
		main_clk				: IN std_logic;
		main_start			: IN std_logic;
		main_multiplicand	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		main_multiplier	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		main_product		: OUT std_logic_vector(((2*ARG_WIDTH)-1) downto 0);
		main_done			: OUT std_logic;
		main_busy			: OUT std_logic
	);
	
	end component;

	begin
	
	PROCESSOR : lab4_main
		generic map(ARG_WIDTH => ARG_WIDTH)
		
		port map(
			main_rst				=> key(1),
			main_clk				=> key(0),
			main_start			=> sw(9),
			main_multiplicand	=> sw(7 downto 4),
			main_multiplier	=> sw(3 downto 0),
			main_product		=> ledr(7 downto 0),
			main_done			=> ledr(9),
			main_busy			=> ledr(8)
		);


end structural;