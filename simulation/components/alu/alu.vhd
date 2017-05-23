LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE iee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

USE work.alu_types.ALL;

ENTITY alu IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    i0     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i1     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    op_sel : IN  alu_array;
    o      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF alu IS
BEGIN
  PROCESS (ALL)
  BEGIN
    CASE op_sel IS
      WHEN alu_add => o <= i0 + i1;
      WHEN alu_sub => o <= i0 - i1;
      WHEN alu_and => o <= i0 AND i1;
      WHEN alu_or  => o <= i0 OR i1;
      WHEN OTHERS  => o <= (OTHERS => 'z');
    END CASE;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_alu_behavioral OF alu IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
