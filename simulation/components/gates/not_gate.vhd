LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate IS
  PORT (
    in_s  : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF not_gate IS
BEGIN
  out_s <= NOT in_s;
END ARCHITECTURE;

CONFIGURATION cfg_not_gate_behavioral OF not_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
