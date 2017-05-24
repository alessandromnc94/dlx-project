LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE iee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

use work.mux_n_m_1_types.all;
USE work.alu_types.ALL;
use work.my_arith_functions.all;

ENTITY alu IS
  GENERIC (
    n : INTEGER := 8
    );
  PORT (
    i0     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    i1     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    op_sel : IN  alu_array;
    o      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
-- ARCHITECTURE behavioral OF alu IS
-- BEGIN
--   PROCESS (ALL)
--   BEGIN
--     CASE op_sel IS
--       WHEN alu_add => o <= i0 + i1;
--       WHEN alu_sub => o <= i0 - i1;
--       WHEN alu_and => o <= i0 AND i1;
--       WHEN alu_or  => o <= i0 OR i1;
--       WHEN alu_xor => o <= i0 XOR i1;
--       WHEN alu_sll => o <= conv_std_logic_vector(SLL(UNSIGNED(i0), UNSIGNED(i1)), n);
--       WHEN alu_srl => o <= conv_std_logic_vector(SRL(UNSIGNED(i0), UNSIGNED(i1)), n);
--       WHEN alu_sra => o <= conv_std_logic_vector(SRA(UNSIGNED(i0), UNSIGNED(i1)), n);
--       WHEN alu_rol => o <= conv_std_logic_vector(ROL(UNSIGNED(i0), UNSIGNED(i1)), n);
--       WHEN alu_ror => o <= conv_std_logic_vector(ROR(UNSIGNED(i0), UNSIGNED(i1)), n);
--       WHEN alu_comp_eq =>
--         o <= (OTHERS => '0')
--         IF i0 = i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN alu_comp_gr =>
--         o <= (OTHERS => '0')
--         IF i0 > i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN alu_comp_lr =>
--         o <= (OTHERS => '0')
--         IF i0 < i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN alu_comp_ge =>
--         o <= (OTHERS => '0')
--         IF i0 >= i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN alu_comp_le =>
--         o     <= (OTHERS => '0')
--         IF i0 <= i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN alu_comp_ne =>
--         o <= (OTHERS => '0')
--         IF i0 /= i1 THEN
--           o(0) <= '1';
--         END IF;
--       WHEN OTHERS => o <= (OTHERS => 'z');
--     END CASE;
--   END PROCESS;
-- END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural of alu is

  component mux_n_m_1 is
    generic (
      n : integer;
      m : integer
    );
    port (
      i : in mux_n_m_1_matrix(0 to m-1)(n-1 downto 0);
      s : in STD_LOGIC_VECTOR(log2int(m)-1 downto 0);
      o : out STD_LOGIC_VECTOR(n-1 downto 0)
    );
  end component;

  component alu_logical is 
  end component;

BEGIN


end architecture;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_alu_behavioral OF alu IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
