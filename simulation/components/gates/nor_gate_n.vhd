LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nor_gate_n IS
  generic (
    n : integer := 3
  );
  PORT (
    i : IN  STD_LOGIC_vector(n-1 downto 0);
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nor_gate_n IS
BEGIN
  o <= nor i;
END ARCHITECTURE;

CONFIGURATION cfg_nor_gate_n_behavioral OF nor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
