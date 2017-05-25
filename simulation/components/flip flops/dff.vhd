LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dff IS
  PORT (
    d   : IN  STD_LOGIC;
    clk : IN  STD_LOGIC;
    rst : IN  STD_LOGIC;
    set : IN  STD_LOGIC;
    q   : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF dff IS
BEGIN

  PROCESS (clk, rst, set)
  BEGIN
-- asynchronous set and reset
    IF rst = '1' OR set = '1' THEN
      -- if rst and set are equal to '1'
      -- forbidden input
      IF rst = set THEN
        q <= 'x';
      ELSIF rst = '1'
        q <= '0';
    ELSE
      q <= '1';
    END IF;
  ELSIF rising_edge(clk) THEN
    q <= d;
  END IF;
END PROCESS;
END ARCHITECTURE;

CONFIGURATION cfg_dff_behavioral OF dff IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
