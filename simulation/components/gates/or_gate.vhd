LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_gate IS
  PORT (
    in_1  : IN  STD_LOGIC;
    in_2  : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF or_gate IS
BEGIN
  out_s <= in_1 OR in_2;
END ARCHITECTURE;

CONFIGURATION cfg_or_gate_behavioral OF or_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
