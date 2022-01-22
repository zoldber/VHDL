--Zachary Oldberg
--ECE 3270, S 001
--Lab 3
--
--Description:
--
--	A "for-generate" efficient implementation of
--	an adder/subtractor. The addition and two's
--	compliment augmentation of input args are
--	unfixed in width, and compatible with the generic
--	typed BUS_WIDTH scheme assigned in the lab prompt.
--
--	Signed operation:
--		Opsel = 0 (ADD) -> S_bus = A_bus + B_bus
--		Opsel = 1 (SUB) -> S_bus = A_bus - B_bus


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab3_add_sub is
	
	generic(BUS_WIDTH : integer);
	
	port(
		A_bus : IN std_logic_vector((BUS_WIDTH-1) downto 0);
		B_bus : IN std_logic_vector((BUS_WIDTH-1) downto 0);
		
		Ovflw : OUT std_logic;	--might not need, keep just in case for FSM part
		
		S_bus : OUT std_logic_vector((BUS_WIDTH-1) downto 0);
		
		Opsel : IN std_logic
	);
	
end lab3_add_sub;
--------------------------------------------------------

architecture behavioral of lab3_add_sub is


	component lab3_full_adder
		port(
			A_bit	: IN std_logic;
			B_bit : IN std_logic;
			C_inp	: IN std_logic;
			
			S_bit : OUT std_logic;
			C_out	: OUT std_logic
		);
	end component;
	
	
	
	component lab3_signing_unit
		port(
			B_val : IN std_logic;
			B_sig : IN std_logic;
			B_res : OUT std_logic
		);
	end component;
	
	
	signal carry_lines : std_logic_vector(BUS_WIDTH downto 0);	
	signal signed_B : std_logic_vector((BUS_WIDTH-1) downto 0);

	
	begin	
	
	--n_bit adder's first carry-in bit will be 1 if performing two's complement
	--Opsel is 1 for subtract, 0 for add	
	Carry_lines(0) <= Opsel;
	Ovflw <= carry_lines(BUS_WIDTH);
	
	NBIT_FULL_ADDR : for i in 0 to (BUS_WIDTH-1) generate
				
				
		n_SU : lab3_signing_unit port map(
			B_val => B_bus(i),
			B_sig => Opsel,
			B_res => signed_B(i)
		);
				
		n_FA : lab3_full_adder port map(
			C_inp => carry_lines(i),
			A_bit => A_bus(i),
			B_bit => signed_B(i),
			S_bit => S_bus(i),
			C_out => carry_lines(i + 1)
		);
		
		end generate;	
		
end behavioral;
	
	
	
	