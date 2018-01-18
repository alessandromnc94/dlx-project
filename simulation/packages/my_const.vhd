library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


package my_const is

  constant n_bit : natural := 32;  --size of instruction and data memories and width of each register

  constant aconst     : std_logic_vector(n_bit-1 downto 0) := conv_std_logic_vector(4, n_bit);
  constant offconst   : std_logic_vector(n_bit-1 downto 0) := conv_std_logic_vector(8, n_bit);
  constant raddrconst : std_logic_vector(n_bit-1 downto 0) := conv_std_logic_vector(31, n_bit);

end package;
