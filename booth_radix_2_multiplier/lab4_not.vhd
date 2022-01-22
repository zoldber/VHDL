--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	generic NOT gate for implementing glue logic in structural type main assembly 
--	(i.e. creating low-active reset and start for board interfacing)


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_not is

	port(
		input : IN std_logic;
		output: OUT std_logic
	);
	
end lab4_not;
--------------------------------------------------------

architecture dataflow of lab4_not is

	begin
	
		output <= NOT input;
		
end dataflow;