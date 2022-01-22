--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	generic OR gate for implementing glue logic in structural type main assembly


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_or is

	port(
		inp_A : IN std_logic;
		inp_B	: IN std_logic;
		output: OUT std_logic
	);
	
end lab4_or;
--------------------------------------------------------

architecture dataflow of lab4_or is

	begin
	
		output <= inp_A OR inp_B;
		
end dataflow;