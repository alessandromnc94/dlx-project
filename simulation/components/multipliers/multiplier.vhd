LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY multiplier IS
  GENERIC (
    n : INTEGER := 16
    )
    PORT (
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)
      );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF multiplier IS

BEGIN
  out_s <= in_1 * in_2;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_multiplier_behavioral OF multiplier IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
