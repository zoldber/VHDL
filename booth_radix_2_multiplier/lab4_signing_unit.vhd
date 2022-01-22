LIBRARY ieee;
USE ieee.std_logic_1164.all;

--This component is a single XOR gate, and exists to resolve a
--Modelsim error in the port mapping stage (can't assign directly with an XOR)

--Entity
--------------------------------------------------------
entity lab4_signing_unit is
	port(
			B_val : IN std_logic;
			B_sig : IN std_logic;
			B_res : OUT std_logic
	);
end lab4_signing_unit;
--------------------------------------------------------

architecture dataflow of lab4_signing_unit is

	begin
		
		B_res <= B_val XOR B_sig;
		
end dataflow;