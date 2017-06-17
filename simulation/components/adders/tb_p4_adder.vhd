LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY tb_p4_adder IS
END ENTITY;

ARCHITECTURE behavioral OF tb_p4_adder IS
  CONSTANT n : INTEGER := 32;
  COMPONENT p4_adder IS
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

  SIGNAL in_1, in_2, sum     : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL carry_in, carry_out : STD_LOGIC;


BEGIN

  dut : p4_adder GENERIC MAP (
    n => n
    ) PORT MAP (
      in_1      => in_1,
      in_2      => in_2,
      carry_in  => carry_in,
      sum       => sum,
      carry_out => carry_out
      );

  PROCESS
  BEGIN
    FOR c IN 0 TO 1 LOOP
      IF c = 0 THEN
        carry_in <= '0';
      ELSE
        carry_in <= '1';
      END IF;
      FOR i IN -2 TO 2 LOOP
        in_1 <= conv_std_logic_vector(i, n);
        FOR j IN -2 TO 2 LOOP
          IF c = 0 THEN
            in_2 <= conv_std_logic_vector(j, n);
          ELSE
            in_2 <= NOT conv_std_logic_vector(j, n);
          END IF;
          WAIT FOR 100 PS;
        END LOOP;
      END LOOP;
    END LOOP;
    ASSERT FALSE REPORT "Testbench finished!" SEVERITY FAILURE;
  END PROCESS;

END ARCHITECTURE;

CONFIGURATION cfg_tb_p4_adder_structural OF tb_p4_adder IS
  FOR behavioral
    FOR dut : p4_adder USE CONFIGURATION work.cfg_p4_adder_structural;
    END FOR;
  END FOR;
END CONFIGURATION;



