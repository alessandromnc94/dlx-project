library ieee;
use ieee.std_logic_1164.all;

entity pg_network_block is
  port (
    in_1 : in  std_logic;
    in_2 : in  std_logic;
    pg   : out std_logic;
    g    : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of pg_network_block is

begin

  g  <= in_1 and in_2;
  pg <= in_1 xor in_2;

end architecture;

-- structural architecture
architecture structural of pg_network_block is

  component and_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;
  component xor_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

begin
  g_and_gate : and_gate port map (
    in_1  => in_1,
    in_2  => in_2,
    out_s => g
    );
  pg_xor_gate : xor_gate port map (
    in_1  => in_1,
    in_2  => in_2,
    out_s => pg
    );

end architecture;

-- configurations

-- behavioral configuration
configuration cfg_pg_network_block_behavioral of pg_network_block is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_pg_network_block_structural of pg_network_block is
  for structural
    for g_and_gate  : and_gate use configuration work.cfg_and_gate_behavioral;
    end for;
    for pg_xor_gate : xor_gate use configuration work.cfg_xor_gate_behavioral;
    end for;
  end for;
end configuration;
