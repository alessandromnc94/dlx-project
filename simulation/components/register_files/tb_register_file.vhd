LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_register_file IS
END ENTITY;

ARCHITECTURE testbench OF tb_register_file IS

  SIGNAL clk     : STD_LOGIC := '0';
  SIGNAL reset   : STD_LOGIC;
  SIGNAL enable  : STD_LOGIC;
  SIGNAL rd1     : STD_LOGIC;
  SIGNAL rd2     : STD_LOGIC;
  SIGNAL wr      : STD_LOGIC;
  SIGNAL add_wr  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL add_rd1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL add_rd2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL datain  : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL out1    : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL out2    : STD_LOGIC_VECTOR(63 DOWNTO 0);

  COMPONENT register_file
    PORT (
      clk     : IN  STD_LOGIC;
      reset   : IN  STD_LOGIC;
      enable  : IN  STD_LOGIC;
      rd1     : IN  STD_LOGIC;
      rd2     : IN  STD_LOGIC;
      wr      : IN  STD_LOGIC;
      add_wr  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      add_rd1 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      add_rd2 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      datain  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
      out1    : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      out2    : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
      );
  END COMPONENT;

BEGIN

  rg : register_file
    PORT MAP (clk, reset, enable, rd1, rd2, wr, add_wr, add_rd1, add_rd2, datain, out1, out2);
  reset   <= '1', '0'                         AFTER 5 NS;
  enable  <= '0', '1'                         AFTER 3 NS, '0' AFTER 10 NS, '1' AFTER 15 NS;
  wr      <= '0', '1'                         AFTER 6 NS, '0' AFTER 7 NS, '1' AFTER 10 NS, '0' AFTER 20 NS;
  rd1     <= '1', '0'                         AFTER 5 NS, '1' AFTER 13 NS, '0' AFTER 20 NS;
  rd2     <= '0', '1'                         AFTER 17 NS;
  add_wr  <= "10110", "01000"                 AFTER 9 NS;
  add_rd1 <= "10110", "01000"                 AFTER 9 NS;
  add_rd2 <= "11100", "01000"                 AFTER 9 NS;
  datain  <= (OTHERS => '0'), (OTHERS => '1') AFTER 8 NS;

  pclock : PROCESS(clk)
  BEGIN
    clk <= NOT(clk) AFTER 0.5 NS;
  END PROCESS;
END ARCHITECTURE;

---
CONFIGURATION cfg_tb_register_file_behavioral OF tb_register_file IS
  FOR testbench
    FOR rg : register_file
      USE CONFIGURATION work.cfg_register_file_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
