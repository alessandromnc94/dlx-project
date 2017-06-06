LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY rca_n IS
  GENERIC (
    n : INTEGER := 4
    );
  PORT (
    in_1      : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2      : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    carry_in  : STD_LOGIC;
    sum       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    carry_out : STD_LOGIC
    );
END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF rca_n IS

  COMPONENT full_adder IS
    PORT(
      in_1      : STD_LOGIC;
      in_2      : STD_LOGIC;
      carry_in  : STD_LOGIC;
      sum       : STD_LOGIC;
      carry_out : STD_LOGIC
      );
  END COMPONENT;

  SIGNAL carries : STD_LOGIC_VECTOR(n DOWNTO 0) := (OTHERS => '0');

BEGIN
  carries(0) <= carry_in;
  carry_out  <= carries(n);

  full_adder_gen : FOR i IN 0 TO n-1 GENERATE
    full_adder_x : full_adder PORT MAP (
      in_1      => in_1(i),
      in_2      => in_2(i),
      carry_in  => carries(i),
      sum       => sum(i),
      carry_out => carries(i+1)
      );
  END GENERATE;

END ARCHITECTURE;

-- configurations

-- structural configuration with behavioral components
CONFIGURATION cfg_rca_n_structural_1 OF rca_n IS
  FOR structural
    FOR full_adder_gen
      FOR full_adder_x : full_adder USE CONFIGURATION work.cfg_full_adder_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;

-- structural configuration with structural components
CONFIGURATION cfg_rca_n_structural_2 OF rca_n IS
  FOR structural
    FOR full_adder_gen
      FOR full_adder_x : full_adder USE CONFIGURATION work.cfg_full_adder_structural;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
