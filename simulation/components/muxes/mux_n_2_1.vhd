LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_n_2_1 IS
  GENERIC (
    n : INTEGER := 1
    );
  PORT (
    in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    s     : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF mux_n_2_1 IS
BEGIN
  out_s <= in_0 WHEN s = '0' ELSE in_1;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF mux_n_2_1 IS

  COMPONENT and_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT or_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL not_s                    : STD_LOGIC                      := '0';
  SIGNAL in_0_and_out, in_1_and_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

  not_s_gate : not_gate
    PORT MAP(
      in_s  => s,
      out_s => not_s
      );

      in_0_and_gate_n : and_gate_n generic map (
        n => n
      ) port map (
        in_1 => in_0,
        in_2 => (n-1 downto 0 => not_s),
        out_s => in_0_and_out
      );

      in_1_and_gate_n : and_gate_n generic map (
        n => n
      ) port map (
        in_1 => in_0,
        in_2 => (n-1 downto 0 => s),
        out_s => in_1_and_out
      );

    out_or_gate_n : or_gate_n generic map (
      n => n
    ) PORT MAP (
        in_1  => in_0_and_out(i),
        in_2  => in_1_and_out(i),
        out_s => out_s(i)
        );

END ARCHITECTURE;

-- configurations

CONFIGURATION cfg_mux_n_2_1_behavioral OF mux_n_2_1 IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

CONFIGURATION cfg_mux_n_2_1_structural OF mux_n_2_1 IS
  FOR structural
    FOR not_s_gate : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR gates_gen
      FOR in0_and_gate_x : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
      END FOR;
      FOR in1_and_gate_x : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
      END FOR;
      FOR or_gate_x      : or_gate USE CONFIGURATION work.cfg_or_gate_behavioral;
      END FOR;
    END FOR;
  END FOR;
END CONFIGURATION;
