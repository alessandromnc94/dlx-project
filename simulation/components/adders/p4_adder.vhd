LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY p4_adder IS
  GENERIC (
    n          : INTEGER := 32;
    carry_step : INTEGER := 4
    );
  PORT (
    in_1      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    in_2      : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_in  : IN  STD_LOGIC;
    sum       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    carry_out : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- structural architecture

ARCHITECTURE structural OF p4_adder IS

<<<<<<< HEAD
  COMPONENT p4_carries_generator IS
=======
  COMPONENT carries_generator IS
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2        : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      carry_in    : IN  STD_LOGIC;
      carries_out : OUT STD_LOGIC_VECTOR (n/carry_step DOWNTO 0)
      );
  END COMPONENT;

<<<<<<< HEAD
  COMPONENT p4_sum_generator IS
=======
  COMPONENT sum_generator IS
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      in_2       : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
<<<<<<< HEAD
      carries_in : IN  STD_LOGIC_VECTOR (n/carry_step DOWNTO 0);
=======
      carries_in : IN  STD_LOGIC_VECTOR (n/carry DOWNTO 0);
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      sum        : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
      );
  END COMPONENT;

<<<<<<< HEAD
  SIGNAL carries : STD_LOGIC_VECTOR (n/carry_step DOWNTO 0);

BEGIN

  carry_out <= carries(n/carry_step);

  cg : p4_carries_generator
=======
  SIGNAL carries : STD_LOGIC_VECTOR (n/carry DOWNTO 0);

BEGIN

  carry_out <= carries(n/carry);

  cg : carry_generator
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC MAP (
      n          => n,
      carry_step => carry_step
      )
    PORT MAP (
      in_1        => in_1,
      in_2        => in_2,
      carry_in    => carry_in,
      carries_out => carries
      );

<<<<<<< HEAD
  sg : p4_sum_generator
    GENERIC MAP (
      n          => n,
      carry_step => carry_step
=======
  sg : sum_generator
    GENERIC MAP (
      n     => n,
      carry => carry
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      )
    PORT MAP (
      in_1       => in_1,
      in_2       => in_2,
      carries_in => carries,
      sum        => sum
      );

END ARCHITECTURE;

-- configurations

-- structural configuration
CONFIGURATION cfg_p4_adder_structural OF p4_adder IS
  FOR structural
<<<<<<< HEAD
    FOR cg : p4_carries_generator
      USE CONFIGURATION work.cfg_p4_carries_generator_structural;
    END FOR;
    FOR sg : p4_sum_generator
      USE CONFIGURATION work.cfg_p4_sum_generator_structural;
=======
    FOR cg : carry_generator
      USE CONFIGURATION work.cfg_carry_generator_structural;
    END FOR;
    FOR sg : sum_generator
      USE CONFIGURATION work.cfg_sum_generator_structural;
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    END FOR;
  END FOR;
END CONFIGURATION;
