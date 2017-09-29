library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity register_file is
  generic (
    width_add  : integer := 5;
    width_data : integer := 64
    );
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    enable  : in  std_logic;
    rd1     : in  std_logic;
    rd2     : in  std_logic;
    wr      : in  std_logic;
    add_wr  : in  std_logic_vector(width_add-1 downto 0);
    add_rd1 : in  std_logic_vector(width_add-1 downto 0);
    add_rd2 : in  std_logic_vector(width_add-1 downto 0);
    datain  : in  std_logic_vector(width_data-1 downto 0);
    out1    : out std_logic_vector(width_data-1 downto 0);
    out2    : out std_logic_vector(width_data-1 downto 0)
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of register_file is

  -- define type for registers array
  type reg_array is (natural range <>) of std_logic_vector(width_data-1 downto 0);

  signal registers : reg_array(0 to 2**width_add-1) := (others => (others => '0'));

begin
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        out1      <= (others => 'z');
        out2      <= (others => 'z');
        registers <= (others => (others => '0'));
      elsif enable = '1' then
        if wr = '1' then
          registers(conv_integer(add_wr)) <= datain;
        end if;
        if rd1 = '1' then
          out1 <= registers(conv_integer(add_rd1));
        end if;
        if rd2 = '1' then
          out2 <= registers(conv_integer(add_rd2));
        end if;
      end if;
    end if;
  end process;
end architecture;

-- configurations

-- behavioral configuration
configuration cfg_register_file_behavioral of register_file is
  for behavioral
  end for;
end configuration;
