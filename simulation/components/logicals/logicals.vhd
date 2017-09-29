library ieee;
use ieee.std_logic_1164.all;

use work.logicals_types.all;

entity logicals is
  port (
    in_1  : in  std_logic;
    in_2  : in  std_logic;
    logic : in  logicals_array;
    out_s : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of logicals is
  signal nand_0 : std_logic;
  signal nand_1 : std_logic;
  signal nand_2 : std_logic;
  signal nand_3 : std_logic;
begin

  nand_0 <= not (logic(0) and (not in_1) and (not in_2));
  nand_1 <= not (logic(1) and (not in_1) and (in_2));
  nand_2 <= not (logic(2) and (in_1) and (not in_2));
  nand_3 <= not (logic(3) and (in_1) and (in_2));

  out_s <= not (nand_0 and nand_1 and nand_2 and nand_3);

end architecture;

-- structural architecture
architecture structural of logicals is
  component nand_gate_single_n is
    generic (
      n : integer
      );
    port (
      in_s  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic
      );
  end component;

  component not_gate is
    port (
      in_s  : in  std_logic;
      out_s : out std_logic
      );
  end component;


  signal nand_0, nand_1, nand_2, nand_3 : std_logic_vector(2 downto 0) := (others => '0');

  signal not_in_1, not_in_2 : std_logic                    := '0';
  signal nand_outputs       : std_logic_vector(3 downto 0) := (others => '0');
begin

  not_in_1_gate : not_gate port map (
    in_s  => in_1,
    out_s => not_in_1
    );

  not_in_2_gate : not_gate port map (
    in_s  => in_2,
    out_s => not_in_2
    );

-- nand:   (s0)(not in_1)(not in_2)
  nand_0 <= logic(0)&not_in_1&not_in_2;
  nand_gate_3_0 : nand_gate_single_n generic map (
    n => 3
    ) port map (
      in_s  => nand_0,
      out_s => nand_outputs(0)
      );

-- nand:   (s1)(not in_1)(in_2)
  nand_1 <= logic(1)&not_in_1&in_2;
  nand_gate_3_1 : nand_gate_single_n generic map (
    n => 3
    ) port map (
      in_s  => nand_1,
      out_s => nand_outputs(1)
      );

-- nand:   (s2)(in_1)(not in_2)
  nand_2 <= logic(2)&in_1&not_in_2;
  nand_gate_3_2 : nand_gate_single_n generic map (
    n => 3
    ) port map (
      in_s  => nand_2,
      out_s => nand_outputs(2)
      );

-- nand:   (s3)(in_1)(in_2)
  nand_3 <= logic(3)&in_1&in_2;
  nand_gate_3_3 : nand_gate_single_n generic map (
    n => 3
    ) port map (
      in_s  => nand_3,
      out_s => nand_outputs(3)
      );

-- last nand with 4 inputs from previous nands
  nand_gate_4_fin : nand_gate_single_n generic map (
    n => 4
    ) port map (
      in_s  => nand_outputs,
      out_s => out_s
      );

end architecture;

-- configurations

-- behavioral configuration
configuration cfg_logicals_behavioral of logicals is
  for behavioral
  end for;
end configuration;

-- structural configuration
configuration cfg_logicals_structural of logicals is
  for structural
    for not_in_1_gate   : not_gate use configuration work.cfg_not_gate_behavioral;
    end for;
    for not_in_2_gate   : not_gate use configuration work.cfg_not_gate_behavioral;
    end for;
    for nand_gate_3_0   : nand_gate_single_n use configuration work.cfg_nand_gate_single_n_behavioral;
    end for;
    for nand_gate_3_1   : nand_gate_single_n use configuration work.cfg_nand_gate_single_n_behavioral;
    end for;
    for nand_gate_3_2   : nand_gate_single_n use configuration work.cfg_nand_gate_single_n_behavioral;
    end for;
    for nand_gate_3_3   : nand_gate_single_n use configuration work.cfg_nand_gate_single_n_behavioral;
    end for;
    for nand_gate_4_fin : nand_gate_single_n use configuration work.cfg_nand_gate_single_n_behavioral;
    end for;
  end for;
end configuration;
