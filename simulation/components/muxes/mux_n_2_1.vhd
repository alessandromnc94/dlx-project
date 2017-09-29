library ieee;
use ieee.std_logic_1164.all;

entity mux_n_2_1 is
  generic (
    n : integer := 1
    );
  port (
    in_0  : in  std_logic_vector(n-1 downto 0);
    in_1  : in  std_logic_vector(n-1 downto 0);
    s     : in  std_logic;
    out_s : out std_logic_vector(n-1 downto 0)
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of mux_n_2_1 is
begin
  out_s <= in_0 when s = '0' else in_1;
end architecture;

-- structural architecture
architecture structural of mux_n_2_1 is

  component and_gate_n is
    generic (
      n : integer
      );
    port (
      in_1  : in  std_logic_vector(n-1 downto 0);
      in_2  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component or_gate_n is
    generic (
      n : integer
      );
    port (
      in_1  : in  std_logic_vector(n-1 downto 0);
      in_2  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component not_gate is
    port (
      in_s  : in  std_logic;
      out_s : out std_logic
      );
  end component;

  signal not_sel, sel               : std_logic_vector(n-1 downto 0) := (others => '0');
  signal in_0_and_out, in_1_and_out : std_logic_vector(n-1 downto 0) := (others => '0');

begin

  sel <= (others => s);
  not_sel_generate : for i in 1 to n-1 generate
    not_sel(i) <= not_sel(0);
  end generate;

  not_sel_gate : not_gate
    port map(
      in_s  => s,
      out_s => not_sel(0)
      );

  in_0_and_gate_n : and_gate_n generic map (
    n => n
    ) port map (
      in_1  => in_0,
      in_2  => not_sel,
      out_s => in_0_and_out
      );

  in_1_and_gate_n : and_gate_n generic map (
    n => n
    ) port map (
      in_1  => in_1,
      in_2  => sel,
      out_s => in_1_and_out
      );

  out_or_gate_n : or_gate_n generic map (
    n => n
    ) port map (
      in_1  => in_0_and_out,
      in_2  => in_1_and_out,
      out_s => out_s
      );

end architecture;

-- configurations

configuration cfg_mux_n_2_1_behavioral of mux_n_2_1 is
  for behavioral
  end for;
end configuration;

configuration cfg_mux_n_2_1_structural of mux_n_2_1 is
  for structural
    for not_sel_gate    : not_gate use configuration work.cfg_not_gate_behavioral;
    end for;
    for in_0_and_gate_n : and_gate_n use configuration work.cfg_and_gate_n_behavioral;
    end for;
    for in_1_and_gate_n : and_gate_n use configuration work.cfg_and_gate_n_behavioral;
    end for;
    for out_or_gate_n   : or_gate_n use configuration work.cfg_or_gate_n_behavioral;
    end for;
  end for;
end configuration;
