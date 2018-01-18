library ieee;
use ieee.std_logic_1164.all;

entity branch_unit is
  generic (
    n1 : natural := 32
    );
  port (
    imm : in  std_logic_vector(n1-1 downto 0);  --from datapath
    reg : in  std_logic_vector(n1-1 downto 0);
    npc : in  std_logic_vector(n1-1 downto 0);
    be  : in  std_logic;                        --from cu
    jr  : in  std_logic;
    jmp : in  std_logic;
    pc  : out std_logic_vector(n1-1 downto 0)
    );
end entity;

architecture structural of branch_unit is

  component mux_n_2_1 is
    generic (
      n : natural := 1
      );
    port (
      in_0  : in  std_logic_vector(n-1 downto 0);
      in_1  : in  std_logic_vector(n-1 downto 0);
      s     : in  std_logic;
      out_s : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component zero_comparator is
    generic (
      n : natural := 8
      );
    port (
      in_s  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic
      );
  end component;

  component rca_n is
    generic (
      n : natural := 4
      );
    port (
      in_1      : in  std_logic_vector(n-1 downto 0);
      in_2      : in  std_logic_vector(n-1 downto 0);
      carry_in  : in  std_logic;
      sum       : out std_logic_vector(n-1 downto 0);
      carry_out : out std_logic
      );
  end component;

  component not_gate is
    port (
      in_s  : in  std_logic;
      out_s : out std_logic
      );
  end component;

  signal om1, os              : std_logic_vector(n1-1 downto 0);
  signal ocmp, oinv, om2, om3 : std_logic_vector(0 downto 0);

begin

  comp : zero_comparator generic map(n => n1)
    port map(reg, ocmp(0));
  add : rca_n generic map(n => n1)
    port map(npc, imm, '0', os, open);
  inv  : not_gate port map(ocmp(0), oinv(0));
  mux1 : mux_n_2_1 generic map(n => n1)
    port map(os, reg, jr, om1);
  mux2 : mux_n_2_1 generic map(n => 1)
    port map(oinv, ocmp, be, om2);
  mux3 : mux_n_2_1 generic map(n => 1)
    port map("0", om2, jmp, om3);
  mux4 : mux_n_2_1 generic map(n => n1)
    port map(npc, om1, om3(0), pc);

end architecture;
