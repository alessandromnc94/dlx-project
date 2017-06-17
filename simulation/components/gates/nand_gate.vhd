LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nand_gate IS
  PORT (
    in_1  : IN  STD_LOGIC;
    in_2  : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nand_gate IS
BEGIN
  out_s <= in_1 NAND in_2;
END ARCHITECTURE;

CONFIGURATION cfg_nand_gate_behavioral OF nand_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
