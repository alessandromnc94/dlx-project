LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY forwarding_unit IS
  GENERIC(
    n : INTEGER := 32;                  --address length
    m : INTEGER := 32                   --data length
    );
  PORT (
    arf1    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --addresses of regisers for the current operation 
    arf2    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    exear   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --adrress of reg in execute stage
    memar   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --adrress of reg in memory stage
    exed    : IN  STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data coming from execute stage
    memd    : IN  STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data coming from memory stage
    clk     : IN  STD_LOGIC;
    out_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    dout1   : OUT STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data to be forwarded
    dout2   : OUT STD_LOGIC_VECTOR(m-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE behavioral OF forwarding_unit IS

  TYPE addrarray IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  TYPE datarray IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(m-1 DOWNTO 0);

  SIGNAL ar, arf : addrarray;
  SIGNAL data_in : datarray;

  CONSTANT zero : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

  PROCESS(clk)

    VARIABLE data_out : datarray;

  BEGIN

    ar(0) <= exear;
    ar(1) <= memar;

    arf(0) <= arf1;
    arf(1) <= arf2;

    data_in(0) <= exed;
    data_in(1) <= memd;

    IF(rising_edge(clk)) THEN
      out_mux(0) <= '0';                  --set both the muxes at normal flow
      out_mux(1) <= '0';
      FOR i IN 0 TO 1 LOOP
        FOR j IN 0 TO 1 LOOP
          IF(arf(j) /= zero) THEN
            IF(arf(j) = ar(i)) THEN
              out_mux(j)  <= '1';         --set desired mux at forwarding mode
              data_out(j) := data_in(i);  --forward corresponding data
            END IF;
          END IF;
        END LOOP;
      END LOOP;
      dout1 <= data_out(0);
      dout2 <= data_out(1);
    END IF;

  END PROCESS;

END ARCHITECTURE;
