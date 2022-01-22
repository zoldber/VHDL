--Zachary Oldberg
--ECE 3270, S 001
--Lab 4
--
--Description:
--	the recoding unit is similar to a full adder but doesn't support
--	a second input arg, and can invert its input bit before adding a 
--	carry bit to facilitate two's complement.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_recoding_component is
	port(
			
			inp_bit	: IN std_logic;
			sign_chg	: IN std_logic;
			carry_in	: IN std_logic;
			carry_out: OUT std_logic;
			out_bit	: OUT std_logic
			
	);
end lab4_recoding_component;
--------------------------------------------------------

architecture dataflow of lab4_recoding_component is

	signal out_xor_inp_a : std_logic;
	signal out_xor_inp_b : std_logic;

	begin
		
		out_xor_inp_a 	<= carry_in;
		out_xor_inp_b 	<= inp_bit XOR sign_chg;
		
		carry_out 		<= out_xor_inp_a AND out_xor_inp_b;
		
		out_bit			<= out_xor_inp_a XOR out_xor_inp_b;
		
end dataflow;