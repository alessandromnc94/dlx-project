library ieee;
use ieee.std_logic_1164.all;

entity g_block is
  port (
    pg_l  : in  std_logic;
    g_l   : in  std_logic;
    g_r   : in  std_logic;
    g_out : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of g_block is
begin
  g_out <= (g_l) or (pg_l and g_r);
end architecture;

-- structural architecture
architecture structural of g_block is
  component or_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

  component and_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

  signal and_out : std_logic := '0';
begin
  g_and_gate : and_gate port map (
    in_1  => pg_l,
    in_2  => g_r,
    out_s => and_out
    );
  g_or_gate : or_gate port map (
    in_1  => g_l,
    in_2  => and_out,
    out_s => g_out
    );
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_g_block_behavioral of g_block is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_g_block_structural of g_block is
  for structural
    for g_and_gate : and_gate use configuration work.cfg_and_gate_behavioral;
    end for;
    for g_or_gate  : or_gate use configuration work.cfg_or_gate_behavioral;
    end for;
  end for;
end configuration;
