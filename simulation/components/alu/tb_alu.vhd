LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE std.textio.ALL;

USE work.alu_types.ALL;

ENTITY tb_alu IS
END ENTITY;

ARCHITECTURE behavioral OF tb_alu IS

  CONSTANT n : INTEGER := 8;

  COMPONENT alu IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      op_sel : IN  alu_array;
      -- outputs
      out_s  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  SIGNAL in_1, in_2, out_s, expected_out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '1');
  SIGNAL op_sel                            : alu_array;
  SIGNAL operation                         : STRING(1 TO 5)                 := "     ";
  SIGNAL correct                           : BOOLEAN;
BEGIN

  correct <= expected_out_s = out_s;

  dut : alu GENERIC MAP (
    n => n
    ) PORT MAP (
      in_1   => in_1,
      in_2   => in_2,
      op_sel => op_sel,
      out_s  => out_s
      );


  PROCESS
  BEGIN

    FOR i IN -2 TO 2 LOOP
      in_1 <= conv_std_logic_vector(i, n);
      FOR j IN -2 TO 2 LOOP
        in_2   <= conv_std_logic_vector(j, n);
        op_sel <= alu_add;
        WAIT FOR 100 PS;
        op_sel <= alu_sub;
        WAIT FOR 100 PS;

        op_sel <= alu_and;
        WAIT FOR 100 PS;
        op_sel <= alu_or;
        WAIT FOR 100 PS;
        op_sel <= alu_xor;
        WAIT FOR 100 PS;
        op_sel <= alu_nand;
        WAIT FOR 100 PS;
        op_sel <= alu_nor;
        WAIT FOR 100 PS;
        op_sel <= alu_xnor;
        WAIT FOR 100 PS;

        op_sel <= alu_sll;
        WAIT FOR 100 PS;
        op_sel <= alu_srl;
        WAIT FOR 100 PS;
        op_sel <= alu_sra;
        WAIT FOR 100 PS;

        op_sel <= alu_rol;
        WAIT FOR 100 PS;
        op_sel <= alu_ror;
        WAIT FOR 100 PS;

        op_sel <= alu_mul_signed;
        WAIT FOR 100 PS;
        op_sel <= alu_mul;
        WAIT FOR 100 PS;

        op_sel <= alu_comp_eq;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_ne;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_gr;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_ge;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_lo;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_le;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_gr_signed;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_ge_signed;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_lo_signed;
        WAIT FOR 100 PS;
        op_sel <= alu_comp_le_signed;
        WAIT FOR 100 PS;


      END LOOP;
    END LOOP;
    ASSERT FALSE REPORT "testbench terminated!!!" SEVERITY FAILURE;

  END PROCESS;

  PROCESS(op_sel, in_1, in_2)
  BEGIN
    CASE op_sel IS
      WHEN alu_add =>
        operation      <= "  add";
        expected_out_s <= UNSIGNED(in_1) + UNSIGNED(in_2);
      WHEN alu_sub =>
        operation      <= "  sub";
        expected_out_s <= UNSIGNED(in_1) - UNSIGNED(in_2);
      WHEN alu_and =>
        operation      <= "  and";
        expected_out_s <= in_1 AND in_2;
      WHEN alu_or =>
        operation      <= "   or";
        expected_out_s <= in_1 OR in_2;
      WHEN alu_xor =>
        operation      <= "  xor";
        expected_out_s <= in_1 XOR in_2;
      WHEN alu_nand =>
        operation      <= " nand";
        expected_out_s <= in_1 NAND in_2;
      WHEN alu_nor =>
        operation      <= "  nor";
        expected_out_s <= in_1 NOR in_2;
      WHEN alu_xnor =>
        operation      <= " xnor";
        expected_out_s <= in_1 XNOR in_2;
      WHEN alu_mul =>
        operation      <= "u mul";
        expected_out_s <= UNSIGNED(in_1(n/2-1 DOWNTO 0)) * UNSIGNED(in_2(n/2-1 DOWNTO 0));
      WHEN alu_mul_signed =>
        operation      <= "s mul";
        expected_out_s <= SIGNED(in_1(n/2-1 DOWNTO 0)) * SIGNED(in_2(n/2-1 DOWNTO 0));
      WHEN alu_sll =>
        operation      <= "  sll";
        expected_out_s <= to_stdlogicvector(to_bitvector(in_1) SLL conv_integer(UNSIGNED(in_2)));
      WHEN alu_srl =>
        operation      <= "  srl";
        expected_out_s <= to_stdlogicvector(to_bitvector(in_1) SRL conv_integer(UNSIGNED(in_2)));
      WHEN alu_sra =>
        operation      <= "  sra";
        expected_out_s <= to_stdlogicvector(to_bitvector(in_1) SRA conv_integer(UNSIGNED(in_2)));
      WHEN alu_rol =>
        operation      <= "  rol";
        expected_out_s <= to_stdlogicvector(to_bitvector(in_1) ROL conv_integer(UNSIGNED(in_2)));
      WHEN alu_ror =>
        operation      <= "  ror";
        expected_out_s <= to_stdlogicvector(to_bitvector(in_1) ROR conv_integer(UNSIGNED(in_2)));
      WHEN alu_comp_eq =>
        operation                             <= "   eq";
        expected_out_s(n-1 DOWNTO 1)          <= (OTHERS => '0');
        IF in_1 = in_2 THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                <= '0';
        END IF;
      WHEN alu_comp_ne =>
        operation                              <= "   ne";
        expected_out_s(n-1 DOWNTO 1)           <= (OTHERS => '0');
        IF in_1 /= in_2 THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                 <= '0';
        END IF;
      WHEN alu_comp_gr =>
        operation                                                 <= "   gr";
        expected_out_s(n-1 DOWNTO 1)                              <= (OTHERS => '0');
        IF UNSIGNED(in_1) > UNSIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                    <= '0';
        END IF;
      WHEN alu_comp_ge =>
        operation                                                  <= "    ge";
        expected_out_s(n-1 DOWNTO 1)                               <= (OTHERS => '0');
        IF UNSIGNED(in_1) >= UNSIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                     <= '0';
        END IF;
      WHEN alu_comp_lo =>
        operation                                                 <= "   lo";
        expected_out_s(n-1 DOWNTO 1)                              <= (OTHERS => '0');
        IF UNSIGNED(in_1) < UNSIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                    <= '0';
        END IF;
      WHEN alu_comp_le =>
        operation                    <= "   le";
        expected_out_s(n-1 DOWNTO 1) <= (OTHERS => '0');
        IF UNSIGNED(in_1)            <= UNSIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)       <= '0';
        END IF;
      WHEN alu_comp_gr_signed =>
        operation                                             <= "s  gr";
        expected_out_s(n-1 DOWNTO 1)                          <= (OTHERS => '0');
        IF SIGNED(in_1) > SIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                <= '0';
        END IF;
      WHEN alu_comp_ge_signed =>
        operation                                              <= "s  ge";
        expected_out_s(n-1 DOWNTO 1)                           <= (OTHERS => '0');
        IF SIGNED(in_1) >= SIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                 <= '0';
        END IF;
      WHEN alu_comp_lo_signed =>
        operation                                             <= "s  lo";
        expected_out_s(n-1 DOWNTO 1)                          <= (OTHERS => '0');
        IF SIGNED(in_1) < SIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)                                <= '0';
        END IF;
      WHEN alu_comp_le_signed =>
        operation                    <= "s  le";
        expected_out_s(n-1 DOWNTO 1) <= (OTHERS => '0');
        IF SIGNED(in_1)              <= SIGNED(in_2) THEN expected_out_s(0) <= '1';
        ELSE expected_out_s(0)       <= '0';
        END IF;
      WHEN OTHERS =>
        operation <= " null";
    END CASE;
  END PROCESS;
END ARCHITECTURE;

CONFIGURATION cfg_tb_alu_behavioral OF tb_alu IS
  FOR behavioral
    FOR dut : alu USE CONFIGURATION work.cfg_alu_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
