LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder IS
  PORT (
    in_1      : IN  STD_LOGIC;
    in_2      : IN  STD_LOGIC;
    carry_in  : IN  STD_LOGIC;
    sum       : OUT STD_LOGIC;
    carry_out : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF full_adder IS
BEGIN
  sum       <= in_1 XOR in_2 XOR carry_in;
<<<<<<< HEAD
  carry_out <= (in_1 AND (in_2 XOR carry_in)) OR (in_2 AND carry_in);
=======
  carry_out <= in_1 AND (in_2 XOR carry_in) OR in_2 AND carry_in;
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF full_adder IS

  COMPONENT xor_gate IS
    PORT (
      in_1  : IN  STD_LOGIC;
      in_2  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT or_gate IS
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

<<<<<<< HEAD
  SIGNAL in_2_xor_carry_in, in_2_and_carry_in, in_1_and_in_2_xor_carry_in : STD_LOGIC := '0';

BEGIN
  in_2_xor_carry_in_gate : xor_gate PORT MAP (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => in_2_xor_carry_in
    );
  sum_xor_gate : xor_gate PORT MAP(
    in_1  => in_1,
    in_2  => in_2_xor_carry_in,
    out_s => sum
    );
  in_1_and_in_2_xor_carry_in_gate : and_gate PORT MAP (
    in_1  => in_1,
    in_2  => in_2_xor_carry_in,
    out_s => in_1_and_in_2_xor_carry_in
    );
  in_2_and_carry_in_gate : and_gate PORT MAP (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => in_2_and_carry_in
    );
  carry_out_or_gate : or_gate PORT MAP (
    in_1  => in_1_and_in_2_xor_carry_in,
    in_2  => in_2_and_carry_in,
=======
  SIGNAL i2_xor_carry_in, i2_and_carry_in, in1_and_i2_xor_carry_in : STD_LOGIC := '0';

BEGIN
  i2_xor_carry_in_gate : xor_gate PORT MAP (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => i2_xor_carry_in
    );
  sum_xor_gate : xor_gate PORT MAP(
    in_1  => in_1,
    in_2  => i2_xor_carry_in,
    out_s => sum
    );
  in1_and_i2_xor_carry_in_gate : and_gate PORT MAP (
    in_1  => in_1,
    in_2  => i2_xor_carry_in,
    out_s => in1_and_i2_xor_carry_in
    );
  i2_and_carry_in_gate : and_gate PORT MAP (
    in_1  => in_2,
    in_2  => carry_in,
    out_s => i2_and_carry_in
    );
  carry_out_or_gate : or_gate PORT MAP (
    in_1  => in1_and_i2_xor_carry_in,
    in_2  => i2_and_carry_in,
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    out_s => carry_out
    );
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_full_adder_behavioral OF full_adder IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_full_adder_structural OF full_adder IS
  FOR structural
<<<<<<< HEAD
    FOR in_2_xor_carry_in_gate         : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR sum_xor_gate                 : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR in_2_and_carry_in_gate         : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR in_1_and_in_2_xor_carry_in_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
=======
    FOR i2_xor_carry_in_gate         : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR sum_xor_gate                 : xor_gate USE CONFIGURATION work.cfg_xor_gate_behavioral;
    END FOR;
    FOR i2_and_carry_in_gate         : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
    END FOR;
    FOR in1_and_i2_xor_carry_in_gate : and_gate USE CONFIGURATION work.cfg_and_gate_behavioral;
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    END FOR;
    FOR carry_out_or_gate            : or_gate USE CONFIGURATION work.cfg_or_gate_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
