LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

USE work.booth_generator_types.ALL;

ENTITY booth_generator IS
  GENERIC(
    n_in  : INTEGER := 16;
    n_out : INTEGER := n_in+shifted_pos-1
    );
  PORT(
    in_s    : IN  STD_LOGIC_VECTOR(n_in-1 DOWNTO 0);
    pos_out : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0);
    neg_out : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0)
    );
END ENTITY;

-- architectures 

-- behavioral architecture
ARCHITECTURE behavioral OF booth_generator IS
BEGIN
  pos_out(n_out-1 DOWNTO n_out-n_in) <= in_s;
  pos_out(n_out-n_in-1 DOWNTO 0)     <= (OTHERS => '0');
  neg_out(n_out-1 DOWNTO n_out-n_in) <= '1'+NOT(in_s);
  neg_out(n_out-n_in-1 DOWNTO 0)     <= (OTHERS => '0');
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_booth_generator_behavioral OF booth_generator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
