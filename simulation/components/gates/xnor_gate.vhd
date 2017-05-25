LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xnor_gate IS
  PORT (
    i1 : IN  STD_LOGIC;
    i2 : IN  STD_LOGIC;
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF xnor_gate IS
BEGIN
  o <= i1 XNOR i2;
END ARCHITECTURE;

CONFIGURATION cfg_xnor_gate_behavioral OF xnor_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
