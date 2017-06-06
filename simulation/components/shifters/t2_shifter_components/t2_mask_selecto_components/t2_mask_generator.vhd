LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY t2_mask_generator IS
  GENERIC (
    n           : INTEGER := 32;
    mask_offset : INTEGER := 3
    );
  PORT (
    base_vector : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    left_shift  : IN  STD_LOGIC;
    arith_shift : IN  STD_LOGIC;
    out_s       : OUT STD_LOGIC_VECTOR(3*n+2**(mask_offset+1)-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF t2_mask_generator IS

BEGIN
  out_s(3*n+2**(mask_offset+1)-1 DOWNTO 2*n+2**mask_offset) <= (OTHERS => arith_shift AND base_vector(n-1));
  out_s(n+2**mask_offset-1 DOWNTO 0)                        <= (OTHERS => '0');
  out_s(2*n+2**mask_offset-1 DOWNTO n+2*mask_offset)        <= base_vector;

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF t2_mask_generator IS
  SIGNAL left_shift_mask, right_shift_mask : STD_LOGIC_VECTOR(2*n+2**mask_offset-1 DOWNTO 0);

  COMPONENT and_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  COMPONENT mux_n_2_1 IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_0  : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : STD_LOGIC;
      out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL extended_bit         : STD_LOGIC;
  SIGNAL out_mux_1, out_mux_2 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

  extended_bit_and_gate : and_gate PORT MAP (
    in_1  => base_vector(n-1),
    in_2  => arith_shift,
    out_s => extended_bit
    );

  out_mux : mux_n_2_1 GENERIC MAP (
    n => 2*n+2**mask_offset
    ) PORT MAP (
      in_0  => right_shift_mask,
      in_1  => left_shift_mask,
      s     => left_shift,
      out_s => out_s
      );

  left_shift_mask(n+2**mask_offset-1 DOWNTO 0)                 <= (OTHERS => '0');
  left_shift_mask(2*n+2**mask_offset-1 DOWNTO n+2*mask_offset) <= base_vector;
  right_shift_mask(n-1 DOWNTO 0)                               <= base_vector;
  right_shift_mask(2*n+2**mask_offset-1 DOWNTO n)              <= (OTHERS => extended_bit);

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_t2_mask_generator_behavioral OF t2_mask_generator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration with behavioral components
CONFIGURATION cfg_t2_mask_generator_structural_1 OF t2_mask_generator IS
  FOR structural
    FOR extended_bit_and_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR out_mux               : mux_n_2_1 USE CONFIGURATION work.cfg_mux_n_2_1_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;

-- structural configuration with structural components
CONFIGURATION cfg_t2_mask_generator_structural_2 OF t2_mask_generator IS
  FOR structural
    FOR extended_bit_and_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR out_mux               : mux_n_2_1 USE CONFIGURATION work.cfg_mux_n_2_1_structural;
    END FOR;
  END FOR;
END CONFIGURATION;
