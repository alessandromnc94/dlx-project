LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

USE work.alu_logicals_types.ALL;

ENTITY alu_logicals IS
  PORT (
    i1    : IN  STD_LOGIC;
    i2    : IN  STD_LOGIC;
    logic : IN  alu_logicals_array;
    o     : OUT STD_LOGIC
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF alu_logicals IS
BEGIN

  PROCESS(ALL)
  BEGIN
    CASE logic IS
      WHEN alu_logicals_and  => o <= i1 AND i2;
      WHEN alu_logicals_nand => o <= i1 NAND i2;
      WHEN alu_logicals_or   => o <= i1 OR i2;
      WHEN alu_logicals_nor  => o <= i1 NOR i2;
      WHEN alu_logicals_xor  => o <= i1 XOR i2;
      WHEN alu_logicals_xnor => o <= i1 XNOR i2;
      WHEN OTHERS            => o <= (OTHERS => 'z');
    END CASE;
  END PROCESS;

END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF alu_logicals IS
  COMPONENT nand_gate_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      i : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      o : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT not_gate IS
    PORT (
      i : IN  STD_LOGIC;
      o : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL not_i1, not_i2 : STD_LOGIC                    := '0';
  SIGNAL nand_outputs   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
BEGIN

  not_i1_gate : NOT PORT MAP (
    i => i1,
    o => not_i1
    );

  not_i2_gate : NOT PORT MAP (
    i => i2,
    o => not_i2
    );

-- nand:   (s0)(not i1)(not i2)
  nand_gate_3_0 : nand_gate_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      i => logic(0) & not_i1 & not_i2,
      o => nand_outputs(0)
      );

-- nand:   (s1)(not i1)(i2)
  nand_gate_3_1 : nand_gate_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      i => logic(1) & not_i1 & i2,
      o => nand_outputs(1)
      );

-- nand:   (s2)(i1)(not i2)
  nand_gate_3_2 : nand_gate_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      i => logic(2) & i1 & not_i2,
      o => nand_outputs(2)
      );

-- nand:   (s3)(i1)(i2)
  nand_gate_3_3 : nand_gate_n GENERIC MAP (
    n => 3
    ) PORT MAP (
      i => logic(3) & i1 & i2,
      o => nand_outputs(3)
      );

-- last nand with 4 inputs from previous nands
  nand_gate_4_fin : nand_gate_n GENERIC MAP (
    n => 4
    ) PORT MAP (
      i => nand_outputs,
      o => o
      );

END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_alu_logical_n_behavioral OF alu_logical_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_alu_logical_n_structural OF alu_logical_n IS
  FOR structural
    FOR not_i1_gate     : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR not_i2_gate     : not_gate USE CONFIGURATION work.cfg_not_gate_behavioral;
    END FOR;
    FOR nand_gate_3_0   : nand_gate_n USE CONFIGURATION work.cfg_nand_gate_n_behavioral;
    END FOR;
    FOR nand_gate_3_1   : nand_gate_n USE CONFIGURATION work.cfg_nand_gate_n_behavioral;
    END FOR;
    FOR nand_gate_3_2   : nand_gate_n USE CONFIGURATION work.cfg_nand_gate_n_behavioral;
    END FOR;
    FOR nand_gate_3_3   : nand_gate_n USE CONFIGURATION work.cfg_nand_gate_n_behavioral;
    END FOR;
    FOR nand_gate_4_fin : nand_gate_n USE CONFIGURATION work.cfg_nand_gate_n_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
