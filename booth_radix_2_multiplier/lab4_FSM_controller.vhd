--Zachary Oldberg
--ECE 3270, S 001
--Lab 4

--Description:
--	The Mealy type FSM controller tasked with coordinating multiplcation
--	sequences, step-based operations, and handing external inputs. The
--	control unit is among the only sub-systems in lab4's multiplier that
--	operates independently of the ARG_WIDTH parameter.
--
--NOTE:
--	One output flag, "done", is not output from the combinational Mealy circuitry.
--	Instead, the done flag must persist for exactly one clock cycle after completing
--	an operation, and hence, a synchronous design was better suited to accomplish this.



LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Entity
--------------------------------------------------------
entity lab4_FSM_controller is

	port(
			FSM_clk		: IN std_logic;
			FSM_rst		: IN std_logic;
			FSM_start 	: IN std_logic;
			FSM_regD_fl : IN std_logic;
			FSM_rec_inp : IN std_logic_vector(2 downto 0);


			
			FSM_busy		: OUT std_logic;
			FSM_done		: OUT std_logic;
			FSM_shiftreg: OUT std_logic;
			FSM_loadreg	: OUT std_logic;
			FSM_addreg	: OUT std_logic;
			FSM_count	: OUT std_logic;
			
			FSM_rec_sel	: OUT std_logic_vector(2 downto 0)
	
	);
	
end lab4_FSM_controller;
--------------------------------------------------------


architecture behavioral of lab4_FSM_controller is

	--handles recoding (see note toward bottom)
	constant neg_one	: std_logic_vector(2 downto 0) := "000";
	constant pos_one	: std_logic_vector(2 downto 0) := "001";			
	constant neg_two	: std_logic_vector(2 downto 0) := "010";
	constant pos_two	: std_logic_vector(2 downto 0) := "011";
	constant zero		: std_logic_vector(2 downto 0) := "111";

	TYPE CONTROLLER_STATE is (INIT, ADD, SHIFT);
	
	signal cur : CONTROLLER_STATE;		
	
	begin
	
		process(FSM_rst, FSM_clk)
		
		begin
		
			if rising_edge(FSM_clk) then
			
				--if regD is "full" (iterations complete) or FSM 
				if FSM_rst = '1' then
				
					FSM_done <= '0';
					
					cur <= INIT;
					
				elsif FSM_regD_fl = '1' then
				
					FSM_done <= '1';
					
					cur <= INIT;
					
				else
				
					case cur is
					
						when INIT =>
																		
							if FSM_start = '1' then
						
								FSM_done <= '0';
															
								cur <= ADD;
								
							else
							
								FSM_done <= '0';			
									
								cur <= INIT;
								
							end if;
						
						when ADD =>
						
							FSM_done <= '0';
						
							if FSM_rst = '0' then
								
								cur <= SHIFT;
								
							else
							
								cur <= INIT;
								
							end if;
							
						when SHIFT =>
						
							--If in SHIFT state, possibly terminating a sequence.
							--If regD is full, the destination state (INIT) will have done=1
												
							if FSM_regD_fl = '0' then
							
								FSM_done <= '0';
								cur <= ADD;
								
							else
								
								FSM_done <= '1';
								cur <= INIT;
								
							end if;
							
					end case;
					
				end if;
			
			end if; --end macro rising edge case
		
		end process;
		
		
		
		
		
		--Mealy part
		
		process(FSM_regD_fl, cur)
		
			begin
			
				case cur is
				
					when INIT =>	--INIT has two cases, it could be starting or it could be done
					
						--if FSM_regD_fl = '1' then
						
						--	FSM_done <= '1';
							
						--else
						
						--	FSM_done <= '0';
							
						--end if;
						
						--FSM_done <= FSM_regD_fl;
						
						FSM_count 	<= '0';
						FSM_addreg	<= '0';
						
						FSM_busy 	<= '0';
						FSM_shiftreg<= '0';
						FSM_loadreg	<= '1';
						
					when ADD =>
					
						FSM_count 	<= '1';
						FSM_addreg	<= '1';
						
						--FSM_done 	<= '0';
						FSM_busy 	<= '1';
						FSM_shiftreg<= '0';
						FSM_loadreg	<= '0';
						
					when SHIFT =>
					
						FSM_count 	<= '0';
						FSM_addreg	<= '0';
						
						--FSM_done 	<= '0';
						FSM_busy 	<= '1';
						FSM_shiftreg<= '1';
						FSM_loadreg	<= '0';
						
					end case;
					
			end process;
					
			
			--This part isn't really state machine dependent but the prompt had arrows
			--suggesting that it was present in the control unit
			
			with FSM_rec_inp select
			
				FSM_rec_sel <=	zero		when "000",
									pos_one	when "001",
									pos_one	when "010",
									pos_two	when "011",
									neg_two	when "100",
									neg_one	when "101",
									neg_one	when "110",
									zero		when others;
		
		
		
end behavioral;