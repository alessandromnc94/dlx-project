library ieee;
use ieee.std_logic_1164.all;

entity mask is
  generic (
    n : natural := 32
    );
  port (
    a           : in  std_logic_vector(n-1 downto 0);
    sel         : in  std_logic;
    sign_extend : in  std_logic;
    b           : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture behavioral of mask is

  signal n1, a1 : std_logic_vector(n-1 downto 0);

begin

  process(a, sel, sign_extend)

  begin

    for i in 0 to n-1 loop
      n1(i) <= (not sel) and a(i);
    end loop;

    for i in 0 to n-1 loop
      a1(i) <= sel and a(i) and sign_extend;
    end loop;

    b <= n1 or a1;
  end process;

end architecture;

architecture structural of mask is

  component and_gate is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      out_s : out std_logic
      );
  end component;

  component or_gate_n is
    generic (
      n : natural := 1
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

  signal a1, a2, a3 : std_logic_vector(n-1 downto 0);
  signal nsel       : std_logic;

begin

  not1 : not_gate port map(sel, nsel);

  and1 : for i in 0 to n-1 generate
    and1_x : and_gate port map(nsel, a(i), a1(i));
    and2_x : and_gate port map(sel, a(i), a2(i));
    and3_x : and_gate port map(a2(i), sign_extend, a3(i));
  end generate;

  or1 : or_gate_n generic map(n => n)
    port map(a1, a3, b);

end architecture;

configuration cfg_mask_behavioral of mask is
  for behavioral
  end for;
end configuration;

configuration cfg_mask_structural of mask is
  for structural
    for not1 : not_gate use configuration work.cfg_not_gate_behavioral;
    end for;
    for and1
      for and1_x : and_gate use configuration work.cfg_and_gate_behavioral;
      end for;
      for and2_x : and_gate use configuration work.cfg_and_gate_behavioral;
      end for;
      for and3_x : and_gate use configuration work.cfg_and_gate_behavioral;
      end for;
    end for;
    for or1 : or_gate_n use configuration work.cfg_or_gate_n_behavioral;
    end for;
  end for;
end configuration;
