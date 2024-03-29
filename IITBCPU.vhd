library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity IITBCPU is
	port(wr_addr,instd_towr:in std_logic_vector(15 downto 0);
		clk,rst,mem_write_2:in std_logic;
		state: out std_logic_vector(4 downto 0));
--				output_state: out std_logic_vector(4 downto 0)
end entity;

architecture IITBCPUArc of IITBCPU is
	signal mem_write,c_flag_d2,c_flag_d1,c_flag_write,z_flag_d2,z_flag_d1,z_flag_write,flag_op,flag_carry,flag_zero,flag_equal,rf_write,t1_write,t2_write,t3_write,t4_write,instr_write:std_logic;
	signal mem_a1,mem_d1,mem_d2,instr_d1,instr_d2,t1_d1,t1_d2,t2_d1,t2_d2,t3_d1,t3_d2,t4_d1,t4_d2,alu_a,alu_b,alu_c,rf_d1,rf_d2,rf_d3,sig_pc:std_logic_vector(15 downto 0);
	signal rf_a1,rf_a2,rf_a3:std_logic_vector(2 downto 0);
	signal memory_write:std_logic;
	signal memory_address:std_logic_vector(15 downto 0);
	signal memory_input:std_logic_vector(15 downto 0);

	component memory is
	port(	mem_write:in std_logic;
			mem_a1:in std_logic_vector(15 downto 0);
			mem_d1:in std_logic_vector(15 downto 0);
			mem_d2: out std_logic_vector(15 downto 0);
			clk:in std_logic);
	end component;
	component flagreg is
		port(
		flag_d2: out std_logic;
		flag_d1: in  std_logic;
		flag_write,clk: in  std_logic);
	end component;
	component temp16reg is
		port(
		temp16_d2: out std_logic_vector(15 downto 0);
		temp16_d1: in  std_logic_vector(15 downto 0);
		temp16_write,clk: in  std_logic);
	end component;
	component ALU is
	port(alu_a:in std_logic_vector(15 downto 0);
			alu_b:in std_logic_vector(15 downto 0);
			flag_op:in std_logic;
			alu_c:out std_logic_vector(15 downto 0);
			flag_carry: out std_logic;
			flag_zero: out std_logic;
			flag_equal: out std_logic);
	end component;
	component RF is
	port(	rf_write:in std_logic;
			rf_a1:in std_logic_vector(2 downto 0);
			rf_a2:in std_logic_vector(2 downto 0);
			rf_a3:in std_logic_vector(2 downto 0);
			rf_d1:out std_logic_vector(15 downto 0);
			rf_d2:out std_logic_vector(15 downto 0);
			rf_d3:in std_logic_vector(15 downto 0);
			pc: out std_logic_vector(15 downto 0);
			clk:in std_logic);
	end component;
	component FSM is
	port(clk:in std_logic;
		c_flag_d2,z_flag_d2,flag_carry,flag_zero,flag_equal: in std_logic;
		mem_write,c_flag_d1,c_flag_write,z_flag_d1,z_flag_write,flag_op,rf_write,t1_write,t2_write,t3_write,t4_write,instr_write:out std_logic;
		mem_d2,instr_d2,t1_d2,t2_d2,t3_d2,t4_d2,alu_c,rf_d1,rf_d2,sig_pc:in std_logic_vector(15 downto 0);
		mem_a1,mem_d1,instr_d1,t1_d1,t2_d1,t3_d1,t4_d1,alu_a,alu_b,rf_d3:out std_logic_vector(15 downto 0);
		rf_a1,rf_a2,rf_a3:out std_logic_vector(2 downto 0);
		state:out std_logic_vector(4 downto 0));
	end component;

begin
	data_memory: memory
		port map(mem_write=>memory_write,mem_a1=>memory_address,mem_d1=>memory_input,mem_d2=>mem_d2,clk=>clk);
	register_file: RF
		port map(rf_write=>rf_write,rf_a1=>rf_a1,rf_a2=>rf_a2,rf_a3=>rf_a3,rf_d1=>rf_d1,rf_d2=>rf_d2,rf_d3=>rf_d3,pc=>sig_pc,clk=>clk);
	alu_instance: ALU
		port map(alu_a=>alu_a,alu_b=>alu_b,alu_c=>alu_c,flag_op=>flag_op,flag_carry=>flag_carry,flag_equal=>flag_equal,flag_zero=>flag_zero);
	carry: flagreg
		port map(flag_d2=>c_flag_d2,flag_d1=>c_flag_d1,flag_write=>c_flag_write,clk=>clk);
	zero: flagreg
		port map(flag_d2=>z_flag_d2,flag_d1=>z_flag_d1,flag_write=>z_flag_write,clk=>clk);
	instr: temp16reg
		port map(temp16_d2=>instr_d2,temp16_d1=>instr_d1,temp16_write=>instr_write,clk=>clk);
	t1: temp16reg
		port map(temp16_d2=>t1_d2,temp16_d1=>t1_d1,temp16_write=>t1_write,clk=>clk);
	t2: temp16reg
		port map(temp16_d2=>t2_d2,temp16_d1=>t2_d1,temp16_write=>t2_write,clk=>clk);
	t3: temp16reg
		port map(temp16_d2=>t3_d2,temp16_d1=>t3_d1,temp16_write=>t3_write,clk=>clk);
	t4: temp16reg
		port map(temp16_d2=>t4_d2,temp16_d1=>t4_d1,temp16_write=>t4_write,clk=>clk);  

---sensitivity list of the controller will contain all the output ports of all the components above other than the controller itself
	fsm_instance: FSM
		port map(mem_write=>mem_write,mem_a1=>mem_a1,mem_d1=>mem_d1,mem_d2=>mem_d2,clk=>clk,rf_write=>rf_write,rf_a1=>rf_a1,rf_a2=>rf_a2,rf_a3=>rf_a3,rf_d1=>rf_d1,rf_d2=>rf_d2,rf_d3=>rf_d3,sig_pc=>sig_pc,
					alu_a=>alu_a,alu_b=>alu_b,alu_c=>alu_c,flag_op=>flag_op,flag_carry=>flag_carry,flag_equal=>flag_equal,flag_zero=>flag_zero,
					c_flag_d2=>c_flag_d2,c_flag_d1=>c_flag_d1,c_flag_write=>c_flag_write,
					z_flag_d2=>z_flag_d2,z_flag_d1=>z_flag_d1,z_flag_write=>z_flag_write,
					instr_d2=>instr_d2,instr_d1=>instr_d1,instr_write=>instr_write,
					t1_d2=>t1_d2,t1_d1=>t1_d1,t1_write=>t1_write,
					t2_d2=>t2_d2,t2_d1=>t2_d1,t2_write=>t2_write,
					t3_d2=>t3_d2,t3_d1=>t3_d1,t3_write=>t3_write,
               t4_d2=>t4_d2,t4_d1=>t4_d1,t4_write=>t4_write,
					state=>state);
	
	memory_write<=mem_write_2 or mem_write;
	
	memory_address(0)<=(wr_addr(0) and mem_write_2) or (not mem_write_2 and mem_a1(0));
	memory_address(1)<=(wr_addr(1) and mem_write_2) or (not mem_write_2 and mem_a1(1));
	memory_address(2)<=(wr_addr(2) and mem_write_2) or (not mem_write_2 and mem_a1(2));
	memory_address(3)<=(wr_addr(3) and mem_write_2) or (not mem_write_2 and mem_a1(3));
	memory_address(4)<=(wr_addr(4) and mem_write_2) or (not mem_write_2 and mem_a1(4));
	memory_address(5)<=(wr_addr(5) and mem_write_2) or (not mem_write_2 and mem_a1(5));
	memory_address(6)<=(wr_addr(6) and mem_write_2) or (not mem_write_2 and mem_a1(6));
	memory_address(7)<=(wr_addr(7) and mem_write_2) or (not mem_write_2 and mem_a1(7));
	memory_address(8)<=(wr_addr(8) and mem_write_2) or (not mem_write_2 and mem_a1(8));
	memory_address(9)<=(wr_addr(9) and mem_write_2) or (not mem_write_2 and mem_a1(9));
	memory_address(10)<=(wr_addr(10) and mem_write_2) or (not mem_write_2 and mem_a1(10));
	memory_address(11)<=(wr_addr(11) and mem_write_2) or (not mem_write_2 and mem_a1(11));
	memory_address(12)<=(wr_addr(12) and mem_write_2) or (not mem_write_2 and mem_a1(12));
	memory_address(13)<=(wr_addr(13) and mem_write_2) or (not mem_write_2 and mem_a1(13));
	memory_address(14)<=(wr_addr(14) and mem_write_2) or (not mem_write_2 and mem_a1(14));
	memory_address(15)<=(wr_addr(15) and mem_write_2) or (not mem_write_2 and mem_a1(15));
	
	
	memory_input(0)<=(instd_towr(0) and mem_write_2) or (not mem_write_2 and mem_d1(0));
	memory_input(1)<=(instd_towr(1) and mem_write_2) or (not mem_write_2 and mem_d1(1));
	memory_input(2)<=(instd_towr(2) and mem_write_2) or (not mem_write_2 and mem_d1(2));
	memory_input(3)<=(instd_towr(3) and mem_write_2) or (not mem_write_2 and mem_d1(3));
	memory_input(4)<=(instd_towr(4) and mem_write_2) or (not mem_write_2 and mem_d1(4));
	memory_input(5)<=(instd_towr(5) and mem_write_2) or (not mem_write_2 and mem_d1(5));
	memory_input(6)<=(instd_towr(6) and mem_write_2) or (not mem_write_2 and mem_d1(6));
	memory_input(7)<=(instd_towr(7) and mem_write_2) or (not mem_write_2 and mem_d1(7));
	memory_input(8)<=(instd_towr(8) and mem_write_2) or (not mem_write_2 and mem_d1(8));
	memory_input(9)<=(instd_towr(9) and mem_write_2) or (not mem_write_2 and mem_d1(9));
	memory_input(10)<=(instd_towr(10) and mem_write_2) or (not mem_write_2 and mem_d1(10));
	memory_input(11)<=(instd_towr(11) and mem_write_2) or (not mem_write_2 and mem_d1(11));
	memory_input(12)<=(instd_towr(12) and mem_write_2) or (not mem_write_2 and mem_d1(12));
	memory_input(13)<=(instd_towr(13) and mem_write_2) or (not mem_write_2 and mem_d1(13));
	memory_input(14)<=(instd_towr(14) and mem_write_2) or (not mem_write_2 and mem_d1(14));
	memory_input(15)<=(instd_towr(15) and mem_write_2) or (not mem_write_2 and mem_d1(15));

end architecture;