LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nand_gate_n IS
  GENERIC (
    n : INTEGER := 3
    );
  PORT (
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF nand_gate_n IS
  SIGNAL tmp_out_s : STD_LOGIC;
BEGIN
  tmp_out_s <= in_s(0);
  and_gates_gen : FOR i IN 1 TO n-1 GENERATE
    tmp_out_s <= tmp_out_s AND in_s(i);
  END GENERATE;

  out_s <= NOT tmp_out_s;

-- it works only with vhdl 2008
-- out_s <= nand i;
END ARCHITECTURE;

CONFIGURATION cfg_nand_gate_n_behavioral OF nand_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
