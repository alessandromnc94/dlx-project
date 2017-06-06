LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY rotator IS
  GENERIC (
    n : INTEGER := 32
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
BEGIN
  out_s <= base_vector ROL rotate_by_value WHEN left_rotation = '1' ELSE
           base_vector ROR rotate_by_value;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_rotator_behavioral OF rotator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
