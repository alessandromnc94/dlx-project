LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY basic_multiplier IS
  GENERIC (
    n : INTEGER := 16
    )
    PORT (
      in_1 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      mul  : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)
      );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF basic_multiplier IS

BEGIN
  mul <= in_1 * in_2;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_basic_multiplier_behavioral OF basic_multiplier IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
