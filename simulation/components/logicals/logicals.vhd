LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.logicals_types.ALL;

ENTITY logicals IS
  PORT (
    in_1  : IN  STD_LOGIC;
    in_2  : IN  STD_LOGIC;
    logic : IN  logicals_array;
    out_s : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF logicals IS
  SIGNAL nand_0 : STD_LOGIC;
  SIGNAL nand_1 : STD_LOGIC;
  SIGNAL nand_2 : STD_LOGIC;
  SIGNAL nand_3 : STD_LOGIC;
BEGIN

  nand_0 <= NOT (logic(0) AND (NOT in_1) AND (NOT in_2));
  nand_1 <= NOT (logic(1) AND (NOT in_1) AND (in_2));
  nand_2 <= NOT (logic(2) AND (in_1) AND (NOT in_2));
  nand_3 <= NOT (logic(3) AND (in_1) AND (in_2));

  out_s <= NOT (nand_0 AND nand_1 AND nand_2 AND nand_3);

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF logicals IS
  COMPONENT nand_gate_single_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;


  SIGNAL nand_0, nand_1, nand_2, nand_3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

  SIGNAL not_in_1, not_in_2 : STD_LOGIC                    := '0';
  SIGNAL nand_outputs       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
BEGIN

  not_in_1_gate : not_gate PORT MAP (
    in_s  => in_1,
    out_s => not_in_1
    );

  not_in_2_gate : not_gate PORT MAP (
    in_s  => in_2,
    out_s => not_in_2
    );

-- nand:   (s0)(not in_1)(not in_2)
  nand_0 <= logic(0)&not_in_1&not_in_2;
  nand_gate_3_0 : nand_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => nand_0,
      out_s => nand_outputs(0)
      );

-- nand:   (s1)(not in_1)(in_2)
  nand_1 <= logic(1)&not_in_1&in_2;
  nand_gate_3_1 : nand_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => nand_1,
      out_s => nand_outputs(1)
      );

-- nand:   (s2)(in_1)(not in_2)
  nand_2 <= logic(2)&in_1&not_in_2;
  nand_gate_3_2 : nand_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => nand_2,
      out_s => nand_outputs(2)
      );

-- nand:   (s3)(in_1)(in_2)
  nand_3 <= logic(3)&in_1&in_2;
  nand_gate_3_3 : nand_gate_single_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      in_s  => nand_3,
      out_s => nand_outputs(3)
      );

-- last nand with 4 inputs from previous nands
  nand_gate_4_fin : nand_gate_single_n GENERIC MAP (
    n => 4
    ) PORT MAP (
      in_s  => nand_outputs,
      out_s => out_s
      );

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_logicals_behavioral OF logicals IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_logicals_structural OF logicals IS
  FOR structural
    FOR not_in_1_gate   : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR not_in_2_gate   : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR nand_gate_3_0   : nand_gate_single_n USE CONFIGURATION work.cfg_nand_gate_single_n_behavioral;
    END FOR;
    FOR nand_gate_3_1   : nand_gate_single_n USE CONFIGURATION work.cfg_nand_gate_single_n_behavioral;
    END FOR;
    FOR nand_gate_3_2   : nand_gate_single_n USE CONFIGURATION work.cfg_nand_gate_single_n_behavioral;
    END FOR;
    FOR nand_gate_3_3   : nand_gate_single_n USE CONFIGURATION work.cfg_nand_gate_single_n_behavioral;
    END FOR;
    FOR nand_gate_4_fin : nand_gate_single_n USE CONFIGURATION work.cfg_nand_gate_single_n_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
