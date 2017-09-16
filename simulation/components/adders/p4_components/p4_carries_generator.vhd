LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY p4_carries_generator IS
  GENERIC (
    n          : INTEGER := 32;
    carry_step : INTEGER := 4
    );
  PORT (
    in_1        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_in    : IN  STD_LOGIC;
    carries_out : OUT STD_LOGIC_VECTOR (n/carry_step DOWNTO 0)
    );
END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF p4_carries_generator IS

  COMPONENT pg_network IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      pg   : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      g    : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT p4_carries_logic_network IS
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      pg          : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      g           : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_in    : IN  STD_LOGIC;
      carries_out : OUT STD_LOGIC_VECTOR (n/carry_step DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL pg0_s, g0_s : STD_LOGIC_VECTOR (n-1 DOWNTO 0);

BEGIN

  pg_net : pg_network
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      in_1 => in_1,
      in_2 => in_2,
      pg   => pg0_s,
      g    => g0_s
      );

  cl_net : p4_carries_logic_network
    GENERIC MAP (
      n          => n,
      carry_step => carry_step
      )
    PORT MAP (
      pg          => pg0_s,
      g           => g0_s,
      carry_in    => carry_in,
      carries_out => carries_out
      );
END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_p4_carries_generator_structural OF p4_carries_generator IS
  FOR structural
    FOR pg_net : pg_network USE CONFIGURATION work.cfg_pg_network_structural_2;
    END FOR;
    FOR cl_net : p4_carries_logic_network USE CONFIGURATION work.cfg_p4_carries_logic_network_structural;
    END FOR;
  END FOR;
END CONFIGURATION;
