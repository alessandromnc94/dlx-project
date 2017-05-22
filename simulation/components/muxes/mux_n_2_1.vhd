LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_n_2_1 IS
  GENERIC (
    n : INTEGER := 1
    );
  PORT (
    i0 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i1 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    s  : IN  STD_LOGIC;
    o  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_2_1 IS
BEGIN
  o <= i0 WHEN s = '0' ELSE
       i1;
END ARCHITECTURE;

-- configurations

CONFIGURATION cfg_mux_n_2_1_behavioral OF mux_n_2_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
