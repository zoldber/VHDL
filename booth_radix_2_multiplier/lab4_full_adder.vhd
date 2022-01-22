--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--
--	A generic full adder implemented as a dataflow
--	design from 1 XOR gate, 1 OR gate, and 3 AND gates.
--	A simple full adder array was used over a lookahead
--	counterpart for its simplicity and ease of use with
--	a "for-generate" sequence.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_full_adder is
	port(
		A_bit	: IN std_logic;
		B_bit : IN std_logic;
		C_inp	: IN std_logic;
		
		S_bit : OUT std_logic;
		C_out	: OUT std_logic
	);
end lab4_full_adder;
--------------------------------------------------------

architecture dataflow of lab4_full_adder is

	begin
		
		S_bit <= A_bit XOR B_bit XOR C_inp;
		C_out <= (A_bit AND B_bit) OR (A_bit AND C_inp) OR (B_bit AND C_inp);

end dataflow;