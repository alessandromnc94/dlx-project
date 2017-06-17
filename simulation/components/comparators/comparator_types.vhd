PACKAGE comparator_type IS

  CONSTANT comparator_array_size : INTEGER := 3;
  SUBTYPE comparator_array IS STD_LOGIC_VECTOR(comparator_array_size-1 DOWNTO 0);

  CONSTANT comparator_eq    : comparator_array := "001";
  CONSTANT comparator_gr    : comparator_array := "010";
  CONSTANT comparator_lo    : comparator_array := "100";
  CONSTANT comparator_ge    : comparator_array := "011";
  CONSTANT comparator_le    : comparator_array := "101";
  CONSTANT comparator_ne    : comparator_array := "110";
  CONSTANT comparator_true  : comparator_array := "111";
  CONSTANT comparator_false : comparator_array := "000";
END PACKAGE;
