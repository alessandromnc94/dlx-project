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

  COMPONENT and_gate_single_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
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

  COMPONENT xor_gate IS
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

  COMPONENT not_gate_n IS
  generic map (
    n : integer
  );
    PORT (
      in_s  : IN  STD_LOGIC_vector(n-1 downto 0);
      out_s : OUT STD_LOGIC_VECTOR(n-1 downto 0)
      );
  END COMPONENT;

  SIGNAL not_in_s                               : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL and_gate_3_2_in, and_gate_3_1_b_in     : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL and_gate_3_1_b_out, and_gate_2_1_a_out : STD_LOGIC;
  SIGNAL out_s_tmp                              : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

  out_s <= out_s_tmp;

  not_in_s_gate ; not_gate_n generic map (
    n => 3
    ) port map (
    in_s => in_s,
    out_s => not_in_s
  );

  -- out_s(0) <= in_s(1) xor in_s(0)
  xor_gate_2_0 : xor_gate PORT MAP (
    in_1  => in_s(0),
    in_2  => in_s(1),
    out_s => out_s_tmp(0)
    );

  -- out_s(1) <= (in_s(2) and (in_s(1) xor in_s(0))) or (not(in_s(2)) and in_s(1) and in_s(0)) == (in_s(2) xor out_s(0)) or  or (not(in_s(2)) and in_s(1) and in_s(0))
  and_gate_2_1_a : and_gate PORT MAP (
    in_1  => in_s(2),
    in_2  => out_s_tmp(0),
    out_s => and_gate_2_1_a_out
    );
  and_gate_3_1_b_in <= not_in_s(2) & in_s(1) & in_s(0);
  and_gate_3_1_b : and_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => and_gate_3_1_b_in,
      out_s => and_gate_3_1_b_out
      );
  or_gate_2_1 : or_gate PORT MAP (
    in_1  => and_gate_3_1_b_out,
    in_2  => and_gate_2_1_a_out,
    out_s => out_s_tmp(1)
    );

  -- out_s(2) <= in_s(2) and not(in_s(1)) and not(in_s(0))
  and_gate_3_2_in <= in_s(2) & not_in_s(1) & not_in_s(0);
  and_gate_3_2 : and_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => and_gate_3_2_in,
      out_s => out_s_tmp(2)
      );

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_booth_encoder_block_structural OF booth_encoder_block IS
  FOR structural
      FOR not_in_s_gate : not_gate_n USE CONFIGURATION work.cfg_not_gate_n_structural;
    END FOR;
for     xor_gate_2_0 : xor_gate use configuration work.cfg_xor_gate_behavioral;
end for;
for and_gate_2_1_a : and_gate use configuration work.cfg_and_gate_behavioral;
end for;
for and_gate_3_1_b : and_gate_single_n use configuration work.cfg_and_gate_n_behavioral;
end for;
for and_gate_3_2 : and_gate_single_n use configuration work.cfg_and_gate_n_behavioral;
end for;
  END FOR;
END CONFIGURATION;
