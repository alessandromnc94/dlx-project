LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shifter IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    base_vector    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    shift_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    left_shift     : IN  STD_LOGIC;
    arith_shift    : IN  STD_LOGIC;
    out_s          : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF shifter IS
  SIGNAL out_s_tmp, base_vector_casted : BIT_VECTOR(n-1 DOWNTO 0);
  SIGNAL shift_by_value_casted         : INTEGER;
BEGIN
  base_vector_casted    <= to_bitvector(base_vector);
  shift_by_value_casted <= conv_integer(shift_by_value);
  out_s                 <= to_stdlogicvector(out_s_tmp);
  out_s_tmp             <= base_vector_casted SLL shift_by_value_casted WHEN left_shift = '1' ELSE
               base_vector_casted SRL shift_by_value_casted WHEN arith_shift = '0' ELSE
               base_vector_casted SRA shift_by_value_casted;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_shifter_behavioral OF shifter IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
