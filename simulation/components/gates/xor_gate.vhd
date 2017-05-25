LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_gate IS
  PORT (
    i1 : IN  STD_LOGIC;
    i2 : IN  STD_LOGIC;
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF xor_gate IS
BEGIN
  o <= i1 XOR i2;
END ARCHITECTURE;

CONFIGURATION cfg_xor_gate_behavioral OF xor_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
