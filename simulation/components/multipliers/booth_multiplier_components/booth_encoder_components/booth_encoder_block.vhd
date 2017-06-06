LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY booth_encoder_block IS

  PORT(
    in_s  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
    out_s : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF booth_encoder_block IS

  COMPONENT and_gate_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
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

  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL not_in_s  : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL out_s_tmp : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

  out_s <= out_s_tmp;

  not_in_s_gen : FOR i IN 0 TO 2 GENERATE
    not_gate_x : not_gate PORT MAP(
      in_s  => in_s(i),
      out_s => not_in_s(i)
      );
  END GENERATE;

  -- out_s(0) <= in_s(1) xor in_s(0)
  xor_gate_2_0 : xor_gate PORT MAP (
    in_1  => in_s(0),
    in_2  => in_s(1),
    out_s => out_s_tmp(0)
    );

  -- out_s(1) <= in_s(2) xor in_s(1) xor in_s(0) == in_s(2) xor out_s(0)
  xor_gate_2_1 : xor_gate PORT MAP (
    in_1  => in_s(2),
    in_2  => out_s_tmp(0),
    out_s => out_s_tmp(1)
    );

  -- out_s(1) <= in_s(2) and not(in_s(1)) and not(in_s(0))
  and_gate_3_2 : and_gate_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => in_s(2) & not_in_s(1) & not_in_s(0),
      out_s => out_s_tmp(2)
      );

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_booth_encoder_block_structural OF booth_encoder_block IS
  FOR structural
    FOR not_in_s_gen
      FOR not_gate_x : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
      END FOR;
    END FOR;
    FOR xor_gate_2_0 : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR xor_gate_2_1 : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR and_gate_3_2 : and_gate_n USE CONFIGURATION work.cfg_and_gate_n_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
