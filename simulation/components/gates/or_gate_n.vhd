LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_gate IS
  PORT (
    in_1  : IN  STD_LOGIC;
    in_2  : IN  STD_LOGIC;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF or_gate IS
  SIGNAL tmp_out_s : STD_LOGIC;
BEGIN
  tmp_out_s <= i(0);
  or_gates_gen : FOR j IN 1 TO n-1 GENERATE
    tmp_out_s <= tmp_out_s OR i(j);
  END GENERATE;

  out_s <= tmp_out_s;

--  it works only with vhdl 2008
--  out_s <= or i;
END ARCHITECTURE;

CONFIGURATION cfg_or_gate_behavioral OF or_gate IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
