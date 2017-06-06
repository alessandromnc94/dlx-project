LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pg_network_block IS
  PORT (
    in_1 : IN  STD_LOGIC;
    in_2 : IN  STD_LOGIC;
    pg   : OUT STD_LOGIC;
    g    : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF pg_network_block IS

BEGIN

  g  <= in_1 AND in_2;
  pg <= in_1 XOR in_2;

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF pg_network_block IS

  COMPONENT and_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  COMPONENT xor_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN
  g_and_gate : and_gate PORT MAP (
    in_1  => in_1,
    in_2  => in_2,
    out_s => g
    );
  pg_xor_gate : xor_gate PORT MAP (
    in_1  => in_1,
    in_2  => in_2,
    out_s => pg
    );

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_pg_network_block_behavioral OF pg_network_block IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_pg_network_block_structural OF pg_network_block IS
  FOR structural
    FOR g_and_gate  : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR pg_xor_gate : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
