LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

USE work.booth_generator_types.ALL;

ENTITY booth_generator IS
  GENERIC(
    n_in  : INTEGER := 16;
<<<<<<< HEAD
    n_out : INTEGER := 3*16
=======
    n_out : INTEGER := n_in+shifted_pos-1
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
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
<<<<<<< HEAD
  SIGNAL compl_2_in_s : STD_LOGIC_VECTOR(n_in -1 DOWNTO 0);
BEGIN
  compl_2_in_s <= '1'+NOT(in_s);

  pos_out(n_out-2*n_in-1 DOWNTO 0) <= (OTHERS => '0');
  neg_out(n_out-2*n_in-1 DOWNTO 0) <= (OTHERS => '0');

  pos_out(n_out-n_in-1 DOWNTO n_out-2*n_in) <= in_s;
  neg_out(n_out-n_in-1 DOWNTO n_out-2*n_in) <= compl_2_in_s;

  pos_out(n_out-1 DOWNTO n_out-n_in) <= (OTHERS => in_s(n_in-1));
  neg_out(n_out-1 DOWNTO n_out-n_in) <= (OTHERS => compl_2_in_s(n_in-1));
=======
BEGIN
  pos_out(n_out-1 DOWNTO n_out-n_in) <= in_s;
  pos_out(n_out-n_in-1 DOWNTO 0)     <= (OTHERS => '0');
  neg_out(n_out-1 DOWNTO n_out-n_in) <= '1'+NOT(in_s);
  neg_out(n_out-n_in-1 DOWNTO 0)     <= (OTHERS => '0');
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_booth_generator_behavioral OF booth_generator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
