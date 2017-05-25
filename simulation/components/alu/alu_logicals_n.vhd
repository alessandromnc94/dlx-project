LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.alu_logicals_types.ALL;

ENTITY alu_logicals_n IS
  GENERIC (
    n : INTEGER : 8
    );
  PORT (
    i1    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i2    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    logic : IN  alu_logicals_n_array;
    o     : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF alu_logicals_n IS
BEGIN

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF alu_logicals_n IS
BEGIN

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_alu_logicals_n_behavioral OF alu_logicals_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration with behavioral components
CONFIGURATION cfg_alu_logicals_n_structural_1 OF alu_logicals_n IS
  FOR structural
  END FOR;
END CONFIGURATION;

-- structural configuration with structural components
CONFIGURATION cfg_alu_logicals_n_structural_2 OF alu_logicals_n IS
  FOR structural
  END FOR;
END CONFIGURATION;
