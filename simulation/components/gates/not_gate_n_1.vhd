LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate_n_1 IS
  GENERIC (n : INTEGER := 1);
  PORT (
    i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    o : STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF not_gate_n_1 IS
BEGIN
  o <= NOT i1;
END ARCHITECTURE;

CONFIGURATION cfg_not_gate_n_1_behavioral OF not_gate_n_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
