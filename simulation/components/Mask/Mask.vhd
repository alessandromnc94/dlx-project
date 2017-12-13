library ieee;
use ieee.std_logic_1164.all;

entity mask is
  generic (
    n : integer := 32
    );
  port (
    a           : in  std_logic_vector(n-1 downto 0);
    sel         : in  std_logic_vector(1 downto 0);
    sign_extend : in  std_logic;
    b           : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture behavioral of mask is

begin

  process(a, sel)

  begin

    case sel is

      when "00"   => b                <= a;
      when "01"   => b(n-1 downto 8)  <= (others => a(7) and sign_extend); b(7 downto 0) <= a(7 downto 0);
      when "10"   => b(n-1 downto 16) <= (others => a(15) and sign_extend); b(15 downto 0) <= a(15 downto 0);
      when others => b                <= a;

    end case;

  end process;

end architecture;
