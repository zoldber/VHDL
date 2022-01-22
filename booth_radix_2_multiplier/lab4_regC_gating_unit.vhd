--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	Gates the input to register C with zeros or the output of the summation unit


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_regC_gating_unit is

	generic(ARG_WIDTH : integer);

	port(
	
		sum_select 	: IN std_logic;
		mux_input	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		mux_output	: OUT std_logic_vector((ARG_WIDTH-1) downto 0)
		
	);
	
end lab4_regC_gating_unit;
--------------------------------------------------------

architecture behavioral of lab4_regC_gating_unit is
	
	signal zeros : std_logic_vector(((ARG_WIDTH)-1) downto 0);
	
	begin

		zeros <= (others => '0');
	
		with sum_select select
		
			--NOTE: 	the not(loadreg) logic is implemented here. When I attempted to use a "not" in
			--			the structural code that bound everything together modelsim freaked out. That
			--			was, in my opinion, the elegent / intuitive way of doing it but this is functional.
			
			mux_output <= 	mux_input when '0',	--when NOT(loadreg)
								zeros when others;
							
		
end behavioral;