library ieee;
use ieee.std_logic_1164.all;

entity register_n is
  generic (
    n : natural := 8
    );
  port (
    din  : in  std_logic_vector(n-1 downto 0);
    clk  : in  std_logic;
    rst  : in  std_logic;
    set  : in  std_logic;
    en   : in  std_logic;
    dout : out std_logic_vector(n-1 downto 0)
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of register_n is
begin

  process (clk, rst, set)
  begin
-- asynchronous set and reset
    if rst = '1' or set = '1' then
      -- if rst and set are equal to '1'
      -- forbidden input
      if rst = set then
        dout <= (others => 'X');
      elsif rst = '1' then
        dout <= (others => '0');
      else
        dout <= (others => '1');
      end if;
    elsif rising_edge(clk) and en = '1' then
      dout <= din;
    end if;
  end process;
end architecture;

-- structural architecture
architecture structural of register_n is

  component dff is
    port (
      d   : in  std_logic;
      clk : in  std_logic;
      rst : in  std_logic;
      set : in  std_logic;
      en  : in  std_logic;
      q   : out std_logic
      );
  end component;

begin

  dff_generation : for i in 0 to n-1 generate
    dffx : dff
      port map (
        d   => din(i),
        clk => clk,
        rst => rst,
        set => set,
        en  => en,
        q   => dout(i)
        );
  end generate;
end architecture;

-- configurations

configuration cfg_register_n_behavioral of register_n is
  for behavioral
  end for;
end configuration;

configuration cfg_register_n_structural of register_n is
  for structural
    for dff_generation
      for dffx : dff
        use configuration work.cfg_dff_behavioral;
      end for;
    end for;
  end for;
end configuration;
