LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nor_gate_n IS
  GENERIC (
    n : INTEGER := 3
    );
  PORT (
    i : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nor_gate_n IS
BEGIN
  o <= NOR i;
END ARCHITECTURE;

CONFIGURATION cfg_nor_gate_n_behavioral OF nor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
