PACKAGE my_arith_functions IS
  FUNCTION log2int (
    n : INTEGER
    )
    RETURN INTEGER;
END PACKAGE;

PACKAGE BODY my_arith_functions IS
  FUNCTION log2int (
    n : INTEGER
    )
    RETURN INTEGER IS
    VARIABLE tmp : INTEGER := n;
    VARIABLE ret : INTEGER := 0;
  BEGIN
    WHILE tmp > 0 LOOP
      tmp := tmp/2;
      ret := ret + 1;
    END LOOP;
    RETURN ret;
  END FUNCTION;
END PACKAGE BODY;
