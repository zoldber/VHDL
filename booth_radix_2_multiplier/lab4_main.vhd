--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	The main board ties together all components / sub-systems and is
--	purely structural. It takes two input arguments of bit-width n and
--	generates a product of bit width (2*n) via (n/2) steps through a
-- booth-radix-4 bitpair algorithm. Each step consists of an add and
-- shift so (n/2) steps doesn not imply n/2 clock cycles.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--======================================================
entity lab4_main is

	generic(ARG_WIDTH : integer := 8);
	
	port(
		
		main_rst				: IN std_logic;
		main_clk				: IN std_logic;
		main_start			: IN std_logic;
		main_multiplicand	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		main_multiplier	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
		main_product		: OUT std_logic_vector(((2*ARG_WIDTH)-1) downto 0);
		main_done			: OUT std_logic;
		main_busy			: OUT std_logic
	);
	
end lab4_main;
--======================================================



architecture structural of lab4_main is

--Component Declarations
--======================================================
	component lab4_regA
		generic(ARG_WIDTH : integer);
		port(
			reg_clk : IN std_logic;
			reg_lat : IN std_logic;
			reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
			reg_out_pos_1 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
			reg_out_neg_1 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
			reg_out_pos_2 : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
			reg_out_neg_2 : OUT std_logic_vector((ARG_WIDTH-1) downto 0)
		);
	end component;
	
	
	
	component lab4_regB
		generic(ARG_WIDTH : integer);
		port(
	
			--standard register interfaceing pins
			shift   : IN std_logic;
			reg_clk : IN std_logic;
			reg_lat : IN std_logic;
			
			--looks like:
			--[msb_inp<2>][reg_inp<ARG_WIDTH>][traling_bit]
			msb_inp : IN std_logic_vector(1 downto 0);
			reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
			trl_inp : IN std_logic;
			
			--looks like:
			--[reg_out<ARG_WIDTH>][trailing_bit]
			reg_out : OUT std_logic_vector((ARG_WIDTH-1) downto 0);
			
			coding_bits  : OUT std_logic_vector(2 downto 0)
		);
	end component;
	
	
	
	component lab4_regC
		generic(ARG_WIDTH : integer);
		port(
			shift   : IN std_logic;
			reg_clk : IN std_logic;
			reg_lat : IN std_logic;
		
			msb_inp : IN std_logic_vector(1 downto 0);
			reg_inp : IN std_logic_vector((ARG_WIDTH-1) downto 0);
			reg_out : OUT std_logic_vector((ARG_WIDTH-1) downto 0)
		);
	end component;
	
	
	
	component lab4_regD
		generic(ARG_WIDTH : integer);
		port(
			itr_cmp	: OUT std_logic;
			reg_rst	: IN std_logic;
			reg_clk	: IN std_logic;
			reg_count: IN std_logic
		);
	end component;
	
	
	
	component lab4_recode_mux is
		generic(ARG_WIDTH : integer);
		port(
			mux_sel 				: IN std_logic_vector(2 downto 0);
			mux_inp_neg_one 	: IN std_logic_vector(((ARG_WIDTH)-1) downto 0);
			mux_inp_pos_one 	: IN std_logic_vector(((ARG_WIDTH)-1) downto 0);
			mux_inp_neg_two 	: IN std_logic_vector(((ARG_WIDTH)-1) downto 0);
			mux_inp_pos_two	: IN std_logic_vector(((ARG_WIDTH)-1) downto 0);
			
			mux_out				: OUT std_logic_vector(((ARG_WIDTH)-1) downto 0)
		);
	end component;
	
	
	
	component lab4_summation_unit is
		generic(ARG_WIDTH : integer);
		port(
			A_bus : IN std_logic_vector((ARG_WIDTH-1) downto 0);
			B_bus : IN std_logic_vector((ARG_WIDTH-1) downto 0);
		
			Ovflw : OUT std_logic;	--might not need, keep just in case for FSM part
		
			S_bus : OUT std_logic_vector((ARG_WIDTH-1) downto 0)
		);
	end component;



	component lab4_regC_gating_unit
		generic(ARG_WIDTH : integer);
		port(
			sum_select 	: IN std_logic;
			mux_input	: IN std_logic_vector((ARG_WIDTH-1) downto 0);
			mux_output	: OUT std_logic_vector((ARG_WIDTH-1) downto 0)
		);
	end component;
	
	
	
	component lab4_FSM_controller
		port(
			FSM_clk		: IN std_logic;
			FSM_rst		: IN std_logic;
			FSM_start 	: IN std_logic;
			FSM_busy		: OUT std_logic;
			FSM_done		: OUT std_logic;
			FSM_loadreg	: OUT std_logic;
			FSM_shiftreg: OUT std_logic;
			FSM_addreg	: OUT std_logic;
			FSM_count	: OUT std_logic;
			
			FSM_regD_fl : IN std_logic;
			
			FSM_rec_sel	: OUT std_logic_vector(2 downto 0);
			FSM_rec_inp : IN std_logic_vector(2 downto 0)
		);
	end component;

	
	--a generic or gate implemented as glue logic
	component lab4_or is
		port(
			inp_A : IN std_logic;
			inp_B	: IN std_logic;
			output: OUT std_logic
		);
	end component;
	
	
	--a generic not gate for use in low-active conversion
	component lab4_not is
		port(
			input : IN std_logic;
			output: OUT std_logic
		);
	end component;
--======================================================


--Signals
--======================================================
	
	
	--MUX signals
	signal mux_recode_sel	: std_logic_vector(2 downto 0);
	signal mux_sig_neg_one 	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal mux_sig_pos_one 	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal mux_sig_neg_two 	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal mux_sig_pos_two 	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal mux_output			: std_logic_vector((ARG_WIDTH-1) downto 0);
	
	
	
	--Register signals
	signal bitpair_com: std_logic_vector(1 downto 0); 	--maps the lsbs of regC to the msbs of regB for shift
	
	signal lat_regC	: std_logic;
	signal regC_inp	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal regC_out	: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal regC_lsb	: std_logic_vector(1 downto 0);
	signal itr_cmp		: std_logic;							--"iterations complete"
	
	
	
	--Summation unit signals
	signal sum_A		: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal sum_B		: std_logic_vector((ARG_WIDTH-1) downto 0);
	signal sum_ovflw	: std_logic;
	signal sum_out		: std_logic_vector((ARG_WIDTH-1) downto 0);
	
	

	--FSM signals
	signal busy			: std_logic;
	signal done			: std_logic;
	signal coding_com	: std_logic_vector(2 downto 0);
	signal loadreg		: std_logic;
	signal addreg		: std_logic;
	signal shiftreg	: std_logic;
	signal count		: std_logic;
	
	
	--External interface signals
	signal rst_inv	: std_logic;
	
--======================================================

	begin
	
--Multiplier assembly
--======================================================
	
	--Registers
	--------------------------------------------------------
	REG_A : lab4_regA	
		generic map(ARG_WIDTH => ARG_WIDTH)
		
		port map(
			reg_clk 			=> main_clk,
			reg_lat 			=> loadreg,
			reg_inp 			=> main_multiplicand,
			reg_out_pos_1 	=> mux_sig_pos_one,
			reg_out_neg_1 	=> mux_sig_neg_one,						
			reg_out_pos_2 	=> mux_sig_pos_two,
			reg_out_neg_2 	=> mux_sig_neg_two						
		);
		
	
	
	REG_B : lab4_regB
		generic map (ARG_WIDTH => ARG_WIDTH)

		port map (
	
			--standard register interfaceing pins
			shift   => shiftreg,
			reg_clk => main_clk,
			reg_lat => loadreg,
			
			--looks like:
			--[msb_inp<2>][reg_inp<ARG_WIDTH>][traling_bit]
			msb_inp => bitpair_com,
			reg_inp => main_multiplier,
			trl_inp => '0',	--FIX ME
			
			--looks like:
			--[reg_out<ARG_WIDTH>][trailing_bit] where reg_out populates upper half of product out
			reg_out => main_product((ARG_WIDTH-1) downto 0),
			
			coding_bits => coding_com
		);
			
		
		
	REG_C : lab4_regC	
		generic map(ARG_WIDTH => ARG_WIDTH)
		
		port map(
			shift		=> shiftreg,
			reg_clk	=> main_clk,
			reg_lat 	=> lat_regC,	--signal tied to an OR of loadreg and addreg
		
			msb_inp(0) 	=> sum_ovflw,
			msb_inp(1)	=> sum_ovflw,
			
			reg_inp 	=> regC_inp,
			reg_out 	=> regC_out					
		);
		
	
	--MSB of resultant product vector is regC's output
	main_product(((2*ARG_WIDTH)-1) downto ARG_WIDTH) <= regC_out;
	
	
	--FIX: moved this to the shift part only IN regC where shifts occur (regC changes frequently)
	--connect two lsb in regC to 2 msb in regB (try latching to regC_inp to avoid wait on latch->regC_out)
	--(used to be connected directly to regC's input which changed at all times)
	bitpair_com <= regC_inp(1 downto 0);
		
		
	REG_D : lab4_regD

		generic map(ARG_WIDTH => ARG_WIDTH)

		port map(
			itr_cmp	=> itr_cmp,
			reg_rst	=> loadreg,
			reg_clk	=> main_clk,
			reg_count=> count
		);
		
	--------------------------------------------------------

		
		
	--Multiplexing modules
	--------------------------------------------------------
	RECODE_MUX : lab4_recode_mux
		generic map(ARG_WIDTH => ARG_WIDTH)
		
		port map(
			mux_sel 				=> mux_recode_sel,
			mux_inp_neg_one 	=> mux_sig_neg_one,
			mux_inp_pos_one 	=> mux_sig_pos_one,
			mux_inp_neg_two 	=> mux_sig_neg_two,
			mux_inp_pos_two	=> mux_sig_pos_two,
			
			mux_out				=> mux_output
		);
		
		
		
	REGC_GATING_UNIT : lab4_regC_gating_unit
		generic map (ARG_WIDTH => ARG_WIDTH)

		port map(
			sum_select 	=> loadreg,	--NOT(loadreg) logic is internal to the unit. Modelsim did not permit
											-- the use of a not() operator in lab4_main.
			mux_input	=> sum_out,
			mux_output	=> regC_inp
		);
		
	--------------------------------------------------------
	
	
	--Summation unit (two input vectors of dimenion ARG_WIDTH bits)
	--------------------------------------------------------
	SUMMATION_UNIT : lab4_summation_unit
		generic map(ARG_WIDTH => ARG_WIDTH)
		
		port map(
			A_bus => regC_out,
			B_bus => mux_output,
			
			OVflw => sum_ovflw,
			
			S_bus => sum_out
		);
	--------------------------------------------------------
	
	
	--FSM Control Unit (Mealy type machine)
	--------------------------------------------------------
	
	FSM_controller : lab4_FSM_controller

		port map(
			FSM_rst		=> rst_inv,
			FSM_clk		=> main_clk,
			FSM_start 	=> main_start,
			FSM_busy		=> busy,
			FSM_done		=> done,
			FSM_loadreg	=> loadreg,
			FSM_shiftreg=> shiftreg,
			FSM_addreg	=> addreg,
			FSM_count	=> count,
			
			FSM_regD_fl	=> itr_cmp,
			
			FSM_rec_sel	=> mux_recode_sel,
			FSM_rec_inp => coding_com
	
		);
	
	main_busy <= busy;
	main_done <= done;
	--------------------------------------------------------
	
	
	--OR gate implemented as glue logic for (loadreg OR addreg)
	--in assigning latreg input for register C
	--------------------------------------------------------
	
	LOADREG_ADDREG_MERGER : lab4_or

		port map(
			inp_A => loadreg,
			inp_B	=> addreg,
			output=> lat_regC
		);
	
	--------------------------------------------------------
	
	
	--NOT gates implemented for ease of low-active conversion
	--------------------------------------------------------
	
	RST_INVERTER : lab4_not

		port map(
			input	=> main_rst,
			output=> rst_inv
		);
	
	--------------------------------------------------------
	
--======================================================


end structural;