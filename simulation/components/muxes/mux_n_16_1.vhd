LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY mux_n_16_1 IS
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
    in_8  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_9  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_10 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_11 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_12 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_13 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_14 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_15 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    s     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- selector
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_16_1 IS
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
      WHEN 8      => out_s <= in_8;
      WHEN 9      => out_s <= in_9;
      WHEN 10     => out_s <= in_10;
      WHEN 11     => out_s <= in_11;
      WHEN 12     => out_s <= in_12;
      WHEN 13     => out_s <= in_13;
      WHEN 14     => out_s <= in_14;
      WHEN 15     => out_s <= in_15;
      WHEN OTHERS => NULL;
    END CASE;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_mux_n_16_1_behavioral OF mux_n_16_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
