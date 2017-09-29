library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
  port (
    in_1      : in  std_logic;
    in_2      : in  std_logic;
    sum       : out std_logic;
    carry_out : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of half_adder is
begin
  sum       <= in_1 xor in_2;
  carry_out <= in_1 and in_2;
end architecture;

-- structural architecture
architecture structural of half_adder is

  component xor_gate is
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

begin
  s_gate : xor_gate port map (
    in_1  => in_1,
    in_2  => in_2,
    out_s => sum
    );
  c_out_gate : and_gate port map (
    in_1  => in_1,
    in_2  => in_2,
    out_s => carry_out
    );
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_half_adder_behavioral of half_adder is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_half_adder_structural of half_adder is
  for structural
    for s_gate         : xor_gate use configuration work.cfg_xor_gate_behavioral;
    end for;
    for carry_out_gate : and_gate use configuration work.cfg_and_gate_behavioral;
    end for;
  end for;
end configuration;
