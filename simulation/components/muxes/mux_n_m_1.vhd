LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.my_arith_functions.ALL;
USE work.mux_n_m_1_types.ALL;

ENTITY mux_n_m_1 IS
  GENERIC (
    n : INTEGER := 1;                   -- number of bits for inputs
    m : INTEGER := 2                    -- number of inputs
    );
  PORT (
    i : IN  mux_n_m_1_matrix(0 TO m-1)(n-1 DOWNTO 0);  -- input matrix [depth range, width range]
    s : IN  STD_LOGIC_VECTOR(log2int(m)-1 DOWNTO 0);  -- selector is always a vector
    o : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_m_1 IS
BEGIN
  o <= i(conv_integer(s)) WHEN conv_integer(s) < m ELSE
       (OTHERS => 'z');
END ARCHITECTURE;

ARCHITECTURE structural OF mux_n_m_1 IS

  COMPONENT mux_n_2_1 IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      i0 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      i1 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s  : IN  STD_LOGIC;
      o  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  TYPE output_matrix_type IS ARRAY (INTEGER RANGE 0 TO s'LENGTH) OF mux_n_m_1_matrix(0 TO 2**s'LENGTH-1)(n-1 DOWNTO 0);
  SIGNAL output_matrix : output_matrix_type := (OTHERS => (OTHERS => (OTHERS => 'z')));

BEGIN

  output_matrix(0)(0 TO m-1) <= i;
  o                          <= output_matrix(s'LENGTH)(0);

  mux_level : FOR i IN 0 TO s'LENGTH-1 GENERATE
    muxes_generate : FOR j IN 0 TO 2**(s'LENGTH-1-i)-1 GENERATE
      mux : mux_n_2_1
        GENERIC MAP (
          n => n
          )
        PORT MAP (
          i0 => output_matrix(i)(2*j),
          i1 => output_matrix(i)(2*j+1),
          s  => s(i),
          o  => output_matrix(i+1)(j)
          );
    END GENERATE muxes_generate;
  END GENERATE mux_level;
END ARCHITECTURE;

-- configurations

CONFIGURATION cfg_mux_n_m_1_behavioral OF mux_n_m_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- use behavioral mux_n_2_1
CONFIGURATION cfg_mux_n_m_1_structural_1 OF mux_n_m_1 IS
  FOR structural
    FOR mux_level
      FOR muxes_generate
        FOR mux : mux_n_2_1 USE CONFIGURATION work.cfg_mux_n_2_1_behavioral;
        END FOR;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;

-- use structural mux_n_2_1
CONFIGURATION cfg_mux_n_m_1_structural_2 OF mux_n_m_1 IS
  FOR structural
    FOR mux_level
      FOR muxes_generate
        FOR mux : mux_n_2_1 USE CONFIGURATION work.cfg_mux_n_2_1_structural;
        END FOR;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
