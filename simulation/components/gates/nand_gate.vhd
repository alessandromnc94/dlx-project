LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nand_gate IS
  PORT (
    i1 : IN  STD_LOGIC;
    i2 : IN  STD_LOGIC;
    o  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nand_gate IS
BEGIN
  o <= i1 NAND i2;
END ARCHITECTURE;

CONFIGURATION cfg_nand_gate_behavioral OF nand_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
