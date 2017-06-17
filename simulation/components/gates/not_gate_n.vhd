LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate_n IS
  generic (
    n : integer := 1
  )
  PORT (
    in_s  : IN  STD_LOGIC_vector(n-1 downto 0);
    out_s : OUT STD_LOGIC_vector(n-1 downto 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF not_gate_n IS
BEGIN
  out_s <= not in_s;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF not_gate_n IS
  component not_gate is 
  port (
    in_s : in std_logic;
    out_s : out std_logic
  );
  end component;

BEGIN
gate_gen : for i in 0 to n-1 generate
  not_gate_x : not_gate port map (
    in_s => in_s(i),
    out_s => out_s(i)
  );
  end generate;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_not_gate_n_behavioral OF not_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_not_gate_n_structural OF not_gate_n IS
  FOR structural
    for gate_gen
      for not_gate_x : not_gate use configuration work.cfg_not_gate_behavioral;
      end for;
    end for;
  END FOR;
END CONFIGURATION;
