LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY and_gate IS
  PORT (
    i1 : IN  STD_LOGIC;
    i2 : IN  STD_LOGIC;
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF and_gate IS
BEGIN
  o <= i1 AND i2;
END ARCHITECTURE;

CONFIGURATION cfg_and_gate_behavioral OF and_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
