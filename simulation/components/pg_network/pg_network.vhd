LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pg_network IS
  GENERIC (
    n : INTEGER := 32
    );
  PORT (
    in_1 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    pg   : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    g    : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF pg_network IS
  COMPONENT pg_network_block IS
    PORT (
      in_1 : IN  STD_LOGIC;
      in_2 : IN  STD_LOGIC;
      pg   : OUT STD_LOGIC;
      g    : OUT STD_LOGIC
      );
  END COMPONENT;
BEGIN

  pg_block_gen : FOR i IN 0 TO n-1 GENERATE
    pg_blockx : pg_network_block
      PORT MAP (
        in_1 => in_1(i),
        in_2 => in_2(i),
        pg   => pg(i),
        g    => g(i)
        );
  END GENERATE;
END ARCHITECTURE;

-- configurations

-- structural configuration with behavioral components
CONFIGURATION cfg_pg_network_structural_1 OF pg_network IS
  FOR structural
    FOR pg_block_gen
      FOR ALL : pg_network_block
        USE CONFIGURATION work.cfg_pg_network_block_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;

-- structural configuration with structural components
CONFIGURATION cfg_pg_network_structural_2 OF pg_network IS
  FOR structural
    FOR pg_block_gen
      FOR ALL : pg_network_block
        USE CONFIGURATION work.cfg_pg_network_block_structural;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
