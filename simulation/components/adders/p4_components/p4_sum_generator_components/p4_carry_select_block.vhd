LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
<<<<<<< HEAD

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
=======
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
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f

  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
<<<<<<< HEAD
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
=======
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
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      );
  END COMPONENT;

  SIGNAL sum_0, sum_1 : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
BEGIN
<<<<<<< HEAD
  rca_0 : rca_n
=======
  rca_0 : rca_generic
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC MAP (
      n => n
      )
    PORT MAP (
<<<<<<< HEAD
      in_1      => in_1,
      in_2      => in_2,
      carry_in  => '0',
      sum       => sum_0,
      carry_out => OPEN
      );

  rca_1 : rca_n
=======
      a  => a,
      b  => b,
      ci => '0',
      s  => sum_0,
      co => OPEN
      );

  rca_1 : rca_generic
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC MAP (
      n => n
      )
    PORT MAP (
<<<<<<< HEAD
      in_1      => in_1,
      in_2      => in_2,
      carry_in  => '1',
      sum       => sum_1,
      carry_out => OPEN
      );

  mux : mux_n_2_1
=======
      a  => a,
      b  => b,
      ci => '1',
      s  => sum_1,
      co => OPEN
      );

  mux : mux21_generic
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC MAP (
      n => n
      )
    PORT MAP (
<<<<<<< HEAD
      in_0  => sum_0,
      in_1  => sum_1,
      s     => carry_sel,
      out_s => sum
=======
      data0 => sum_0,
      data1 => sum_1,
      sel   => c_sel,
      o     => sum
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      );
END ARCHITECTURE;


<<<<<<< HEAD
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
=======
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
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    END FOR;

  END FOR;

END CONFIGURATION;
