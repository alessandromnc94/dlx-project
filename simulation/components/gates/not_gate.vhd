LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate IS
  PORT (
    i : IN  STD_LOGIC;
    o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF not_gate IS
BEGIN
  o <= NOT i;
END ARCHITECTURE;

CONFIGURATION cfg_not_gate_behavioral OF not_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
