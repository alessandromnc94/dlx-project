LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sign_extender IS
  GENERIC (
    n_in  : INTEGER := 32;
    n_out : INTEGER := 2*n_in
    );
  PORT (
    in_s  : IN  STD_LOGIC_VECTOR(n_in-1 DOWNTO 0);
    en    : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF sign_extender IS
  SIGNAL extended_bit : STD_LOGIC;
BEGIN
  extended_bit <= en AND in_s(n_in-1);
  out_s        <= (n_out-1 DOWNTO n_in => extended_bit) & in_s;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_sign_extender_behavioral OF sign_extender IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
