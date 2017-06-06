LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shifter IS
  GENERIC (
    n : INTEGER := 32
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
BEGIN
  out_s <= base_vector SLL shift_by_value WHEN left_shift = '1' ELSE
           base_vector SRL shift_by_value WHEN arith_shift = '0' ELSE
           base_vector SRA shift_by_value;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_shifter_behavioral OF shifter IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
