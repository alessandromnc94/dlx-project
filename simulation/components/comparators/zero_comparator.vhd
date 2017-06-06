LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY zero_comparator IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF zero_comparator IS
BEGIN

  out_s <= '1' WHEN in_s = (n-1 DOWNTO 0 => '0') ELSE
           '0';

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_zero_comparator_behavioral OF zero_comparator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
