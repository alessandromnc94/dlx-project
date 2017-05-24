LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_gate IS
  PORT (
    i1 : IN  STD_LOGIC;
    i2 : IN  STD_LOGIC;
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF or_gate IS
BEGIN
  o <= i1 OR i2;
END ARCHITECTURE;

CONFIGURATION cfg_or_gate_behavioral OF or_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
