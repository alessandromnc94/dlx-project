LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY p4_carry_select_block IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    in_1      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_sel : IN  STD_LOGIC;
    sum       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF p4_carry_select_block IS

  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT mux_n_2_1 IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      s     : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL sum_0, sum_1 : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
BEGIN
  rca_0 : rca_n
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      in_1      => in_1,
      in_2      => in_2,
      carry_in  => '0',
      sum       => sum_0,
      carry_out => OPEN
      );

  rca_1 : rca_n
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      in_1      => in_1,
      in_2      => in_2,
      carry_in  => '1',
      sum       => sum_1,
      carry_out => OPEN
      );

  mux : mux_n_2_1
    GENERIC MAP (
      n => n
      )
    PORT MAP (
      in_0  => sum_0,
      in_1  => sum_1,
      s     => carry_sel,
      out_s => sum
      );
END ARCHITECTURE;


CONFIGURATION cfg_p4_carry_select_block_structural OF p4_carry_select_block IS

  FOR structural
    FOR mux : mux_n_2_1
      USE CONFIGURATION work.cfg_mux_n_2_1_structural;
    END FOR;

    FOR rca_0 : rca_n
      USE CONFIGURATION work.cfg_rca_n_structural_1;
    END FOR;

    FOR rca_1 : rca_n
      USE CONFIGURATION work.cfg_rca_n_structural_2;
    END FOR;

  END FOR;

END CONFIGURATION;
