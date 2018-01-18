library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity divider is
  generic (
    n : natural := 8
    )
    port (
      in_1  : in  std_logic_vector(n-1 downto 0);
      in_2  : in  std_logic_vector(n-1 downto 0);
      out_s : out std_logic_vector(n-1 downto 0)
      );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of divider is

begin
  out_s <= in_1 / in_2;
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_divider_behavioral of divider is
  for behavioral
  end for;
end configuration;
