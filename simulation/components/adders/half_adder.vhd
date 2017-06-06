LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY half_adder IS
  PORT (
    in_1      : IN  STD_LOGIC;
    in_2      : IN  STD_LOGIC;
    sum       : OUT STD_LOGIC;
    carry_out : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF half_adder IS
BEGIN
  sum       <= in_1 XOR in_2;
  carry_out <= in_1 AND in_2;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF half_adder IS

  COMPONENT xor_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT and_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

BEGIN
  s_gate : xor_gate PORT MAP (
    in_1  => in_1,
    in_2  => in_2,
    out_s => sum
    );
  c_out_gate : and_gate PORT MAP (
    in_1  => in_1,
    in_2  => in_2,
    out_s => carry_out
    );
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_half_adder_behavioral OF half_adder IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_half_adder_structural OF half_adder IS
  FOR structural
    FOR s_gate         : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR carry_out_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
