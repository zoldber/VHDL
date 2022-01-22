--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	Register A stores the raw multiplcand input and simultaneously generates four encodings for
--	selection and accumulation in regC. Technically one "encoding" isn't encoded, as it's an
--	exact duplicate of the input arg, and another necessitates a single leftware bit shift. 
--	Still, encoding units are present on each because they support every necessary operation and
--	look far more consistent / simplified debugging.
--
--	It's also worth noting that only one register is latched, that storing the un-altered input,
--	and that its output is fed into the four encoding units.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_regA is

	generic(ARG_WIDTH : integer := 8);

	port(
		reg_clk : IN std_logic;
		reg_lat : IN std_logic;
		reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		reg_out_pos_1 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
		reg_out_neg_1 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
		reg_out_pos_2 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
		reg_out_neg_2 : OUT std_logic_vector((ARG_WIDTH-1) downto 0)
	);
end lab4_regA;
--------------------------------------------------------

architecture behavioral of lab4_regA is

	--components
	--------------------------------------------------------
	component lab4_recoding_unit
	
		generic(ARG_WIDTH : integer);
		
		port(
			input		: IN std_logic_vector((ARG_WIDTH-1) downto 0);
			output	: OUT std_logic_vector((ARG_WIDTH-1) downto 0);
			inv_sign	: IN std_logic;
			double	: IN std_logic
		);
	
	end component;
	--------------------------------------------------------


	signal reg_int : std_logic_vector((ARG_WIDTH-1) downto 0);
	signal reg_cur : std_logic_vector((ARG_WIDTH-1) downto 0);

	
	begin

		--(+1)*multiplcand
		--------------------------------------------------------
		pos_one_recoded : lab4_recoding_unit
			generic map(ARG_WIDTH => ARG_WIDTH)
			
			port map(
				input		=> reg_cur,
				output	=>	reg_out_pos_1,
				inv_sign	=> '0',
				double	=> '0'
			);
		--------------------------------------------------------
		
		--(+2)*multiplcand
		--------------------------------------------------------
		pos_two_recoded : lab4_recoding_unit
			generic map(ARG_WIDTH => ARG_WIDTH)
			
			port map(
				input		=> reg_cur,
				output	=>	reg_out_pos_2,
				inv_sign	=> '0',
				double	=> '1'
			);
		--------------------------------------------------------
	
		--(-1)*multiplcand
		--------------------------------------------------------
		neg_one_recoded : lab4_recoding_unit
			generic map(ARG_WIDTH => ARG_WIDTH)
			
			port map(
				input		=> reg_cur,
				output	=>	reg_out_neg_1,
				inv_sign	=> '1',
				double	=> '0'
			);
		--------------------------------------------------------
		
		--(-2)*multiplcand
		--------------------------------------------------------
		neg_two_recoded : lab4_recoding_unit
			generic map(ARG_WIDTH => ARG_WIDTH)
			
			port map(
				input		=> reg_cur,
				output	=>	reg_out_neg_2,
				inv_sign	=> '1',
				double	=> '1'
			);
		--------------------------------------------------------
		
		
		process(reg_clk)
			
			begin
			
				if rising_edge(reg_clk) then
				
					if reg_lat = '1' then
					
						reg_int <= reg_inp;
						
					end if;
					
				else
				
					reg_int <= reg_int;
					
				end if;
				
		end process;
		
		reg_cur <= reg_int;
		
end behavioral;