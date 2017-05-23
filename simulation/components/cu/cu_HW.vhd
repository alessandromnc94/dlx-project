LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.cu_hw_types.ALL;
USE work.cu_hw_functions.ALL;

ENTITY cu_hw IS
  PORT (
    -- cw
    -- first pipe stage outputs
    en1     : OUT STD_LOGIC;  -- enables the register file and the pipeline registers
    rf1     : OUT STD_LOGIC;  -- enables the read port 1 of the register file
    rf2     : OUT STD_LOGIC;  -- enables the read port 2 of the register file
    -- second pipe stage outputs
    en2     : OUT STD_LOGIC;            -- enables the pipe registers
    s1      : OUT STD_LOGIC;  -- input selection of the first multiplexer
    s2      : OUT STD_LOGIC;  -- input selection of the second multiplexer
    -- alu1 : out std_logic;               -- alu control bit
    -- alu2 : out std_logic;               -- alu control bit
    alu_out : OUT alu_array;            -- alu control bits
    -- third pipe stage outputs
    en3     : OUT STD_LOGIC;  -- enables the memory and the pipeline registers
    rm      : OUT STD_LOGIC;            -- enables the read-out of the memory
    wm      : OUT STD_LOGIC;            -- enables the write-in of the memory
    wf1     : OUT STD_LOGIC;  -- enables the write port of the register file
    s3      : OUT STD_LOGIC;            -- input selection of the multiplexer
    -- inputs
    opcode  : IN  opcode_array;
    func    : IN  func_array;
    clk     : IN  STD_LOGIC;
    rst     : IN  STD_LOGIC
    );                                  -- active low
END cu_hw;

ARCHITECTURE behavioral OF cu_hw IS

  -- lut for control word (+ rtype bit)
  SIGNAL cw_mem           : cw_mem_matrix                                                   := initialize_cw_mem;
  -- lut for alu control word (+ valid bit)
  -- signals for cw_mem
  SIGNAL cw_mem_out       : cw_mem_array;
  -- control word
  SIGNAL cw_itype         : cw_array                                                        := (OTHERS => '0');
  SIGNAL cw_rtype         : cw_array                                                        := (OTHERS => '0');
  SIGNAL cw               : cw_array                                                        := (OTHERS => '0');
  -- split cw in stages
  SIGNAL cw1              : cw_array                                                        := (OTHERS => '0');
  SIGNAL cw2              : STD_LOGIC_VECTOR(cw_array_size-1-3 DOWNTO 0)                    := (OTHERS => '0');
  SIGNAL cw3              : STD_LOGIC_VECTOR(cw_array_size-1-3-(3+alu_array_size) DOWNTO 0) := (OTHERS => '0');
  -- signals to manage cw words
  SIGNAL rtype, alu_valid : STD_LOGIC                                                       := '0';  -- selectors for mux
  SIGNAL alu              : alu_array                                                       := (OTHERS => '0');  -- alu code from func

BEGIN
  -- get output from luts
  cw_mem_out <= cw_mem(conv_integer(UNSIGNED(opcode)));
  -- split previous signals
  -- split cw_mem_out in cw_itype and rtype
  cw_itype   <= cw_mem_out(cw_mem_array_size-1 DOWNTO 1);
  rtype      <= cw_mem_out(0);
  -- split alu_mem_out in alu and alu_valid
  alu        <= func(alu_array_size-1 DOWNTO 0);
  -- get correct rtype cw by replacing alu control bits
  cw_rtype   <= cw_mem_out(cw_mem_array_size-1 DOWNTO cw_mem_array_size-6) & alu & cw_mem_out(cw_mem_array_size-6-alu_array_size-1 DOWNTO 1);

  -- select the correct control word (mux 2 input)
  cw <= cw_itype WHEN rtype = '0' ELSE  -- instr is itype (nop is all '0's op_code)
        cw_rtype;                       -- instr is rtype

  -- first stage
  rf1     <= cw1(cw_array_size-1);
  rf2     <= cw1(cw_array_size-2);
  en1     <= cw1(cw_array_size-3);
  -- second stage
  s1      <= cw2(cw_array_size-3-1);
  s2      <= cw2(cw_array_size-3-2);
  en2     <= cw2(cw_array_size-3-3);
  alu_out <= cw2(cw_array_size-3-4 DOWNTO cw_array_size-3-(4+alu_array_size-1));
  -- third stage
  rm      <= cw3(cw_array_size-3-(4+alu_array_size-1)-1);
  wm      <= cw3(cw_array_size-3-(4+alu_array_size-1)-2);
  wf1     <= cw3(cw_array_size-3-(4+alu_array_size-1)-3);
  en3     <= cw3(cw_array_size-3-(4+alu_array_size-1)-4);
  s3      <= cw3(cw_array_size-3-(4+alu_array_size-1)-5);

  -- process to pipeline control words
  cw_pipe : PROCESS (clk, rst)
  BEGIN  -- process clk
    IF rst = '0' THEN                   -- asynchronous reset (active low)
      cw1 <= (OTHERS => '0');
      cw2 <= (OTHERS => '0');
      cw3 <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(cw2'LENGTH-1 DOWNTO 0);
      cw3 <= cw2(cw3'LENGTH-1 DOWNTO 0);
    END IF;
  END PROCESS cw_pipe;
END ARCHITECTURE;

CONFIGURATION cu_hw_cfg OF cu_hw IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
