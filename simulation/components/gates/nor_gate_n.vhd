library ieee;
use ieee.std_logic_1164.all;

entity nor_gate_n is
  generic (
    n : natural := 1
    )
    port (
      in_1  : in  std_logic_vector(n-1 downto 0);
      in_2  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic_vector(n-1 downto 0)
      );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of nor_gate_n is

  signal tmp_out_s : std_logic;
begin
  out_s <= in_1 nor in_2;
end architecture;

-- structural architecture
architecture structural of nor_gate_n is
  component nor_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

begin
  gate_gen : for i in 0 to n-1 generate
    nor_gate_x : nor_gate port map (
      in_1  => in_1(i),
      in_2  => in_2(i),
      out_s => out_s(i)
      );
  end generate;
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_nor_gate_n_behavioral of nor_gate_n is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_nor_gate_n_structural of nor_gate_n is
  for structural
    for gate_gen
      for nor_gate_x : nor_gate use configuration work.cfg_nor_gate_behavioral;
      end for;
    end for;
  end for;
end configuration;
