library ieee;
use ieee.std_logic_1164.all;

use work.logicals_types.all;

entity logicals_n is
  generic (
    n : natural := 8
    );
  port (
    in_1  : in  std_logic_vector(n-1 downto 0);
    in_2  : in  std_logic_vector(n-1 downto 0);
    logic : in  logicals_array;
    out_s : out std_logic_vector(n-1 downto 0)
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of logicals_n is
  signal not_in_1, not_in_2 : std_logic_vector(n-1 downto 0);
  signal nands_0            : std_logic_vector(n-1 downto 0);
  signal nands_1            : std_logic_vector(n-1 downto 0);
  signal nands_2            : std_logic_vector(n-1 downto 0);
  signal nands_3            : std_logic_vector(n-1 downto 0);
begin

  not_in_1 <= not in_1;
  not_in_2 <= not in_2;

  nands_0 <= not ((n-1 downto 0 => logic(0)) and not_in_1 and not_in_2);
  nands_1 <= not ((n-1 downto 0 => logic(1)) and not_in_1 and (in_2));
  nands_2 <= not ((n-1 downto 0 => logic(2)) and in_1 and not_in_2);
  nands_3 <= not ((n-1 downto 0 => logic(3)) and in_1 and in_2);

  out_s <= not (nands_0 and nands_1 and nands_2 and nands_3);

end architecture;

-- structural architecture
architecture structural of logicals_n is
  component logicals is
    port (
      in_1  : in  std_logic;
      in_2  : in  std_logic;
      logic : in  logicals_array;
      out_s : out std_logic
      );
  end component;

begin

  logicals_gen : for i in 0 to n-1 generate
    logicals_x : logicals port map (
      in_1  => in_1(i),
      in_2  => in_2(i),
      logic => logic,
      out_s => out_s(i)
      );
  end generate;

end architecture;

-- configurations

-- behavioral configuration
configuration cfg_logicals_n_behavioral of logicals_n is
  for behavioral
  end for;
end configuration;

-- structural configuration with behavioral components
configuration cfg_logicals_n_structural_1 of logicals_n is
  for structural
    for logicals_gen
      for logicals_x : logicals use configuration work.cfg_logicals_behavioral;
      end for;
    end for;
  end for;
end configuration;

-- structural configuration with structural components
configuration cfg_logicals_n_structural_2 of logicals_n is
  for structural
    for logicals_gen
      for logicals_x : logicals use configuration work.cfg_logicals_structural;
      end for;
    end for;
  end for;
end configuration;
