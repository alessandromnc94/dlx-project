LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate_n IS
  GENERIC (
    n : INTEGER := 1
    );
  PORT (
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF not_gate_n IS
BEGIN
  out_s <= NOT in_s;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF not_gate_n IS
  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN
  gate_gen : FOR i IN 0 TO n-1 GENERATE
    not_gate_x : not_gate PORT MAP (
      in_s  => in_s(i),
      out_s => out_s(i)
      );
  END GENERATE;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_not_gate_n_behavioral OF not_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_not_gate_n_structural OF not_gate_n IS
  FOR structural
    FOR gate_gen
      FOR not_gate_x : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
