--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	Register B stores the multiplier on load_reg and gradually accepts the contents of accumulator regC
--	via (n/2) bit-paired shifts. As the original value of regB is shifted out (in the direction of its
--	msb), a trio of bits on its lower end are used to determine the next encoding to be applied to the
--	summaiton unit's new input argument.



LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_regB is

	generic(ARG_WIDTH : integer := 8);

	port(
	
		--standard register interfaceing pins
		shift   : IN std_logic;
		reg_clk : IN std_logic;
		reg_lat : IN std_logic;
		
		--input looks like:
		--[msb_inp<2>][reg_inp<ARG_WIDTH>][traling_bit]
		msb_inp : IN std_logic_vector(1 downto 0);
		reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		trl_inp : IN std_logic;
		
		--output looks like:
		--[reg_out<ARG_WIDTH>][trailing_bit]
		reg_out : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
		coding_bits  : OUT std_logic_vector(2 downto 0)
		
	);
	
end lab4_regB;
--------------------------------------------------------

architecture behavioral of lab4_regB is

	--in all, reg_int will have ARG_WIDTH + 3 bits, with two leading on left side and one trailing on right
	signal reg_int : std_logic_vector((ARG_WIDTH+2) downto 0);

	begin
		
		process(reg_clk)
			
			begin
			
				if rising_edge(reg_clk) then
				
					if reg_lat = '1' then
					
						reg_int((ARG_WIDTH+2) downto (ARG_WIDTH+1)) <= msb_inp;
						reg_int((ARG_WIDTH) downto 1) <= reg_inp;
						reg_int(0) <= trl_inp;
						
					elsif shift = '1' then
					
						--NOTE: msb_pair stays the same here, as the sign extension is preserved this way
						--shift over new trail bit
						
						reg_int(ARG_WIDTH downto 0) <= reg_int((ARG_WIDTH+2) downto 2);
						
						--reg_int((ARG_WIDTH+2) downto (ARG_WIDTH+1)) <= msb_inp;

					elsif shift = '0' then --latch msb	--ADDED
					
						reg_int((ARG_WIDTH+2) downto (ARG_WIDTH+1)) <= msb_inp;	--ADDED
												
					end if;
					
				else
				
					reg_int <= reg_int;
					
				end if;
				
		end process;
		
		--added this debug fix me
		--reg_int((ARG_WIDTH+2) downto (ARG_WIDTH+1)) <= msb_inp;
								
		reg_out <= reg_int(ARG_WIDTH downto 1);
		
		coding_bits <= reg_int(2 downto 0);
						
end behavioral;