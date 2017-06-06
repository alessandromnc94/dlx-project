LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE alu_types IS

  CONSTANT alu_array_size : INTEGER := 11;
  SUBTYPE alu_array IS STD_LOGIC_VECTOR(alu_array_size-1 DOWNTO 0);

  -- type alu_operation is (
  --   alu_nop,
  --   alu_add, alu_sub, alu_mul, alu_div,
  --   alu_sll, alu_srl, alu_sla, alu_sra, alu_rol, alu_ror,
  --   alu_and, alu_nand, alu_or, alu_nor, alu_xor, alu_xnor,
  --   alu_comp_eq, alu_comp_ge, alu_comp_lo, alu_com
  -- );

  CONSTANT alu_add       : alu_array := conv_std_logic_vector(0, alu_array_size);
  CONSTANT alu_sub       : alu_array := conv_std_logic_vector(1, alu_array_size);
  CONSTANT alu_and       : alu_array := conv_std_logic_vector(2, alu_array_size);
  CONSTANT alu_nand      : alu_array := conv_std_logic_vector(3, alu_array_size);
  CONSTANT alu_or        : alu_array := conv_std_logic_vector(4, alu_array_size);
  CONSTANT alu_nor       : alu_array := conv_std_logic_vector(5, alu_array_size);
  CONSTANT alu_xor       : alu_array := conv_std_logic_vector(6, alu_array_size);
  CONSTANT alu_xnor      : alu_array := conv_std_logic_vector(7, alu_array_size);
  CONSTANT alu_sll       : alu_array := conv_std_logic_vector(8, alu_array_size);
  CONSTANT alu_srl       : alu_array := conv_std_logic_vector(9, alu_array_size);
  CONSTANT alu_sla       : alu_array := conv_std_logic_vector(10, alu_array_size);
  CONSTANT alu_sra       : alu_array := conv_std_logic_vector(11, alu_array_size);
  CONSTANT alu_rol       : alu_array := conv_std_logic_vector(12, alu_array_size);
  CONSTANT alu_ror       : alu_array := conv_std_logic_vector(13, alu_array_size);
  CONSTANT alu_comp_eq   : alu_array := conv_std_logic_vector(14, alu_array_size);
  CONSTANT alu_comp_gr   : alu_array := conv_std_logic_vector(15, alu_array_size);
  CONSTANT alu_comp_lo   : alu_array := conv_std_logic_vector(16, alu_array_size);
  CONSTANT alu_comp_ge   : alu_array := conv_std_logic_vector(17, alu_array_size);
  CONSTANT alu_comp_le   : alu_array := conv_std_logic_vector(18, alu_array_size);
  CONSTANT alu_comp_ne   : alu_array := conv_std_logic_vector(19, alu_array_size);
  CONSTANT alu_comp_zero : alu_array := conv_std_logic_vector(20, alu_array_size);
  CONSTANT alu_mul       : alu_array := conv_std_logic_vector(21, alu_array_size);
  CONSTANT alu_div       : alu_array := conv_std_logic_vector(22, alu_array_size);

  CONSTANT alu_nop : alu_array := alu_add;
END PACKAGE;
