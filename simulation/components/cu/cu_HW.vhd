LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.alu_types.ALL;
USE work.cu_hw_types.ALL;
USE work.cu_hw_functions.ALL;

ENTITY cu_hw IS
  PORT (
    -- cw
    -- first pipe stage outputs
    ir_latch_en      : OUT STD_LOGIC;
    npc_latch_en     : OUT STD_LOGIC;
    -- second pipe stage outputs
    reg_a_latch_en   : OUT STD_LOGIC;
    reg_b_latch_en   : OUT STD_LOGIC;
    reg_imm_latch_en : OUT STD_LOGIC;
    mux_a_sel        : OUT STD_LOGIC;
    mux_b_sel        : OUT STD_LOGIC;
    -- third pipe stage outputs
    alu_out          : OUT alu_array;
    alu_out_reg_en   : OUT STD_LOGIC;
    eq_cond          : OUT STD_LOGIC;
    jump_en          : OUT STD_LOGIC;
    -- fourth pipe stage outputs
    dram_we          : OUT STD_LOGIC;
    lmd_latch_en     : OUT STD_LOGIC;
    pc_latch_en      : OUT STD_LOGIC;
    branch_taken     : IN  STD_LOGIC;
    -- fifth pipe stage outputs
    rf_latch_en      : OUT STD_LOGIC;
    wb_mux_sel       : OUT STD_LOGIC;
    -- inputs
    opcode           : IN  opcode_array;
    func             : IN  func_array;
    clk              : IN  STD_LOGIC;
    rst              : IN  STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture with static lut
ARCHITECTURE behavioral_static OF cu_hw IS

  -- lut for control word
  SIGNAL cw_mem : cw_mem_matrix := (
    0      => cw_nop,                   -- nop
    1      => ,                         -- rtype
    2      => ,
    3      => ,
    4      => ,
    OTHERS => cw_nop                    -- instructions not defined
    );
  -- control word from lut
  SIGNAL cw               : cw_array                                    := (OTHERS => '0');
  -- split cw in stages
  CONSTANT cw1_array_size : INTEGER                                     := cw_array_size;
  SIGNAL cw1              : cw_array                                    := (OTHERS => '0');
  CONSTANT cw2_array_size : INTEGER                                     := cw1_array_size-2;
  SIGNAL cw2              : STD_LOGIC_VECTOR(cw2_array_size-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT cw3_array_size : INTEGER                                     := cw2_array_size-5;
  SIGNAL cw3              : STD_LOGIC_VECTOR(cw3_array_size-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT cw4_array_size : INTEGER                                     := cw3_array_size-3;
  SIGNAL cw4              : STD_LOGIC_VECTOR(cw4_array_size-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT cw5_array_size : INTEGER                                     := cw4_array_size-3;
  SIGNAL cw5              : STD_LOGIC_VECTOR(cw5_array_size-1 DOWNTO 0) := (OTHERS => '0');
  -- delay alu control word
  SIGNAL alu1, alu2, alu3 : alu_array                                   := (OTHERS => '0');
  -- signals to manage cw words
  SIGNAL alu              : alu_array                                   := (OTHERS => '0');  -- alu code from func

BEGIN
  -- get output from luts
  cw <= cw_mem(conv_integer(UNSIGNED(opcode)));

-- todo
  -- first pipe stage outputs
  ir_latch_en      <= cw1(cw1_array_size-1);
  npc_latch_en     <= cw1(cw1_array_size-2);
  -- second pipe stage outputs
  reg_a_latch_en   <= cw2(cw2_array_size-1);
  reg_b_latch_en   <= cw2(cw2_array_size-2);
  reg_imm_latch_en <= cw2(cw2_array_size-3);
  mux_a_sel        <= cw2(cw2_array_size-4);
  mux_b_sel        <= cw2(cw2_array_size-5);
  -- third pipe stage outputs
  alu_out          <= alu3;
  alu_out_reg_en   <= cw3(cw3_array_size-1);
  eq_cond          <= cw3(cw3_array_size-2);
  jump_en          <= cw3(cw3_array_size-3);
  -- fourth pipe stage outputs
  dram_we          <= cw4(cw4_array_size-1);
  lmd_latch_en     <= cw4(cw4_array_size-2);
  pc_latch_en      <= cw4(cw4_array_size-3);
  -- fifth pipe stage outputs
  rf_latch_en      <= cw5(cw5_array_size-1);
  wb_mux_sel       <= cw5(cw5_array_size-2);

  -- process to pipeline control words
  cw_pipe : PROCESS (clk, rst)
  BEGIN
    IF rst = '0' THEN                   -- asynchronous reset (active low)
      cw1  <= (OTHERS => '0');
      cw2  <= (OTHERS => '0');
      cw3  <= (OTHERS => '0');
      cw4  <= (OTHERS => '0');
      cw5  <= (OTHERS => '0');
      alu1 <= (OTHERS => '0');
      alu2 <= (OTHERS => '0');
      alu3 <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge
      IF branch_taken = '0' THEN
        cw1  <= cw;
        alu1 <= alu;
        cw2  <= cw1(cw2_array_size-1 DOWNTO 0);
        alu2 <= alu1;
        cw3  <= cw2(cw3_array_size-1 DOWNTO 0);
        alu3 <= alu2;
      ELSE
        cw1  <= cw_nop;
        alu1 <= alu_nop;
        cw1  <= cw_nop;
        alu2 <= alu_nop;
        cw2  <= cw_nop(cw2'LENGTH-1 DOWNTO 0);
        alu3 <= alu_nop;
        cw3  <= cw_nop(cw3'LENGTH-1 DOWNTO 0);
      END IF;
      cw4            <= cw3(cw4_array_size-1 DOWNTO 0);
      cw5_array_size <= cw4(cw5_array_size-1 DOWNTO 0);
    END IF;
  END PROCESS;

-- process to get alu control word
  alu_get_code : PROCESS (opcode, func)
  BEGIN
    CASE opcode IS
      WHEN rtype =>
        CASE func IS
          WHEN rtype_add => alu <= alu_add;
          WHEN rtype_sub => alu <= alu_sub;
          WHEN rtype_and => alu <= alu_and;
          WHEN rtype_or  => alu <= alu_or;
          WHEN OTHERS    => alu <= alu_nop;
        END CASE;
      WHEN itype_addin1 | itype_addi2  => alu <= alu_add;
      WHEN itype_subin1 | itype_subi2  => alu <= alu_sub;
      WHEN itype_andin1 | itype_andi2  => alu <= alu_and;
      WHEN itype_orin1 | itype_ori2    => alu <= alu_or;
      WHEN itype_s_reg1 | itype_s_reg2 => alu <= alu_add;
      -- when itype_s_mem1 => alu <= alu_add;
      WHEN itype_s_mem2                => alu <= alu_add;
      WHEN itype_l_mem1 | itype_l_mem2 => alu <= alu_add;
      WHEN OTHERS                      => alu <= alu_nop;
    END CASE;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- static behavioral configuration
CONFIGURATION cfg_cu_hw_behavioral OF cu_hw IS
  FOR behavioral_static
  END FOR;
END CONFIGURATION;
