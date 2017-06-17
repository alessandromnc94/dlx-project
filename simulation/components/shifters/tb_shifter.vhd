LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_shifter IS
END ENTITY;

ARCHITECTURE behavioral OF tb_shifter IS
  CONSTANT n : INTEGER := 8;
  COMPONENT shifter IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      base_vector    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      shift_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      left_shift     : IN  STD_LOGIC;
      arith_shift    : IN  STD_LOGIC;
      out_s          : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL base_vector, shift_by_value, out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL left_shift, arith_shift            : STD_LOGIC;

BEGIN

  dut : shifter GENERIC MAP (
    n => n
    ) PORT MAP (
      base_vector    => base_vector,
      shift_by_value => shift_by_value,
      left_shift     => left_shift,
      arith_shift    => arith_shift,
      out_s          => out_s
      );

  PROCESS
  BEGIN

    base_vector                 <= (n-1 DOWNTO 0 => '0');
    base_vector(2)              <= '1';
    shift_by_value              <= (n-1 DOWNTO 2 => '0') & "01";
    left_shift                  <= '1';
    arith_shift                 <= '0';
    WAIT FOR 1 NS;
    left_shift                  <= '0';
    WAIT FOR 1 NS;
    arith_shift                 <= '1';
    WAIT FOR 1 NS;
    base_vector(n-1 DOWNTO n-2) <= "11";
    left_shift                  <= '1';
    arith_shift                 <= '0';
    WAIT FOR 1 NS;
    left_shift                  <= '0';
    WAIT FOR 1 NS;
    arith_shift                 <= '1';
    WAIT FOR 1 NS;
    ASSERT FALSE REPORT "Testbench finished!" SEVERITY FAILURE;
  END PROCESS;

END ARCHITECTURE;

CONFIGURATION cfg_tb_shifter_behavioral OF tb_shifter IS
  FOR behavioral
    FOR dut : shifter USE CONFIGURATION work.cfg_shifter_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
