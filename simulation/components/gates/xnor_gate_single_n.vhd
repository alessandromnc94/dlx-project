LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xnor_gate_single_n IS
  GENERIC (
    n : INTEGER := 3
    );
  PORT (
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF xnor_gate_single_n IS
  SIGNAL tmp_out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
  tmp_out_s(0) <= in_s(0);
  xor_gates_gen : FOR i IN 1 TO n-1 GENERATE
    tmp_out_s(i) <= tmp_out_s(i-1) XOR in_s(i);
  END GENERATE;

  out_s <= NOT tmp_out_s(n-1);

-- it works only with vhdl 2008
-- out_s <= xnor i;

END ARCHITECTURE;

CONFIGURATION cfg_xnor_gate_single_n_behavioral OF xnor_gate_single_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
