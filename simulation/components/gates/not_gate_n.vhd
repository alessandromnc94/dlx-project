library ieee;
use ieee.std_logic_1164.all;

entity not_gate_n is
  generic (
    n : integer := 1
    );
  port (
    in_s  : in  std_logic_vector(n-1 downto 0);
    out_s : out std_logic_vector(n-1 downto 0)
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of not_gate_n is
begin
  out_s <= not in_s;
end architecture;

-- structural architecture
architecture structural of not_gate_n is
  component not_gate is
    port (
      in_s  : in  std_logic;
      out_s : out std_logic
      );
  end component;

begin
  gate_gen : for i in 0 to n-1 generate
    not_gate_x : not_gate port map (
      in_s  => in_s(i),
      out_s => out_s(i)
      );
  end generate;
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_not_gate_n_behavioral of not_gate_n is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_not_gate_n_structural of not_gate_n is
  for structural
    for gate_gen
      for not_gate_x : not_gate use configuration work.cfg_not_gate_behavioral;
      end for;
    end for;
  end for;
end configuration;
