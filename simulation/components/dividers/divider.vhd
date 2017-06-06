LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY divider IS
  GENERIC (
    n : INTEGER := 32
    )
    PORT (
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF divider IS

BEGIN
  out_s <= in_1 / in_2;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_divider_behavioral OF divider IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
