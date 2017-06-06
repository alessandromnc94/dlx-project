LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_gate IS
  PORT (
    in_1  : IN  STD_LOGIC;
    in_2  : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF xor_gate IS
BEGIN
  out_s <= in_1 XOR in_2;
END ARCHITECTURE;

CONFIGURATION cfg_xor_gate_behavioral OF xor_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
