LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.booth_generator_types.ALL;

ENTITY booth_multiplier IS
  GENERIC (
    n : INTEGER := 16
    );
  PORT (
    in_1 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    mul  : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF booth_multiplier IS

  COMPONENT booth_encoder IS
    GENERIC(
      n : INTEGER
      );
    PORT(
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(3*((n/2) + n MOD 2) - 1 DOWNTO 0)
      );
  END COMPONENT;


  COMPONENT booth_generator IS
    GENERIC(
      n_in  : INTEGER;
      n_out : INTEGER
      );
    PORT(
      in_s    : IN  STD_LOGIC_VECTOR(n_in-1 DOWNTO 0);
      pos_out : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0);
      neg_out : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0)
      );
  END COMPONENT;

-- in_0 : in_1 x k x (-2)
-- in_1 : in_1 x k x 2
-- in_2 : in_1 x k x (-1)
-- in_3 : in_1 x k x 1
-- in_4 : in_1 x k x 0
  COMPONENT mux_n_5_1 IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_3  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_4  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- selector
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
      );
  END COMPONENT;

  CONSTANT n_level   : INTEGER := n/2 + n MOD 2;
  CONSTANT n_shifted : INTEGER := n+shifted_pos;

  TYPE signal_matrix IS ARRAY(n_level -1 DOWNTO 0) OF STD_LOGIC_VECTOR(n_shifted-1 DOWNTO 0);

  SIGNAL carries_out                      : STD_LOGIC_VECTOR(n_level -1 DOWNTO 0);
  SIGNAL encoder_out                      : STD_LOGIC_VECTOR(3*n_level-1 DOWNTO 0);
  SIGNAL gen_pos_out, gen_neg_out         : STD_LOGIC_VECTOR(n_shifted-1);
  SIGNAL mux_out_matrix, adder_out_matrix : signal_matrix;

BEGIN

  booth_encoder_comp : booth_encoder GENERIC MAP (
    n => n
    ) PORT MAP (
      in_s  => in_2,
      out_s => encoder_out
      );

  booth_generator_comp : booth_generator GENERIC MAP (
    n_in  => n,
    n_out => n_shifted
    ) PORT MAP (
      in_s    => in_1,
      pos_out => gen_pos_out,
      neg_out => gen_neg_out
      );

-- mux_0 : mux_n_5_1 generic map (
--      n => n_shifted
-- )

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_booth_multiplier_structural OF booth_multiplier IS
  FOR structural
  END FOR;
END CONFIGURATION;
