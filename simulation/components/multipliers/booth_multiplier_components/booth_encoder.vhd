LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY booth_encoder IS
  GENERIC(
    n : INTEGER := 16
    );
  PORT(
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC_VECTOR(3*((n/2) + n MOD 2) - 1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- structural architecture
ARCHITECTURE structural OF booth_encoder IS
  COMPONENT booth_encoder_block IS
    PORT(
      in_s  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
      );
  END COMPONENT;

  CONSTANT n_encoders_block : INTEGER                                       := n/2 + n MOD 2;
  SIGNAL in_s_tmp           : STD_LOGIC_VECTOR(2*n_encoders_block DOWNTO 0) := (OTHERS => '0');
BEGIN
  in_s_tmp(n DOWNTO 1) <= in_s;

  blck_gen : FOR i IN 0 TO n_encoders_block-1 GENERATE
    blck_x : booth_encoder_block PORT MAP (
      in_s  => in_s_tmp(2*i+2 DOWNTO 2*i),
      out_s => out_s(2*i+2 DOWNTO 2*i)
      );
  END GENERATE;

END ARCHITECTURE;

-- configurations

-- structural configuration with behavioral components
CONFIGURATION cfg_booth_encoder_structural_1 OF booth_encoder IS
  FOR structural
  END FOR;
END CONFIGURATION;

-- structural configuration with structural components
CONFIGURATION cfg_booth_encoder_structural_2 OF booth_encoder IS
  FOR structural
  END FOR;
END CONFIGURATION;
