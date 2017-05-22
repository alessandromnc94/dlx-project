LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_gate_n_1 IS
  GENERIC (n : INTEGER := 1);
  PORT (
    i1 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i2 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    o  : STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF xor_gate_n_1 IS
BEGIN
  o <= i1 XOR i2;
END ARCHITECTURE;

CONFIGURATION cfg_xor_gate_n_1_behavioral OF xor_gate_n_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
