LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY mux_n_8_1 IS
  GENERIC (
    n : INTEGER := 1                           -- number of bits for inputs
    );
  PORT (
    in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_3  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_4  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_5  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_6  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_7  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    s     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- selector
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_8_1 IS
BEGIN
  PROCESS (ALL)
  BEGIN
    CASE conv_integer(s) IS
      WHEN 0      => out_s <= in_0;
      WHEN 1      => out_s <= in_1;
      WHEN 2      => out_s <= in_2;
      WHEN 3      => out_s <= in_3;
      WHEN 4      => out_s <= in_4;
      WHEN 5      => out_s <= in_5;
      WHEN 6      => out_s <= in_6;
      WHEN 7      => out_s <= in_7;
      WHEN OTHERS => NULL;
    END CASE;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_mux_n_8_1_behavioral OF mux_n_8_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
