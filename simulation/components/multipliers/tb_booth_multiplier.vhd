LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY tb_booth_multiplier IS
END ENTITY;

ARCHITECTURE behavioral OF tb_booth_multiplier IS
  CONSTANT n : INTEGER := 4;
  COMPONENT booth_multiplier IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      signed_mul : IN  STD_LOGIC;
      out_s      : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)
      );
  END COMPONENT;

  SIGNAL in_1, in_2 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL signed_mul : STD_LOGIC;
  SIGNAL out_s      : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
BEGIN


  dut : booth_multiplier GENERIC MAP (
    n => n
    ) PORT MAP (
      in_1       => in_1,
      in_2       => in_2,
      signed_mul => signed_mul,
      out_s      => out_s
      );

  PROCESS
  BEGIN
    FOR k IN 0 TO 1 LOOP
      IF k = 0 THEN
        signed_mul <= '0';
      ELSE
        signed_mul <= '1';
      END IF;
      FOR i IN -1 TO 1 LOOP
        in_1 <= conv_std_logic_vector(i, n);
        FOR j IN -1 TO 1 LOOP
          in_2 <= conv_std_logic_vector(j, n);
          WAIT FOR 100 PS;
        END LOOP;
      END LOOP;
    END LOOP;
    ASSERT FALSE REPORT "testbench finished" SEVERITY FAILURE;
  END PROCESS;

END ARCHITECTURE;

CONFIGURATION cfg_tb_booth_multiplier_behavioral OF tb_booth_multiplier IS
  FOR behavioral
    FOR dut : booth_multiplier USE CONFIGURATION work.cfg_booth_multiplier_structural;
    END FOR;
  END FOR;
END CONFIGURATION;
