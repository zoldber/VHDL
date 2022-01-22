--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	Register D is a 1 hot-encoded iteration counter. While
--	a binary counter could have been implemented, a shift-based
--	iteration counting scheme was far easier to develop.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_regD is

	--arg width is passed as a generic because booth-radix4 (bitpair) guarentees n/2 ops.
	--hence, the length of the one-hot vector is set to (n/2) + 1 (where msb is "itr cmp")
	generic(ARG_WIDTH : integer := 8);

	port(
	
		--reset should be held high until it's time to count
		itr_cmp	: OUT std_logic;	--"iterations complete"
		reg_rst	: IN std_logic;	--reset
		reg_clk	: IN std_logic;	--clock
		reg_count: IN std_logic
		
	);
	
end lab4_regD;
--------------------------------------------------------

architecture behavioral of lab4_regD is

	--note: 	the bit vector mapping scheme in this file actually makes an (n+1) bit one-hot
	--			 counter for an n itr process. That's because the final bit is the "itr_cmp"
	--			 flag, and also simplifies bit retention (i.e. avoids shifting all bits to zero)
	
	constant msb : integer :=  (ARG_WIDTH/2);

	signal one_hot : std_logic_vector(msb downto 0);
	
	
	begin
		
		process(reg_clk, reg_rst)
		
			begin
			
				if reg_rst = '1' then	--when (or as long as) reset is high, hot bit is lsb
	
					one_hot(msb downto 1) <= (others => '0');
					one_hot(0) <= '1';
									
				elsif rising_edge(reg_clk) and reg_count = '1' and one_hot(msb) = '0' then
				
					one_hot <= one_hot(msb-1 downto 0) & "0"; --shift left provided hot bit isn't in msb
					
				else
				
					one_hot <= one_hot;
										
				end if;
				
		end process;
		
		itr_cmp <= one_hot(msb);
				
end behavioral;