LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparator IS
  PORT (
    zero_out          : IN  STD_LOGIC;
    carry_out         : IN  STD_LOGIC;
    signed_comparison : IN  STD_LOGIC;
    eq_out            : OUT STD_LOGIC;
    gr_out            : OUT STD_LOGIC;
    lo_out            : OUT STD_LOGIC;
    ge_out            : OUT STD_LOGIC;
    le_out            : OUT STD_LOGIC;
    ne_out            : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF comparator IS
  SIGNAL c_out : STD_LOGIC;

BEGIN
-- unsigned comparison needs the value of carry_out
-- signed comparison needs the negate value of carry_out
  c_out  <= signed_comparison XOR carry_out;
  eq_out <= zero_out;
  ne_out <= NOT zero_out;
  ge_out <= c_out;
  lo_out <= NOT c_out;
  gr_out <= (NOT zero_out) AND c_out;
  le_out <= (NOT c_out) OR zero_out;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_comparator_behavioral OF comparator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
