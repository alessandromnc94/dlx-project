LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nand_gate_n IS
  GENERIC (
    n : INTEGER := 3
    );
  PORT (
    i : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nand_gate_n IS
BEGIN
  o <= NAND i;
END ARCHITECTURE;

CONFIGURATION cfg_nand_gate_n_behavioral OF nand_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
