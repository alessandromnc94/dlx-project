LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

PACKAGE logicals_types IS
  CONSTANT logicals_array_size : INTEGER := 4;
  SUBTYPE logicals_array IS STD_LOGIC_VECTOR(logicals_array_size-1 DOWNTO 0)

    CONSTANT logicals_and : logicals_array := "0001";
  CONSTANT logicals_nand : logicals_array := "1110";
  CONSTANT logicals_or   : logicals_array := "0111";
  CONSTANT logicals_nor  : logicals_array := "1000";
  CONSTANT logicals_xor  : logicals_array := "0110";
  CONSTANT logicals_xnor : logicals_array := "1001";

END PACKAGE;
