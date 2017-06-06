LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constants.ALL;

ENTITY carry_select_block IS
  GENERIC (
    n : INTEGER := 32
    );
  PORT (
    in_1  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    c_sel : IN  STD_LOGIC;
    sum   : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF carry_select_block IS

  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      a  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      b  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      ci : IN  STD_LOGIC;
      s  : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      co : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT mux21_generic IS
    GENERIC (
      n : INTEGER                       -- ;
     -- delay_mux : time    := tp_mux
      );
    PORT (
      data0 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      data1 : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      sel   : IN  STD_LOGIC;
      o     : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL sum_0, sum_1 : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
BEGIN
  rca_0 : rca_generic
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      a  => a,
      b  => b,
      ci => '0',
      s  => sum_0,
      co => OPEN
      );

  rca_1 : rca_generic
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      a  => a,
      b  => b,
      ci => '1',
      s  => sum_1,
      co => OPEN
      );

  mux : mux21_generic
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      data0 => sum_0,
      data1 => sum_1,
      sel   => c_sel,
      o     => sum
      );
END ARCHITECTURE;


CONFIGURATION cfg_carry_select_block_structural OF carry_select_block IS

  FOR structural
    FOR mux : mux21_generic
      USE CONFIGURATION work.cfg_mux21_generic_structural;
    END FOR;

    FOR rca_0 : rca_generic
      USE CONFIGURATION work.cfg_rca_generic_structural;
    END FOR;

    FOR rca_1 : rca_generic
      USE CONFIGURATION work.cfg_rca_generic_structural;
    END FOR;

  END FOR;

END CONFIGURATION;
