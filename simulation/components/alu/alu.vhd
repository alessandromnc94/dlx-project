LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE iee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

USE work.mux_n_m_1_types.ALL;
USE work.alu_types.ALL;
USE work.my_arith_functions.ALL;

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
-- architecture behavioral of alu is
-- begin
--   process (all)
--   begin
--     case op_sel is
--       when alu_add => o <= i0 + i1;
--       when alu_sub => o <= i0 - i1;
--       when alu_and => o <= i0 and i1;
--       when alu_or  => o <= i0 or i1;
--       when alu_xor => o <= i0 xor i1;
--       when alu_sll => o <= conv_std_logic_vector(sll(unsigned(i0), unsigned(i1)), n);
--       when alu_srl => o <= conv_std_logic_vector(srl(unsigned(i0), unsigned(i1)), n);
--       when alu_sra => o <= conv_std_logic_vector(sra(unsigned(i0), unsigned(i1)), n);
--       when alu_rol => o <= conv_std_logic_vector(rol(unsigned(i0), unsigned(i1)), n);
--       when alu_ror => o <= conv_std_logic_vector(ror(unsigned(i0), unsigned(i1)), n);
--       when alu_comp_eq =>
--         o <= (others => '0')
--         if i0 = i1 then
--           o(0) <= '1';
--         end if;
--       when alu_comp_gr =>
--         o <= (others => '0')
--         if i0 > i1 then
--           o(0) <= '1';
--         end if;
--       when alu_comp_lr =>
--         o <= (others => '0')
--         if i0 < i1 then
--           o(0) <= '1';
--         end if;
--       when alu_comp_ge =>
--         o <= (others => '0')
--         if i0 >= i1 then
--           o(0) <= '1';
--         end if;
--       when alu_comp_le =>
--         o     <= (others => '0')
--         if i0 <= i1 then
--           o(0) <= '1';
--         end if;
--       when alu_comp_ne =>
--         o <= (others => '0')
--         if i0 /= i1 then
--           o(0) <= '1';
--         end if;
--       when others => o <= (others => 'z');
--     end case;
--   end process;
-- end architecture;

-- structural architecture
ARCHITECTURE structural OF alu IS

  COMPONENT mux_n_m_1 IS
    GENERIC (
      n : INTEGER;
      m : INTEGER
      );
    PORT (
      i : IN  mux_n_m_1_matrix(0 TO m-1)(n-1 DOWNTO 0);
      s : IN  STD_LOGIC_VECTOR(log2int(m)-1 DOWNTO 0);
      o : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT alu_logical IS
  END COMPONENT;

BEGIN


END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_alu_behavioral OF alu IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
