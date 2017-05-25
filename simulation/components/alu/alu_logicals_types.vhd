LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

PACKAGE alu_logicals_types IS
  CONSTANT alu_logicals_array_size : INTEGER := 4;
  SUBTYPE alu_logicals_array IS STD_LOGIC_VECTOR(alu_logicals_array_size-1 DOWNTO 0)

    CONSTANT alu_logicals_and : alu_logicals_array := "0001";
  CONSTANT alu_logicals_nand : alu_logicals_array := "1110";
  CONSTANT alu_logicals_or   : alu_logicals_array := "0111";
  CONSTANT alu_logicals_nor  : alu_logicals_array := "1000";
  CONSTANT alu_logicals_xor  : alu_logicals_array := "0110";
  CONSTANT alu_logicals_xnor : alu_logicals_array := "1001";

END PACKAGE;
