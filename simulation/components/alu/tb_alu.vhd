LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_unsigned.ALL;
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
  SIGNAL in_1, in_2, out_s, theorical_out_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '1');
  SIGNAL op_sel                             : alu_array;
  SIGNAL operation                          : STRING(1 TO 5)                 := "    ";
BEGIN

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
    op_sel <= alu_add;
    WAIT FOR 1 NS;
    op_sel <= alu_sub;
    WAIT FOR 1 NS;

    op_sel <= alu_and;
    WAIT FOR 1 NS;
    op_sel <= alu_or;
    WAIT FOR 1 NS;
    op_sel <= alu_xor;
    WAIT FOR 1 NS;
    op_sel <= alu_nand;
    WAIT FOR 1 NS;
    op_sel <= alu_nor;
    WAIT FOR 1 NS;
    op_sel <= alu_xnor;
    WAIT FOR 1 NS;

    op_sel <= alu_sll;
    WAIT FOR 1 NS;
    op_sel <= alu_srl;
    WAIT FOR 1 NS;
    op_sel <= alu_sra;
    WAIT FOR 1 NS;

    op_sel <= alu_rol;
    WAIT FOR 1 NS;
    op_sel <= alu_ror;
    WAIT FOR 1 NS;

    op_sel <= alu_mul_signed;
    WAIT FOR 1 NS;
    op_sel <= alu_mul_unsigned;
    WAIT FOR 1 NS;

    op_sel <= alu_comp_eq;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_ne;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_gr;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_ge;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_lo;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_le;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_gr_signed;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_ge_signed;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_lo_signed;
    WAIT FOR 1 NS;
    op_sel <= alu_comp_le_signed;
    WAIT FOR 1 NS;

    ASSERT FALSE REPORT "testbench terminated!!!" SEVERITY FAILURE;
  END PROCESS;

  PROCESS(op_sel)
  BEGIN
    CASE op_sel IS
      WHEN alu_add            => operation <= "  add";
      WHEN alu_sub            => operation <= "  sub";
      WHEN alu_and            => operation <= "  and";
      WHEN alu_or             => operation <= "   or";
      WHEN alu_xor            => operation <= "  xor";
      WHEN alu_nand           => operation <= " nand";
      WHEN alu_nor            => operation <= "  nor";
      WHEN alu_xnor           => operation <= " xnor";
      WHEN alu_mul_unsigned   => operation <= "u mul";
      WHEN alu_mul_signed     => operation <= "s mul";
      WHEN alu_sll            => operation <= "  sll";
      WHEN alu_srl            => operation <= "  srl";
      WHEN alu_sra            => operation <= "  sra";
      WHEN alu_rol            => operation <= "  rol";
      WHEN alu_ror            => operation <= "  ror";
      WHEN alu_comp_eq        => operation <= "   eq";
      WHEN alu_comp_ne        => operation <= "   ne";
      WHEN alu_comp_gr        => operation <= "   gr";
      WHEN alu_comp_ge        => operation <= "   ge";
      WHEN alu_comp_lo        => operation <= "   lo";
      WHEN alu_comp_le        => operation <= "   le";
      WHEN alu_comp_gr_signed => operation <= "s  gr";
      WHEN alu_comp_ge_signed => operation <= "s  ge";
      WHEN alu_comp_lo_signed => operation <= "s  lo";
      WHEN alu_comp_le_signed => operation <= "s  le";
    END CASE;
  END PROCESS;
END ARCHITECTURE;

CONFIGURATION cfg_tb_alu_behavioral OF tb_alu IS
  FOR behavioral
    FOR dut : alu USE CONFIGURATION work.cfg_alu_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
