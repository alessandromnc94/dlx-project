LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xnor_gate_n IS
  generic (
    n : integer := 3
  );
  PORT (
    i : IN  STD_LOGIC_vector(n-1 downto 0);
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF xnor_gate_n IS
BEGIN
  o <= xnor i;
END ARCHITECTURE;

CONFIGURATION cfg_xnor_gate_n_behavioral OF xnor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
