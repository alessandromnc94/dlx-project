LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.logicals_types.ALL;

ENTITY logicals_n IS
  GENERIC (
    n : INTEGER : 8
    );
  PORT (
    in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    logic : IN  logicals_array;
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF logicals_n IS
  SIGNAL nands_0 : STD_LOGIC_VECTOR(n-1);
  SIGNAL nands_1 : STD_LOGIC_VECTOR(n-1);
  SIGNAL nands_2 : STD_LOGIC_VECTOR(n-1);
  SIGNAL nands_3 : STD_LOGIC_VECTOR(n-1);
BEGIN

  nands_0 <= NOT (logic(0) AND (NOT in_1) AND (NOT in_2));
  nands_1 <= NOT (logic(1) AND (NOT in_1) AND (in_2));
  nands_2 <= NOT (logic(2) AND (in_1) AND (NOT in_2));
  nands_3 <= NOT (logic(3) AND (in_1) AND (in_2));

  out_s <= NOT (nands_0 AND nands_1 AND nands_2 AND nands_3);

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF logicals_n IS
  COMPONENT logicals IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      logic : IN  logicals_array;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN

  logicals_gen : FOR i IN 0 TO n-1 GENERATE
    logicals_x : logicals PORT MAP (
      in_1  => in_1(i),
      in_2  => in_2(i),
      logic => logic,
      out_s => out_s(i)
      );
  END GENERATE;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_logicals_n_behavioral OF logicals_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration with behavioral components
CONFIGURATION cfg_logicals_n_structural_1 OF logicals_n IS
  FOR structural
    FOR logicals_gen
      FOR logicals_x : logicals USE CONFIGURATION work.cfg_logicals_behavioral;
      END FOR;
    END FOR;
  END CONFIGURATION;

-- structural configuration with structural components
  CONFIGURATION cfg_logicals_n_structural_2 OF logicals_n IS
    FOR structural
      FOR logicals_gen
      FOR logicals_x : logicals USE CONFIGURATION work.cfg_logicals_structural;
  END FOR;
  END FOR;
  END CONFIGURATION;
