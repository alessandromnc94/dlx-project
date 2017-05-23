LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE alu_types IS

  CONSTANT alu_array_size : INTEGER := 2;
  SUBTYPE alu_array IS STD_LOGIC_VECTOR(alu_array_size-1 DOWNTO 0);

  CONSTANT alu_add : alu_array := conv_std_logic_vector(0, alu_array_size);
  CONSTANT alu_sub : alu_array := conv_std_logic_vector(1, alu_array_size);
  CONSTANT alu_and : alu_array := conv_std_logic_vector(2, alu_array_size);
  CONSTANT alu_or  : alu_array := conv_std_logic_vector(3, alu_array_size);
--   constant alu_sll : alu_array := conv_std_logic_vector(4, alu_array_size);
--   constant alu_srl  : alu_array := conv_std_logic_vector(5, alu_array_size);
--   constant alu_sra  : alu_array := conv_std_logic_vector(6, alu_array_size);
--   constant alu_rol  : alu_array := conv_std_logic_vector(7, alu_array_size);
--   constant alu_ror  : alu_array := conv_std_logic_vector(8, alu_array_size);
--   constant alu_mul  : alu_array := conv_std_logic_vector(9, alu_array_size);
--   constant alu_div  : alu_array := conv_std_logic_vector(10, alu_array_size);
  CONSTANT alu_nop : alu_array := alu_add;
END PACKAGE;
