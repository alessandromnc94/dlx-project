LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE work.cu_hw_types.ALL;

-- wrong testbench

ENTITY cu_hw_tb IS
END ENTITY;

ARCHITECTURE test OF cu_hw_tb IS
  COMPONENT cu_hw IS
    PORT (
      -- first pipe stage outputs
      en1     : OUT STD_LOGIC;  -- enables the register file and the pipeline registers
      rf1     : OUT STD_LOGIC;  -- enables the read port 1 of the register file
      rf2     : OUT STD_LOGIC;  -- enables the read port 2 of the register file
      -- second pipe stage outputs
      en2     : OUT STD_LOGIC;          -- enables the pipe registers
      s1      : OUT STD_LOGIC;  -- input selection of the first multiplexer
      s2      : OUT STD_LOGIC;  -- input selection of the second multiplexer
      -- alu1   : out std_logic;           -- alu control bit
      -- alu2   : out std_logic;           -- alu control bit
      alu_out : OUT alu_array;          -- alu control bits
      -- third pipe stage outputs
      en3     : OUT STD_LOGIC;  -- enables the memory and the pipeline registers
      rm      : OUT STD_LOGIC;          -- enables the read-out of the memory
      wm      : OUT STD_LOGIC;          -- enables the write-in of the memory
      wf1     : OUT STD_LOGIC;  -- enables the write port of the register file
      s3      : OUT STD_LOGIC;          -- input selection of the multiplexer
      -- inputs
      opcode  : IN  opcode_array;
      func    : IN  func_array;
      clk     : IN  STD_LOGIC;          -- clock
      rst     : IN  STD_LOGIC           -- reset:active-low
      );                                -- register file write enable
  END COMPONENT;

  CONSTANT clk_period     : TIME      := 4 NS;
  CONSTANT test_nop_delay : TIME      := 0 * clk_period;
  SIGNAL clk_period_s     : TIME      := clk_period;
  SIGNAL clk_t, rst_t     : STD_LOGIC := '0';
  SIGNAL opc_t            : opcode_array;
  SIGNAL func_t           : func_array;

  SIGNAL en1_t, rf1_t, rf2_t               : STD_LOGIC;
  SIGNAL en2_t, s1_t, s2_t, alu1_t, alu2_t : STD_LOGIC;
  SIGNAL alu_out_t                         : alu_array;
  SIGNAL en3_t, rm_t, wm_t, wf1_t, s3_t    : STD_LOGIC;

  SIGNAL opname : STRING(1 TO 14);  --used only to indicate during simulation current

BEGIN
  clk_t <= NOT clk_t AFTER clk_period/2;

  dut : cu_hw PORT MAP(
    en1 => en1_t,
    rf1 => rf1_t,
    rf2 => rf2_t,
    en2 => en2_t,
    s1  => s1_t,
    s2  => s2_t,
    alu_out_t,
    en3_t,
    rm_t,
    wm_t,
    wf1_t,
    s3_t,
    opc_t,
    func_t,
    clk_t,
    rst_t);

  test_proc : PROCESS
  BEGIN
    opc_t  <= (OTHERS => '0');
    func_t <= (OTHERS => '0');
    rst_t  <= '0';
    WAIT FOR clk_period;

    rst_t  <= '1';
    opc_t  <= rtype;
    func_t <= rtype_add;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t  <= rtype;
    func_t <= rtype_sub;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t  <= rtype;
    func_t <= rtype_and_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t  <= rtype;
    func_t <= rtype_or_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    func_t <= (OTHERS => '0');
    opc_t  <= itype_addin1;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_subin1;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_andin1_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_orin1_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_addi2;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_subi2;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_andi2_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_ori2_op;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_mov;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_s_reg1;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    --opc_t <= itype_s_mem1;
    --wait for clk_period;

    -- opc_t <= nop;
    -- func_t <= (others => '0');
    -- wait for test_nop_delay;

    opc_t <= itype_l_mem1;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_s_reg2;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_s_mem2;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t <= itype_l_mem2;
    WAIT FOR clk_period;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR test_nop_delay;

    opc_t  <= nop;
    func_t <= (OTHERS => '0');
    WAIT FOR 3 * clk_period;

    ASSERT FALSE REPORT "testbench finished" SEVERITY FAILURE;
    WAIT;

  END PROCESS;

  print : PROCESS(opc_t, func_t)
  BEGIN
    CASE opc_t IS
      WHEN rtype =>
        CASE func_t IS
          WHEN rtype_add    => opname <= "     rtype_add";
          WHEN rtype_sub    => opname <= "     rtype_sub";
          WHEN rtype_and_op => opname <= "  rtype_and_op";
          WHEN rtype_or_op  => opname <= "   rtype_or_op";
          WHEN OTHERS       => opname <= "           nop";
        END CASE;
      WHEN itype_addin1    => opname <= "   itype_addin1";
      WHEN itype_subin1    => opname <= "   itype_subin1";
      WHEN itype_andin1_op => opname <= "itype_andin1_op";
      WHEN itype_orin1_op  => opname <= " itype_orin1_op";
      WHEN itype_addi2     => opname <= "   itype_addi2";
      WHEN itype_subi2     => opname <= "   itype_subi2";
      WHEN itype_andi2_op  => opname <= "itype_andi2_op";
      WHEN itype_ori2_op   => opname <= " itype_ori2_op";
      WHEN itype_mov       => opname <= "     itype_mov";
      WHEN itype_s_reg1    => opname <= "  itype_s_reg1";
      -- when itype_s_mem1        => opname <= "  itype_s_mem1";
      WHEN itype_l_mem1    => opname <= "  itype_l_mem1";
      WHEN itype_s_reg2    => opname <= "  itype_s_reg2";
      WHEN itype_s_mem2    => opname <= "  itype_s_mem2";
      WHEN itype_l_mem2    => opname <= "  itype_l_mem2";
      WHEN OTHERS          => opname <= "           nop";
    END CASE;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- dynamic configuration
CONFIGURATION cfg_cu_hw_tb_dynamic OF cu_hw_tb IS
  FOR test
    FOR dut : cu_hw
      USE CONFIGURATION work.cfg_cu_hw_behavioral_dynamic;
    END FOR;
  END FOR;
END CONFIGURATION;

-- static configuration
CONFIGURATION cfg_cu_hw_tb_static OF cu_hw_tb IS
  FOR test
    FOR dut : cu_hw
      USE CONFIGURATION work.cfg_cu_hw_behavioral_static;
    END FOR;
  END FOR;
END CONFIGURATION;
