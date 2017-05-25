LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_n_2_1 IS
  GENERIC (
    n : INTEGER := 1
    );
  PORT (
    i0 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i1 : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    s  : IN  STD_LOGIC;
    o  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_2_1 IS
BEGIN
  o <= i0 WHEN s = '0' ELSE
       i1;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF mux_n_2_1 IS

  COMPONENT and_gate IS
    PORT (
      i1 : IN  STD_LOGIC;
      i2 : IN  STD_LOGIC;
      o  : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT or_gate IS
    PORT (
      i1 : IN  STD_LOGIC;
      i2 : IN  STD_LOGIC;
      o  : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT not_gate IS
    PORT (
      i : IN  STD_LOGIC;
      o : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL not_s                  : STD_LOGIC                      := '0';
  SIGNAL i0_and_out, i1_and_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

  not_s_gate : not_gate
    PORT MAP(
      i => s,
      o => not_s
      );

  gates_gen : FOR i IN 0 TO n-1 GENERATE
    i0_and_gatex : and_gate
      PORT MAP (
        i1 => i0(i),
        i2 => not_s,
        o  => i0_and_out(i)
        );

    i1_and_gatex : and_gate
      PORT MAP (
        i1 => i1(i),
        i2 => s,
        o  => i1_and_out(i)
        );

    or_gatex : or_gate
      PORT MAP (
        i1 => i0_and_out(i),
        i2 => i1_and_out(i),
        o  => o(i)
        );
  END GENERATE gates_gen;

END ARCHITECTURE;

-- configurations

CONFIGURATION cfg_mux_n_2_1_behavioral OF mux_n_2_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

CONFIGURATION cfg_mux_n_2_1_structural OF mux_n_2_1 IS
  FOR structural
    FOR not_s_gate : not_gate
      USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR gates_gen
      FOR i0_and_gatex : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
      END FOR;
      FOR i1_and_gatex : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
      END FOR;
      FOR or_gatex     : or_gate USE CONFIGURATION work.cfg_or_gate_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
