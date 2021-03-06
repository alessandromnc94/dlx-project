library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port (
    in_1      : in  std_logic;
    in_2      : in  std_logic;
    carry_in  : in  std_logic;
    sum       : out std_logic;
    carry_out : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of full_adder is
begin
  sum       <= in_1 xor in_2 xor carry_in;
  carry_out <= (in_1 and (in_2 xor carry_in)) or (in_2 and carry_in);
end architecture;

-- structural architecture
architecture structural of full_adder is

  component xor_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

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

  signal in_2_xor_carry_in, in_2_and_carry_in, in_1_and_in_2_xor_carry_in : std_logic := '0';

begin
  in_2_xor_carry_in_gate : xor_gate port map (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => in_2_xor_carry_in
    );
  sum_xor_gate : xor_gate port map(
    in_1  => in_1,
    in_2  => in_2_xor_carry_in,
    out_s => sum
    );
  in_1_and_in_2_xor_carry_in_gate : and_gate port map (
    in_1  => in_1,
    in_2  => in_2_xor_carry_in,
    out_s => in_1_and_in_2_xor_carry_in
    );
  in_2_and_carry_in_gate : and_gate port map (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => in_2_and_carry_in
    );
  carry_out_or_gate : or_gate port map (
    in_1  => in_1_and_in_2_xor_carry_in,
    in_2  => in_2_and_carry_in,
    out_s => carry_out
    );
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_full_adder_behavioral of full_adder is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_full_adder_structural of full_adder is
  for structural
    for in_2_xor_carry_in_gate          : xor_gate use configuration work.cfg_xor_gate_behavioral;
    end for;
    for sum_xor_gate                    : xor_gate use configuration work.cfg_xor_gate_behavioral;
    end for;
    for in_2_and_carry_in_gate          : and_gate use configuration work.cfg_and_gate_behavioral;
    end for;
    for in_1_and_in_2_xor_carry_in_gate : and_gate use configuration work.cfg_and_gate_behavioral;
    end for;
    for carry_out_or_gate               : or_gate use configuration work.cfg_or_gate_behavioral;
    end for;
  end for;
end configuration;
