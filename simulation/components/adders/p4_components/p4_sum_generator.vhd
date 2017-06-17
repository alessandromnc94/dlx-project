LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
<<<<<<< HEAD

ENTITY p4_sum_generator IS
=======
USE work.constants.ALL;

ENTITY sum_generator IS
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f

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
<<<<<<< HEAD
ARCHITECTURE structural OF p4_sum_generator IS

  COMPONENT p4_carry_select_block IS
=======
ARCHITECTURE structural OF sum_generator IS

  COMPONENT carry_select_block IS
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
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
<<<<<<< HEAD
    csbx : p4_carry_select_block
=======
    csbx : carry_select_block
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
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

<<<<<<< HEAD
CONFIGURATION cfg_p4_sum_generator_structural OF p4_sum_generator IS
  FOR structural
    FOR csb_gen
      FOR ALL : p4_carry_select_block USE CONFIGURATION work.cfg_p4_carry_select_block_structural;
=======
CONFIGURATION cfg_sum_generator_structural OF sum_generator IS
  FOR structural
    FOR csb_gen
      FOR ALL : carry_select_block
        USE CONFIGURATION work.cfg_carry_select_block_structural;
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
