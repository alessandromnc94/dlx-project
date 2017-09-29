library ieee;

package mytypes is

  constant addrsize : integer := 32;
  subtype addregtype is std_logic_vector(addrsize-1 downto 0);

  constant regsize : integer := 32;
  subtype regtype is std_logic_vector(regsize-1 downto 0);

  constant zero : addregtype := (others => '0');

end package;
