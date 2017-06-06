LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparator IS
  PORT (
    zero_out  : IN  STD_LOGIC;
    carry_out : IN  STD_LOGIC;
    eq_out    : OUT STD_LOGIC;
    gr_out    : OUT STD_LOGIC;
    lo_out    : OUT STD_LOGIC;
    ge_out    : OUT STD_LOGIC;
    le_out    : OUT STD_LOGIC;
    ne_out    : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF comparator IS
BEGIN
  eq_out <= zero_out;
  ne_out <= NOT zero_out;
  ge_out <= carry_out;
  lo_out <= NOT carry_out;
  gr_out <= (NOT zero_out) AND carry;
  le_out <= (NOT carry_out) OR zero_out;

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_comparator_behavioral OF comparator IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
