LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pg_block IS
  PORT (
    pg_l   : IN  STD_LOGIC;
    g_l    : IN  STD_LOGIC;
    pg_r   : IN  STD_LOGIC;
    g_r    : IN  STD_LOGIC;
    pg_out : OUT STD_LOGIC;
    g_out  : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF pg_block IS
BEGIN
  g_out  <= (g_l) OR (pg_l AND g_r);
  pg_out <= pg_l AND pg_r;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF pg_block IS
  COMPONENT or_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT and_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL and_out : STD_LOGIC := '0';
BEGIN
  pg_and_gate_out : and_gate PORT MAP (
    in_1  => pg_l,
    in_2  => pg_r,
    out_s => pg_out
    );
  g_and_gate_out : and_gate PORT MAP (
    in_1  => pg_l,
    in_2  => g_r,
    out_s => and_out
    );
  g_or_gate_out : or_gate PORT MAP (
    in_1  => g_l,
    in_2  => and_out,
    out_s => g_out
    );
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_g_block_behavioral OF pg_block IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_g_block_structural OF pg_block IS
  FOR structural
    FOR pg_and_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR g_and_gate  : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR g_or_gate   : or_gate USE CONFIGURATION work.cfg_or_gate_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
