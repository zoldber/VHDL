--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	Register C is an accumulator for iterative summation
--	of the system's bitpair-encoded multiplier. Its input
--	is gated by a specialized multiplexer that passes an
--	encoded value or zeros based on whether or not loadreg
--	is active. In the former case, zeros are passed to this
--	unit regardless of the value of he muliplier.

--NOTE:
--	"msb" is used frequently in this file and others but
--	doesn't signify an individual bit. Rather,  "msb"
--	stands for "most significant bits" where necessary.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_regC is

	generic(ARG_WIDTH : integer := 8);

	port(
	
		shift   : IN std_logic;
		reg_clk : IN std_logic;
		reg_lat : IN std_logic;
		
		--looks like:
		--[msb_inp<2>][reg_inp<ARG_WIDTH>]
		msb_inp : IN std_logic_vector(1 downto 0);
		reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		
		--looks like:
		--[reg_out<ARG_WIDTH>]
		reg_out : OUT std_logic_vector((ARG_WIDTH-1) downto 0)

		
	);
	
end lab4_regC;
--------------------------------------------------------

architecture behavioral of lab4_regC is

	--in all, reg_int will have ARG_WIDTH + 2 bits, with two leading on the left side being fed in 
	--(not a part of reg_out until next shift), and the two lsb of reg_out being mapped to msb of regB
	signal reg_int 	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal msb_int		: std_logic; --used for sign extension
	
	begin
			
		process(reg_clk)
			
			begin
			
				if rising_edge(reg_clk) then
				
					if reg_lat = '1' then
					
						--bulk of register that holds value
						reg_int((ARG_WIDTH-1) downto 0) <= reg_inp;
						
						--two msb
						msb_int <= reg_inp(ARG_WIDTH-1);
						
						-- last rev. reg_int((ARG_WIDTH+1) downto ARG_WIDTH) <= msb_inp;
						
						
					elsif shift = '1' then	--[msb] should be [00] if reg_int(msb) = 0 etc.
					
						--NOTE: msb_pair stays the same here, as the sign extension is preserved this way
						
						-- last rev. reg_int <= msb_inp & reg_int((ARG_WIDTH+1) downto 2);
						
						reg_int <= msb_int & msb_int & reg_int((ARG_WIDTH-1) downto 2);
						
					end if;
					
				else
				
					reg_int <= reg_int;
					
				end if;
				
		end process;
		
		reg_out <= reg_int;
		
end behavioral;