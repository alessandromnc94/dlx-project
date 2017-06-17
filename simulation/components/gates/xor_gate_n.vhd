LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_gate_n IS
  generic (
    n : integer := 1
  )
  PORT (
    in_1  : IN  STD_LOGIC_vector(n-1 downto 0);
    in_2  : IN  STD_LOGIC_vector(n-1 downto 0);
    out_s : OUT STD_LOGIC_vector(n-1 downto 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF xor_gate_n IS
BEGIN
  out_s <= in_1 xor in_2;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF xor_gate_n IS
  component xor_gate is 
  port (
    in_1 : in std_logic;
    in_2 : in std_logic;
    out_s : out std_logic
  );
  end component;

BEGIN
gate_gen : for i in 0 to n-1 generate
  xor_gate_x : xor_gate port map (
    in_1 => in_1(i),
    in_2 => in_2(i),
    out_s => out_s(i)
  );
  end generate;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_xor_gate_n_behavioral OF xor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_xor_gate_n_structural OF xor_gate_n IS
  FOR structural
    for gate_gen
      for xor_gate_x : xor_gate use configuration work.cfg_xor_gate_behavioral;
      end for;
    end for;
  END FOR;
END CONFIGURATION;
