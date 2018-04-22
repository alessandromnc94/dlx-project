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
    bnez  : in  std_logic;                        --from cu
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
    signal do_branch, do_jump : std_logic;

begin
-- TODO
do_branch <= be and (bnez xor ocmp(0)); -- 
  do_jump <= do_branch or jmp;

  comp : zero_comparator generic map(n => n1)
    port map(reg, ocmp(0)); -- ocmp = "1" if reg == "0"s
  add : rca_n generic map(n => n1)
    port map(npc, imm, '0', os, open); -- os = npc+imm
  -- inv  : not_gate port map(ocmp(0), oinv(0)); -- oinv = ! ocmp = reg != "0"s -- USE do_branch
  mux1 : mux_n_2_1 generic map(n => n1)
    port map(os, reg, jr, om1); -- om1 = reg if jr = 1 else os
  -- mux2 : mux_n_2_1 generic map(n => 1)
    -- port map(ocmp, oinv,  bnez, om2); -- USE do_branch
  -- mux3 : mux_n_2_1 generic map(n => 1)
    -- port map("0", om2, jmp, om3); -- USE do_jump
  mux4 : mux_n_2_1 generic map(n => n1)
    port map(npc, om1, do_jump, pc); -- ????

end architecture;
