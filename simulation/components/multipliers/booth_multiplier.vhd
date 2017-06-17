LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.booth_generator_types.ALL;

ENTITY booth_multiplier IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    in_1       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    signed_mul : IN  STD_LOGIC;
    out_s      : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)
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

-- in_0 : 0
-- in_1 : 1 x k
-- in_2 : -1 x k
-- in_3 : 2 x k
-- in_4 : -2 x k
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

  CONSTANT n_prime : INTEGER := n+2;

  CONSTANT n_level   : INTEGER := n_prime/2 + n_prime MOD 2;
  CONSTANT n_shifted : INTEGER := 3*n_prime;

  TYPE signal_matrix IS ARRAY(0 TO n_level-1) OF STD_LOGIC_VECTOR(2*n_prime-1 DOWNTO 0);
  SIGNAL encoder_out                      : STD_LOGIC_VECTOR(3*n_level-1 DOWNTO 0);
  SIGNAL gen_pos_out, gen_neg_out         : STD_LOGIC_VECTOR(n_shifted-1 DOWNTO 0);
  SIGNAL mux_out_matrix, adder_out_matrix : signal_matrix;

  SIGNAL in_1_bis, in_2_bis               : STD_LOGIC_VECTOR(n_prime-1 DOWNTO 0);
  SIGNAL sign_extender_1, sign_extender_2 : STD_LOGIC;
BEGIN
  sign_extender_1 <= in_1(n-1) AND signed_mul;
  sign_extender_2 <= in_2(n-1) AND signed_mul;
  in_1_bis        <= sign_extender_1 & sign_extender_1 & in_1;
  in_2_bis        <= sign_extender_2 & sign_extender_2 & in_2;

  booth_encoder_comp : booth_encoder GENERIC MAP (
    n => n_prime
    ) PORT MAP (
      in_s  => in_2_bis,
      out_s => encoder_out
      );

  booth_generator_comp : booth_generator GENERIC MAP (
    n_in  => n_prime,
    n_out => n_shifted
    ) PORT MAP (
      in_s    => in_1_bis,
      pos_out => gen_pos_out,
      neg_out => gen_neg_out
      );

  muxes_gen : FOR i IN 0 TO n_level-1 GENERATE
    mux_x : mux_n_5_1 GENERIC MAP (
      n => 2*n_prime
      ) PORT MAP (
        in_0  => (OTHERS => '0'),       -- 0
        in_1  => gen_pos_out(n_shifted-2*i-1 DOWNTO n_shifted-2*i-2*n_prime),  -- 1x(2^(i+1))
        in_2  => gen_pos_out(n_shifted-2*i-2 DOWNTO n_shifted-2*i-1-2*n_prime),  -- 2x(2^(i+1))
        in_3  => gen_neg_out(n_shifted-2*i-1 DOWNTO n_shifted-2*i-2*n_prime),  -- -1x(2^(i+1))
        in_4  => gen_neg_out(n_shifted-2*i-2 DOWNTO n_shifted-2*i-1-2*n_prime),  -- -2x(2^(i+1))
        s     => encoder_out(i*3+2 DOWNTO i*3),
        out_s => mux_out_matrix(i)
        );
  END GENERATE;

  adders_gen : FOR i IN 1 TO n_level-1 GENERATE
    adder_0_gen : IF i = 1 GENERATE
      adder_0 : rca_n GENERIC MAP (
        n => 2*n_prime
        ) PORT MAP (
          in_1      => mux_out_matrix(1),
          in_2      => mux_out_matrix(0),
          carry_in  => '0',
          sum       => adder_out_matrix(1),
          carry_out => OPEN
          );
    END GENERATE;
    adder_x_gen : IF i > 1 GENERATE
      adder_x : rca_n GENERIC MAP (
        n => 2*n_prime
        ) PORT MAP (
          in_1      => mux_out_matrix(i),
          in_2      => adder_out_matrix(i-1),
          carry_in  => '0',
          sum       => adder_out_matrix(i),
          carry_out => OPEN
          );
    END GENERATE;
  END GENERATE;

  out_s <= adder_out_matrix(n_level-1)(2*n-1 DOWNTO 0);

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_booth_multiplier_structural OF booth_multiplier IS
  FOR structural
  END FOR;
END CONFIGURATION;
