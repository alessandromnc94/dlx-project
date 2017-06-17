LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY rotator IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    base_vector     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    rotate_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    left_rotation   : IN  STD_LOGIC;
    out_s           : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF rotator IS
  SIGNAL out_s_tmp, base_vector_casted : BIT_VECTOR(n-1 DOWNTO 0);
  SIGNAL rotate_by_value_casted        : INTEGER;
BEGIN
  base_vector_casted     <= to_bitvector(base_vector);
  rotate_by_value_casted <= conv_integer(rotate_by_value);
  out_s                  <= to_stdlogicvector(out_s_tmp);
  out_s_tmp              <= base_vector_casted ROL rotate_by_value_casted WHEN left_rotation = '1' ELSE
               base_vector_casted ROR rotate_by_value_casted;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_rotator_behavioral OF rotator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;