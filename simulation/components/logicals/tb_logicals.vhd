LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.logicals_types.ALL;

ENTITY tb_logicals IS
END ENTITY;

ARCHITECTURE behavioral OF tb_logicals IS
  CONSTANT n : INTEGER := 4;
  COMPONENT logicals_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      logic : IN  logicals_array;
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL in_1, in_2, out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL logic             : logicals_array;
BEGIN

  dut : logicals_n GENERIC MAP (
    n => n
    ) PORT MAP (
      in_1  => in_1,
      in_2  => in_2,
      logic => logic,
      out_s => out_s
      );

  PROCESS
  BEGIN

    in_1 <= "1100";
    in_2 <= "1010";

    logic <= logicals_and;
    WAIT FOR 100 PS;
    logic <= logicals_nand;
    WAIT FOR 100 PS;
    logic <= logicals_or;
    WAIT FOR 100 PS;
    logic <= logicals_nor;
    WAIT FOR 100 PS;
    logic <= logicals_xor;
    WAIT FOR 100 PS;
    logic <= logicals_xnor;
    WAIT FOR 100 PS;

    ASSERT FALSE REPORT "Testbench finished" SEVERITY FAILURE;
  END PROCESS;

END ARCHITECTURE;

CONFIGURATION cfg_tb_logicals_behavioral OF tb_logicals IS
  FOR behavioral
    FOR dut : logicals_n USE CONFIGURATION work.cfg_logicals_n_structural_1;
    END FOR;
  END FOR;
END CONFIGURATION;
