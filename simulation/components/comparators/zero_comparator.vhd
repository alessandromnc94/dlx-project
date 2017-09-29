library ieee;
use ieee.std_logic_1164.all;

entity zero_comparator is
  generic (
    n : integer := 8
    );
  port (
    in_s  : in  std_logic_vector(n-1 downto 0);
    out_s : out std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of zero_comparator is
begin

  out_s <= '1' when in_s = (n-1 downto 0 => '0') else
           '0';

end architecture;

-- configurations

-- behavioral configuration
configuration cfg_zero_comparator_behavioral of zero_comparator is
  for behavioral
  end for;
end configuration;
