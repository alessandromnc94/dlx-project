LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_rotator IS
END ENTITY;

ARCHITECTURE behavioral OF tb_rotator IS
  CONSTANT n : INTEGER := 4;
  COMPONENT rotator IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      base_vector     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      rotate_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      left_rotation   : IN  STD_LOGIC;
      out_s           : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL base_vector, rotate_by_value, out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL left_rotation                       : STD_LOGIC;

BEGIN

  dut : rotator GENERIC MAP (
    n => n
    ) PORT MAP (
      base_vector     => base_vector,
      rotate_by_value => rotate_by_value,
      left_rotation   => left_rotation,
      out_s           => out_s
      );

  PROCESS
  BEGIN

    base_vector                 <= (n-1 DOWNTO 0 => '0');
    base_vector(2)              <= '1';
    rotate_by_value             <= (n-1 DOWNTO 2 => '0') & "11";
    left_rotation               <= '1';
    WAIT FOR 1 NS;
    left_rotation               <= '0';
    WAIT FOR 1 NS;
    base_vector(n-1 DOWNTO n-2) <= "11";
    left_rotation               <= '1';
    WAIT FOR 1 NS;
    left_rotation               <= '0';
    WAIT FOR 1 NS;
    ASSERT FALSE REPORT "testbench finished!" SEVERITY FAILURE;
  END PROCESS;

END ARCHITECTURE;

CONFIGURATION cfg_tb_rotator_behavioral OF tb_rotator IS
  FOR behavioral
    FOR dut : rotator USE CONFIGURATION work.cfg_rotator_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
