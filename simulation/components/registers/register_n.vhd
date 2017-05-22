LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_n IS
  GENERIC (
    n : INTEGER := 8
    )
    PORT (
      din  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      clk  : IN  STD_LOGIC;
      rst  : IN  STD_LOGIC;
      set  : IN  STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF register_n IS
BEGIN

  PROCESS (clk, rst, set)
  BEGIN
-- asynchronous set and reset
    IF rst = '1' OR set = '1' THEN
      -- if rst and set are equal to '1'
      -- forbidden input
      IF rst = set THEN
        dout <= (OTHERS => 'x');
      ELSIF rst = '1'
        dout <= (OTHERS => '0');
    ELSE
      dout <= (OTHERS => '1');
    END IF;
  ELSIF rising_edge(clk) THEN
    dout <= din;
  END IF;
END PROCESS;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF register_n IS

  COMPONENT dff IS
    PORT (
      d   : IN  STD_LOGIC;
      clk : IN  STD_LOGIC;
      rst : IN  STD_LOGIC;
      set : IN  STD_LOGIC;
      q   : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN

  dff_generation : FOR i IN 0 TO n-1 GENERATE
    dffx : dff
      PORT MAP (
        d   => din(i),
        clk => clk,
        rst => rst,
        set => set,
        q   => dout(i)
        );
  END GENERATE dff_generation;
END ARCHITECTURE;

-- configurations

CONFIGURATION cfg_register_n_behavioral OF register_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

CONFIGURATION cfg_register_n_structural OF register_n IS
  FOR structural
    FOR dff_generation
      FOR dffx : dff
        USE CONFIGURATION work.cfg_dff_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
