LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.my_arith_functions.ALL;
USE work.p4_carries_logic_network_types.ALL;
USE work.p4_carries_logic_network_functions.ALL;

ENTITY p4_carries_logic_network IS
  GENERIC (
    n          : INTEGER := 32;
    carry_step : INTEGER := 4
    );

  PORT (
    pg          : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    g           : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_in    : IN  STD_LOGIC;
    carries_out : OUT STD_LOGIC_VECTOR (n/carry_step DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF p4_carries_logic_network IS
  CONSTANT n_bit_log2 : INTEGER    := log2int(n);
  TYPE charvector IS ARRAY (n DOWNTO 0) OF CHARACTER;
  TYPE charmatrix IS ARRAY (0 TO n_bit_log2) OF charvector;
  SIGNAL matrix_char  : charmatrix := (OTHERS => (OTHERS => 'x'));



  COMPONENT g_block IS
    PORT (
      pg_l  : IN  STD_LOGIC;
      g_l   : IN  STD_LOGIC;
      g_r   : IN  STD_LOGIC;
      g_out : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT pg_block IS
    PORT (
      pg_l   : IN  STD_LOGIC;
      g_l    : IN  STD_LOGIC;
      pg_r   : IN  STD_LOGIC;
      g_r    : IN  STD_LOGIC;
      pg_out : OUT STD_LOGIC;
      g_out  : OUT STD_LOGIC
      );
  END COMPONENT;

  CONSTANT n_log2          : INTEGER := log2int(n);
  CONSTANT carry_step_log2 : INTEGER := log2int(carry_step);

  TYPE signalvector IS ARRAY (0 TO n_log2) OF STD_LOGIC_VECTOR (n DOWNTO 0);

  SIGNAL pg_matrix : signalvector;
  SIGNAL g_matrix  : signalvector;

BEGIN

  carries_out(0) <= carry_in;

  carries_out_gen : FOR blck IN 1 TO bintable_blocks(n, carry_step) GENERATE
    carries_out(blck) <= g_matrix(n_log2)(bintable_left(carry_step, blck));
  END GENERATE;

  g_block_0 : g_block
    PORT MAP (
      pg_l  => pg(0),
      g_l   => g(0),
      g_r   => carry_in,
      g_out => g_matrix(0)(1)
      );
  pg_matrix(0)(1)   <= pg(0);
  matrix_char(0)(1) <= 'g';

  pg_lev_0 : FOR blck IN 2 TO n GENERATE
    pg_matrix(0)(blck)   <= pg(blck-1);
    g_matrix(0)(blck)    <= g(blck-1);
    matrix_char(0)(blck) <= 'p';

  END GENERATE;

  bintree : FOR level IN 1 TO carry_step_log2 GENERATE
    bintree_blcks : FOR blck IN 1 TO bintree_blocks(n, level) GENERATE
      bintree_g_block : IF bintree_is_g(blck) GENERATE
        g_block_x : g_block
          PORT MAP (
            pg_l  => pg_matrix(level-1)(bintree_left(level, blck)),
            g_l   => g_matrix(level-1)(bintree_left(level, blck)),
            g_r   => g_matrix(level-1)(bintree_right(level, blck)),
            g_out => g_matrix(level)(bintree_left(level, blck))
            );
        matrix_char(level)(bintree_left(level, blck)) <= 'g';
      END GENERATE;
      bintree_pg_block : IF NOT bintree_is_g(blck) GENERATE
        pg_block_x : pg_block
          PORT MAP (
            pg_l   => pg_matrix(level-1)(bintree_left(level, blck)),
            g_l    => g_matrix(level-1)(bintree_left(level, blck)),
            pg_r   => pg_matrix(level-1)(bintree_right(level, blck)),
            g_r    => g_matrix(level-1)(bintree_right(level, blck)),
            pg_out => pg_matrix(level)(bintree_left(level, blck)),
            g_out  => g_matrix(level)(bintree_left(level, blck))
            );
        matrix_char(level)(bintree_left(level, blck)) <= 'p';

      END GENERATE;
    END GENERATE;
  END GENERATE;

  bintable : FOR level IN carry_step_log2+1 TO n_log2 GENERATE
    bintable_blcks : FOR blck IN 1 TO bintable_blocks(n, carry_step) GENERATE
      bintable_valid_blck : IF bintable_valid_block(level, blck, carry_step) GENERATE
        bintable_g_block : IF bintable_is_g(level, blck, carry_step) GENERATE
          g_block_x : g_block
            PORT MAP (
              pg_l  => pg_matrix(level-1)(bintable_left(carry_step, blck)),
              g_l   => g_matrix(level-1)(bintable_left(carry_step, blck)),
              g_r   => g_matrix(level-1)(bintable_right(carry_step, level, blck)),
              g_out => g_matrix(level)(bintable_left(carry_step, blck))
              );
          matrix_char(level)(bintable_left(carry_step, blck)) <= 'g';
        END GENERATE;
        bintable_pg_block : IF NOT bintable_is_g(level, blck, carry_step) GENERATE
          pg_block_x : pg_block
            PORT MAP (
              pg_l   => pg_matrix(level-1)(bintable_left(carry_step, blck)),
              g_l    => g_matrix(level-1)(bintable_left(carry_step, blck)),
              pg_r   => pg_matrix(level-1)(bintable_right(carry_step, level, blck)),
              g_r    => g_matrix(level-1)(bintable_right(carry_step, level, blck)),
              pg_out => pg_matrix(level)(bintable_left(carry_step, blck)),
              g_out  => g_matrix(level)(bintable_left(carry_step, blck))
              );
          matrix_char(level)(bintable_left(carry_step, blck)) <= 'p';
        END GENERATE;
      END GENERATE;
      bintable_redirect : IF NOT bintable_valid_block(level, blck, carry_step) GENERATE
        pg_matrix(level)(bintable_left(carry_step, blck))   <= pg_matrix(level-1)(bintable_left(carry_step, blck));
        g_matrix(level)(bintable_left(carry_step, blck))    <= g_matrix(level-1)(bintable_left(carry_step, blck));
        matrix_char(level)(bintable_left(carry_step, blck)) <= '|';
      END GENERATE;
    END GENERATE;
  END GENERATE;
END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_p4_carries_logic_network_structural OF p4_carries_logic_network IS
  FOR structural
    FOR g_block_0 : g_block USE CONFIGURATION work.cfg_g_block_structural;
    END FOR;
    FOR bintree
      FOR bintree_blcks
        FOR bintree_g_block
          FOR ALL : g_block USE CONFIGURATION work.cfg_g_block_structural;
          END FOR;
        END FOR;
        FOR bintree_pg_block
          FOR ALL : pg_block USE CONFIGURATION work.cfg_pg_block_structural;
          END FOR;
        END FOR;
      END FOR;
    END FOR;
    FOR bintable
      FOR bintable_blcks
        FOR bintable_valid_blck
          FOR bintable_g_block
            FOR ALL : g_block USE CONFIGURATION work.cfg_g_block_structural;
            END FOR;
          END FOR;
          FOR bintable_pg_block
            FOR ALL : pg_block USE CONFIGURATION work.cfg_pg_block_structural;
            END FOR;
          END FOR;
        END FOR;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
