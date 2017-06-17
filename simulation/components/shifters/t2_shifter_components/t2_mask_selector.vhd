LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.my_arith_functions.ALL;

ENTITY t2_mask_selector IS
  GENERIC (
    n           : INTEGER := 32;
    mask_offset : INTEGER := 3
    );
  PORT (
    base_vector    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    shift_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 3);
    left_shift     : IN  STD_LOGIC;
    arith_shift    : IN  STD_LOGIC;
    out_s          : OUT STD_LOGIC_VECTOR(n+2**mask_offset-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
-- architecture behavioral of t2_mask_selector is
-- signal mask_00 : std_logic_vector(n+2**mask_offset-1 downto 0);
-- begin
--      mask_00(2**mask_offset-1 downto 0) <= (others => '0');
--      mask_00(n+8-1 downto 8) <= base_vector;

--      out_s <= conv_std_logic_vector(unsigned(mask_00) sll unsigned(shift_by_value & "000") when left_shift = '1' else
--      unsigned(mask_00) sra unsigned(shift_by_value & "000") when arith_shift = '1' else
--      unsigned(mask_00) srl unsigned(shift_by_value & "000"));
-- end architecture;

-- structural architecture
ARCHITECTURE structural OF t2_mask_selector IS
  COMPONENT t2_mask_generator IS
    GENERIC (
      n           : INTEGER;
      mask_offset : INTEGER
      );
    PORT (
      base_vector : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      arith_shift : IN  STD_LOGIC;
      out_s       : OUT STD_LOGIC_VECTOR(3*n+2**(1+mask_offset)-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL mask_gen_out : STD_LOGIC_VECTOR(2*n+2**mask_offset-1 DOWNTO 0);
  TYPE mask_array IS ARRAY (-(2**mask_offset-1) TO 2**mask_offset-1) OF STD_LOGIC_VECTOR(n+2**mask_offset-1);
  SIGNAL mask_xx      : mask_array;

BEGIN

  masks_redirect : FOR i IN 0 TO 2**mask_offset-1 GENERATE
    mask_xx(i) <= mask_gen_out(2*n+(1-i)*2**mask_offset-1 DOWNTO 2*n-i*2**mask_offset);  -- 
  END GENERATE;


END ARCHITECTURE;
