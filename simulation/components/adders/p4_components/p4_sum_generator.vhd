LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constants.ALL;

ENTITY sum_generator IS

  GENERIC (
    n          : INTEGER := 32;
    carry_step : INTEGER := 4
    );
  PORT (
    in_1       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carries_in : IN  STD_LOGIC_VECTOR (n/carry_step DOWNTO 0);
    sum        : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
    );

END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF sum_generator IS

  COMPONENT carry_select_block IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_sel : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;
BEGIN

  csb_gen : FOR i IN 0 TO n/carry_step-1 GENERATE
    csbx : carry_select_block
      GENERIC MAP (
        n => carry_step
        )
      PORT MAP (
        in_1      => in_1((i+1)*carry_step-1 DOWNTO (i)*carry_step),
        in_2      => in_2((i+1)*carry_step-1 DOWNTO (i)*carry_step),
        carry_sel => carries_in(i),
        sum       => sum((i+1)*carry_step-1 DOWNTO (i)*carry_step)
        );
  END GENERATE;

END ARCHITECTURE;

CONFIGURATION cfg_sum_generator_structural OF sum_generator IS
  FOR structural
    FOR csb_gen
      FOR ALL : carry_select_block
        USE CONFIGURATION work.cfg_carry_select_block_structural;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
