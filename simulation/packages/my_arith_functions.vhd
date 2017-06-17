LIBRARY ieee;
USE ieee.math_real.ALL;

PACKAGE my_arith_functions IS
  FUNCTION log2int (
    n : INTEGER
    )
    RETURN INTEGER;
  FUNCTION log2int_own (
    n : INTEGER
    )
    RETURN INTEGER;
END PACKAGE;

PACKAGE BODY my_arith_functions IS
  FUNCTION log2int (
    n : INTEGER
    ) RETURN INTEGER IS
  BEGIN
    RETURN INTEGER(ceil(log2(REAL(n))));

  END FUNCTION;

  FUNCTION log2int_own (
    n : INTEGER
    )
    RETURN INTEGER IS
    VARIABLE tmp : INTEGER := n;
    VARIABLE ret : INTEGER := 0;
  BEGIN
    WHILE tmp > 1 LOOP
      tmp := tmp/2;
      ret := ret + 1;
    END LOOP;
    RETURN ret;
  END FUNCTION;
END PACKAGE BODY;
