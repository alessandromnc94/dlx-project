LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY p4_adder IS
  GENERIC (
    n          : INTEGER := 32;
    carry_step : INTEGER := 4
    );
  PORT (
    in_1      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_in  : IN  STD_LOGIC;
    sum       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_out : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- structural architecture

ARCHITECTURE structural OF p4_adder IS

  COMPONENT carries_generator IS
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_in    : IN  STD_LOGIC;
      carries_out : OUT STD_LOGIC_VECTOR (n/carry_step DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT sum_generator IS
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carries_in : IN  STD_LOGIC_VECTOR (n/carry DOWNTO 0);
      sum        : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL carries : STD_LOGIC_VECTOR (n/carry DOWNTO 0);

BEGIN

  carry_out <= carries(n/carry);

  cg : carry_generator
    GENERIC MAP (
      n          => n,
      carry_step => carry_step
      )
    PORT MAP (
      in_1        => in_1,
      in_2        => in_2,
      carry_in    => carry_in,
      carries_out => carries
      );

  sg : sum_generator
    GENERIC MAP (
      n     => n,
      carry => carry
      )
    PORT MAP (
      in_1       => in_1,
      in_2       => in_2,
      carries_in => carries,
      sum        => sum
      );

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_p4_adder_structural OF p4_adder IS
  FOR structural
    FOR cg : carry_generator
      USE CONFIGURATION work.cfg_carry_generator_structural;
    END FOR;
    FOR sg : sum_generator
      USE CONFIGURATION work.cfg_sum_generator_structural;
    END FOR;
  END FOR;
END CONFIGURATION;
