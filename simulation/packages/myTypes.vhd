LIBRARY ieee;

PACKAGE myTypes IS
  
  CONSTANT addrsize : INTEGER    := 32;
  SUBTYPE  addregtype IS STD_LOGIC_VECTOR(addrsize-1 DOWNTO 0);
  
  CONSTANT regsize  : INTEGER    := 32;
  SUBTYPE  regtype IS STD_LOGIC_VECTOR(regsize-1 DOWNTO 0);
  
  CONSTANT zero     : addregtype := (OTHERS => '0');
  
END PACKAGE;