library ieee;
use ieee.math_real.all;

package my_arith_functions is
  function log2int (
    n : integer
    )
    return integer;
  function log2int_own (
    n : integer
    )
    return integer;
end package;

package body my_arith_functions is
  function log2int (
    n : integer
    ) return integer is
  begin
    return integer(ceil(log2(real(n))));

  end function;

  function log2int_own (
    n : integer
    )
    return integer is
    variable tmp : integer := n;
    variable ret : integer := 0;
  begin
    while tmp > 0 loop
      tmp := tmp/2;
      ret := ret + 1;
    end loop;
    return ret;
  end function;
end package body;
