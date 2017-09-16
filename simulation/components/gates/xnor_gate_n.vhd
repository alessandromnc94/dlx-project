LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xnor_gate_n IS
  GENERIC (
    n : INTEGER := 1
    )
    PORT (
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF xnor_gate_n IS
  SIGNAL tmp_out_s : STD_LOGIC;
BEGIN
  out_s <= in_1 XNOR in_2;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF xnor_gate_n IS
  COMPONENT xnor_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN
  gate_gen : FOR i IN 0 TO n-1 GENERATE
    xnor_gate_x : xnor_gate PORT MAP (
      in_1  => in_1(i),
      in_2  => in_2(i),
      out_s => out_s(i)
      );
  END GENERATE;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_xnor_gate_n_behavioral OF xnor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_xnor_gate_n_structural OF xnor_gate_n IS
  FOR structural
    FOR gate_gen
      FOR xnor_gate_x : xnor_gate USE CONFIGURATION work.cfg_xnor_gate_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
