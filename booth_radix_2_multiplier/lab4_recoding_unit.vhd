--Zachary Oldberg
--ECE 3270, S 001
--Lab 4
--
--Description:
--
--	The recoding unit incorporates a doubling (1 left bit-shift) unit
-- and an array of recoding components that perform 2's complement. It
--	can output transformed inputs with (+1), (-1), (+2), and (-2) 
-- coefficients. It therefore supports all operations needed to employ
--	iterative addition through a bitpair encoding scheme.

--NOTE:
-- the recoding unit really only needs to be used for the negative 1 and negative 2 recodes
--	it's attached to all inputs because it looks cleaner and helped reduce confusion in debugging


LIBRARY ieee;
USE ieee.std_logic_1164.all;


--Entity
--======================================================
entity lab4_recoding_unit is

	generic(ARG_WIDTH : integer := 8);
	port(
		input		: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		output	: OUT std_logic_vector((ARG_WIDTH-1) downto 0);
		inv_sign	: IN std_logic;
		double	: IN std_logic
	);
	
end lab4_recoding_unit;
--======================================================


architecture behavioral of lab4_recoding_unit is
		
	--Component Declarations
	--======================================================
	component lab4_recoding_component
		port(
			
			inp_bit	: IN std_logic;
			sign_chg	: IN std_logic;
			carry_in	: IN std_logic;
			carry_out: OUT std_logic;
			out_bit	: OUT std_logic
			
		);
	end component;
	--======================================================
	
	signal mag_adj_inp : std_logic_vector((ARG_WIDTH-1) downto 0);
	signal carry_lines : std_logic_vector(ARG_WIDTH downto 0);	
	
	
	
	begin	
	
	carry_lines(0) <= inv_sign;
	
	
	
	--bit shift left for a 2x when double is high
	with double select
		mag_adj_inp <= input when '0',
							input((ARG_WIDTH-2) downto 0) & "0" when others;
		
		
		
	--individual transformation components are chained together to form a "unit" (this file)
	RECODING_COMP : for i in 0 to (ARG_WIDTH-1) generate			
				
		rec_cmp_n : lab4_recoding_component port map(
			sign_chg => inv_sign,
			carry_in => carry_lines(i),
			inp_bit 	=> mag_adj_inp(i),
			out_bit 	=> output(i),
			carry_out=> carry_lines(i + 1)
		);
		
		end generate;
		
end behavioral;
	
	
	
	