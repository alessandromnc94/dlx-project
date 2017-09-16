LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nand_gate_n IS
  GENERIC (
    n : INTEGER := 1
    );
  PORT (
    in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF nand_gate_n IS
  SIGNAL tmp_out_s : STD_LOGIC;
BEGIN
  out_s <= in_1 NAND in_2;
END ARCHITECTURE;

CONFIGURATION cfg_nand_gate_n_behavioral OF nand_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
-- configuration cfg_nand_gate_n_structural of nand_gate_n is
--   for structural
--     for gate_gen
--       for nand_gate_x : nand_gate use configuration work.cfg_nand_gate_behavioral;
--       end for;
--     end for;
--   end for;
-- end configuration;
