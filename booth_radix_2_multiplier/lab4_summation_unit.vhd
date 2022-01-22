--Zachary Oldberg
--ECE 3270, S 001
--Lab 4
--
--Description:
--
--	A "for-generate" efficient implementation of
--	a binary adding unit. The addition of input args are
--	generically typed in width, and compatible with the 
--	heirarchically defined ARG_WIDTH scheme assigned in the lab prompt.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_summation_unit is
	
	generic(ARG_WIDTH : integer := 8);
	
	port(
		A_bus : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		B_bus : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		
		Ovflw : OUT std_logic;	--might not need, keep just in case for FSM part
		
		S_bus : OUT std_logic_vector((ARG_WIDTH-1) downto 0)
	);
	
end lab4_summation_unit;
--------------------------------------------------------

architecture behavioral of lab4_summation_unit is


	component lab4_full_adder
		port(
			A_bit	: IN std_logic;
			B_bit : IN std_logic;
			C_inp	: IN std_logic;
			
			S_bit : OUT std_logic;
			C_out	: OUT std_logic
		);
	end component;
	
	
	signal carry_lines : std_logic_vector(ARG_WIDTH downto 0);	
	
	begin	
	
	--n_bit adder's first carry-in bit will be 1 if performing two's complement
	Carry_lines(0) <= '0';
	--most significant bit in the carry lines is just overflow
	Ovflw <= carry_lines(ARG_WIDTH);
	
	NBIT_FULL_ADDR : for i in 0 to (ARG_WIDTH-1) generate
				
		n_FA : lab4_full_adder port map(
			C_inp => carry_lines(i),
			A_bit => A_bus(i),
			B_bit => B_bus(i),
			S_bit => S_bus(i),
			C_out => carry_lines(i + 1)
		);
		
		end generate;	
		
end behavioral;
	
	
	
	