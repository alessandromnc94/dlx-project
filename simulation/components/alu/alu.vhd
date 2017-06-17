LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

<<<<<<< HEAD
USE work.logicals_types.ALL;
=======
USE work.mux_n_m_1_types.ALL;
USE work.logicals_types.ALL;
USE work.comparator_types.ALL;
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
USE work.alu_types.ALL;
USE work.my_arith_functions.ALL;

ENTITY alu IS
  GENERIC (
    n : INTEGER := 32
    );
  PORT (
    in_1   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    in_2   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    op_sel : IN  alu_array;
    -- outputs
    out_s  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- structural architecture
<<<<<<< HEAD
ARCHITECTURE behavioral OF alu IS
  COMPONENT mux_n_2_1 IS
=======
ARCHITECTURE structural OF alu IS
  COMPONENT mux_2_1_n IS
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
<<<<<<< HEAD
  SIGNAL mux_in_2_select : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

-- mux_n_6_1 for: output mux and comparator mux
  COMPONENT mux_n_6_1 IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_3  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_4  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_5  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
=======
  SIGNAL mux_in_2_select : STD_LOGIC_VECTOR(n-1 downt0 0);

  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  SIGNAL not_in_2 : STD_LOGIC_VECTOR(m-1 DOWNTO 0);

  COMPONENT

    COMPONENT logicals IS
      GENERIC (
        n : INTEGER
        );
      PORT (
        in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        logic : IN  logicals_array;
        out_s : OUT STD_LOGIC(n-1 DOWNTO 0)
        );
    END COMPONENT;

  SIGNAL logicals_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

  COMPONENT p4_adder IS
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      );
  END COMPONENT;
  SIGNAL out_mux_sel  : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
  SIGNAL comp_mux_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

<<<<<<< HEAD
  COMPONENT not_gate_n IS
  generic (
    n : integer
  );
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
=======
  SIGNAL addsub_out       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL addsub_carry_out : STD_LOGIC;
  SIGNAL addsub_sel_in    : STD_LOGIC;

  COMPONENT zero_comparator IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  SIGNAL zero_comparator_out : STD_LOGIC;

  COMPONENT comparator IS
    PORT (
      zero_out  : IN  STD_LOGIC;
      carry_out : IN  STD_LOGIC;
      eq_out    : OUT STD_LOGIC;
      gr_out    : OUT STD_LOGIC;
      lo_out    : OUT STD_LOGIC;
      ge_out    : OUT STD_LOGIC;
      le_out    : OUT STD_LOGIC;
      ne_out    : OUT STD_LOGIC
      );
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
  END COMPONENT;
  SIGNAL not_in_2 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

  COMPONENT logicals_n IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      logic : IN  logicals_array;
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  SIGNAL logicals_mode : logicals_array := (OTHERS => '0');
  SIGNAL logicals_out  : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

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
  SIGNAL mul_out    : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL signed_mul : STD_LOGIC := '0';

  COMPONENT p4_adder IS
    GENERIC (
      n          : INTEGER;
      carry_step : INTEGER
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
      );
  END COMPONENT;
  SIGNAL addsub_out       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL addsub_carry_out : STD_LOGIC;
  SIGNAL addsub_sel_in    : STD_LOGIC := '0';

  COMPONENT zero_comparator IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  SIGNAL zero_comp_out : STD_LOGIC;

  COMPONENT comparator IS
    PORT (
      zero_out          : IN  STD_LOGIC;
      carry_out         : IN  STD_LOGIC;
      signed_comparison : IN  STD_LOGIC;
      eq_out            : OUT STD_LOGIC;
      gr_out            : OUT STD_LOGIC;
      lo_out            : OUT STD_LOGIC;
      ge_out            : OUT STD_LOGIC;
      le_out            : OUT STD_LOGIC;
      ne_out            : OUT STD_LOGIC
      );
  END COMPONENT;

  -- insert shifter/rotator component declaration
  COMPONENT shifter IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      base_vector    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      shift_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      left_shift     : IN  STD_LOGIC;
      arith_shift    : IN  STD_LOGIC;
      out_s          : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  SIGNAL shift_out   : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  SIGNAL left_shift  : STD_LOGIC := '0';
  SIGNAL arith_shift : STD_LOGIC := '0';
-- insert rotator component declaration (re-used left_shift to reduce signals)
  COMPONENT rotator IS
    GENERIC (
      n : INTEGER
      );
    PORT (
      base_vector     : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      rotate_by_value : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      left_rotation   : IN  STD_LOGIC;
      out_s           : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  SIGNAL rotate_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

  SIGNAL zero_out           : STD_LOGIC;
  SIGNAL comp_mode          : STD_LOGIC_VECTOR(2 DOWNTO 0)   := (OTHERS => '0');
  SIGNAL signed_comparison  : STD_LOGIC                      := '0';
  SIGNAL comp_eq_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_gr_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_lo_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_ge_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_le_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_ne_out  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL comp_mux_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT comp_eq_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  CONSTANT comp_ne_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  CONSTANT comp_gr_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  CONSTANT comp_ge_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT comp_lo_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
  CONSTANT comp_le_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

  CONSTANT out_adder_value_sel      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  CONSTANT out_logicals_value_sel   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  CONSTANT out_comp_value_sel : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  CONSTANT out_mul_value_sel        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT out_shift_value_sel      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
  CONSTANT out_rotate_value_sel     : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

  SIGNAL zero_out           : STD_LOGIC;
  SIGNAL comp_mode          : comparator_array;
  SIGNAL signed_comparison  : STD_LOGIC;
  SIGNAL comparator_eq_out  : STD_LOGIC;
  SIGNAL comparator_gr_out  : STD_LOGIC;
  SIGNAL comparator_lo_out  : STD_LOGIC;
  SIGNAL comparator_ge_out  : STD_LOGIC;
  SIGNAL comparator_le_out  : STD_LOGIC;
  SIGNAL comparator_ne_out  : STD_LOGIC;
  SIGNAL comparator_mux_out : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

<<<<<<< HEAD
-- negated version od in_2 is used for sub operation
not_in_2_gate : not_gate_n generic map (
  n => n
) port map (
  in_s => in_2,
  out_s => not_in_2
);

-- this mux select the input for p4_adder: s = 0 means in_2 (adding) else not in_2 (subtracting)
  mux_in_2_select_comp : mux_n_2_1 GENERIC MAP (
=======
  not_in_2_gen : FOR i IN 0 TO n-1 GENERATE
    not_in_2_x : not_gate PORT MAP (
      in_s  => in_2(i),
      out_s => not_in_2(i)
      );
  END GENERATE;

-- this mux select the input for p4_adder: s = 0 means in_2 (adding) else not in_2 (subtracting)
  mux_in_2_select_comp : mux_2_1_n GENERIC MAP (
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    n => n
    ) PORT MAP (
      in_0  => in_2,
      in_1  => not_in_2,
      s     => addsub_sel_in,
      out_s => mux_in_2_select
      );

<<<<<<< HEAD
-- booth multiplier
  booth_multiplier_comp : booth_multiplier GENERIC MAP (
    n => n/2
    ) PORT MAP (
      in_1       => in_1(n/2-1 DOWNTO 0),
      in_2       => in_2(n/2-1 DOWNTO 0),
      signed_mul => signed_mul,
      out_s      => mul_out
      );

-- this adder is used for adding or subtracting two values (addsub_sel_in select the operation)
  p4_adder_comp : p4_adder GENERIC MAP (
    n          => n,
    carry_step => 4
=======
-- this adder is used for adding or subtracting two values (addsub_sel_in select the operation)
  p4_adder_comp : p4_adder GENERIC MAP (
    n => n,
    m => 4
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    ) PORT MAP (
      in_1      => in_1,
      in_2      => mux_in_2_select,
      carry_in  => addsub_sel_in,
      sum       => addsub_out,
      carry_out => addsub_carry_out
      );
<<<<<<< HEAD

-- this component does the logic operation between inputs
  logicals_comp : logicals_n GENERIC MAP (
=======
-- this component does the logic operation between inputs
  logicals_comp : logicals GENERIC MAP (
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    n => n
    ) PORT MAP (
      in_1  => in_1,
      in_2  => in_2,
<<<<<<< HEAD
      logic => logicals_mode,
=======
      logic => (OTHERS => '0'),
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      out_s => logicals_out
      );

  -- this zero_comparator is used for the comparator
  adder_out_zero_comp : zero_comparator GENERIC MAP (
    n => n
    ) PORT MAP (
      in_s  => addsub_out,
<<<<<<< HEAD
      out_s => zero_comp_out
=======
      out_s => zero_comparator_out
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      );

  -- this comparator compares the carry out from adder and the zero_out from zero_comparator
  -- which kind comparison is choosen externally
<<<<<<< HEAD
  comparator_comp : comparator PORT MAP (
    zero_out          => zero_comp_out,
    carry_out         => addsub_carry_out,
    signed_comparison => signed_comparison,
    eq_out            => comp_eq_out(0),
    gr_out            => comp_gr_out(0),
    lo_out            => comp_lo_out(0),
    ge_out            => comp_ge_out(0),
    le_out            => comp_le_out(0),
    ne_out            => comp_ne_out(0)
    );

-- shifter
  shifter_comp : shifter GENERIC MAP (
    n => n
    ) PORT MAP (
      base_vector    => in_1,
      shift_by_value => in_2,
      left_shift     => left_shift,
      arith_shift    => arith_shift,
      out_s          => shift_out
      );
-- rotator
  rotator_comp : rotator GENERIC MAP (
    n => n
    ) PORT MAP (
      base_vector     => in_1,
      rotate_by_value => in_2,
      left_rotation   => left_shift,
      out_s           => rotate_out
      );
-- insert: comparator_mux (6 inputs -> 1 outputs (1 bit))
  comp_mux : mux_n_6_1 GENERIC MAP (
    n => 1
    ) PORT MAP (
      in_0  => comp_eq_out,
      in_1  => comp_ne_out,
      in_2  => comp_gr_out,
      in_3  => comp_ge_out,
      in_4  => comp_lo_out,
      in_5  => comp_le_out,
      s     => comp_mux_sel,
      out_s => comp_mux_out(0 DOWNTO 0)
      );
-- output_mux
  out_mux : mux_n_6_1 GENERIC MAP (
    n => n
    ) PORT MAP (
      in_0  => addsub_out,
      in_1  => logicals_out,
      in_2  => comp_mux_out,
      in_3  => mul_out,
      in_4  => shift_out,
      in_5  => rotate_out,
      s     => out_mux_sel,
      out_s => out_s
      );
--

  PROCESS(op_sel)
  BEGIN
    CASE op_sel IS
      WHEN alu_add =>
        addsub_sel_in <= '0';
        out_mux_sel   <= out_adder_value_sel;
      WHEN alu_sub =>
        addsub_sel_in <= '1';
        out_mux_sel   <= out_adder_value_sel;

      WHEN alu_and =>
        logicals_mode <= logicals_and;
        out_mux_sel   <= out_logicals_value_sel;
      WHEN alu_or =>
        logicals_mode <= logicals_or;
        out_mux_sel   <= out_logicals_value_sel;
      WHEN alu_xor =>
        logicals_mode <= logicals_xor;
        out_mux_sel   <= out_logicals_value_sel;
      WHEN alu_nand =>
        logicals_mode <= logicals_nand;
        out_mux_sel   <= out_logicals_value_sel;
      WHEN alu_nor =>
        logicals_mode <= logicals_nor;
        out_mux_sel   <= out_logicals_value_sel;
      WHEN alu_xnor =>
        logicals_mode <= logicals_xnor;
        out_mux_sel   <= out_logicals_value_sel;

      WHEN alu_mul_signed =>
        out_mux_sel <= out_mul_value_sel;
        signed_mul  <= '1';
      WHEN alu_mul_unsigned =>
        out_mux_sel <= out_mul_value_sel;
        signed_mul  <= '0';

      WHEN alu_sll =>
        left_shift  <= '1';
        arith_shift <= '0';
        out_mux_sel <= out_shift_value_sel;
      WHEN alu_srl =>
        left_shift  <= '0';
        arith_shift <= '0';
        out_mux_sel <= out_shift_value_sel;
      WHEN alu_sra =>
        left_shift  <= '0';
        arith_shift <= '1';
        out_mux_sel <= out_shift_value_sel;

      WHEN alu_rol =>
        left_shift  <= '1';
        out_mux_sel <= out_rotate_value_sel;
      WHEN alu_ror =>
        left_shift  <= '0';
        out_mux_sel <= out_rotate_value_sel;

      WHEN alu_comp_eq =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_eq_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_ne =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_ne_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_gr =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_gr_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_ge =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_ge_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_lo =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_lo_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_le =>
        addsub_sel_in     <= '1';
        signed_comparison <= '0';
        comp_mux_sel      <= comp_le_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_gr_signed =>
        addsub_sel_in     <= '1';
        signed_comparison <= '1';
        comp_mux_sel      <= comp_gr_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_ge_signed =>
        addsub_sel_in     <= '1';
        signed_comparison <= '1';
        comp_mux_sel      <= comp_ge_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_lo_signed =>
        addsub_sel_in     <= '1';
        signed_comparison <= '1';
        comp_mux_sel      <= comp_lo_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN alu_comp_le_signed =>
        addsub_sel_in     <= '1';
        signed_comparison <= '1';
        comp_mux_sel      <= comp_le_sel;
        out_mux_sel       <= out_comp_value_sel;
      WHEN OTHERS => NULL;
    END CASE;
  END PROCESS;
=======
  adder_comparator_comp : comparator PORT MAP (
    zero_out          => zero_comparator_out,
    carry_out         => addsub_carry_out,
    signed_comparison => signed_comparison,
    eq_out            => comparator_eq_out,
    gr_out            => comparator_gr_out,
    lo_out            => comparator_lo_out,
    ge_out            => comparator_ge_out,
    le_out            => comparator_le_out,
    ne_out            => comparator_ne_out
    );
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f

--
-- insert: shifter/rotator
-- insert: multiplier
-- insert: divider
--
END ARCHITECTURE;

-- configurations

-- structural configuration with behavioral components
<<<<<<< HEAD
CONFIGURATION cfg_alu_behavioral OF alu IS
  FOR behavioral
    FOR not_in_2_gate : not_gate_n USE CONFIGURATION work.cfg_not_gate_n_behavioral;
    END FOR;
    FOR mux_in_2_select_comp  : mux_n_2_1 USE CONFIGURATION work.cfg_mux_n_2_1_structural;
    END FOR;
    FOR booth_multiplier_comp : booth_multiplier USE CONFIGURATION work.cfg_booth_multiplier_structural;
    END FOR;
    FOR p4_adder_comp         : p4_adder USE CONFIGURATION work.cfg_p4_adder_structural;
    END FOR;
    FOR logicals_comp         : logicals_n USE CONFIGURATION work.cfg_logicals_n_structural_2;
    END FOR;
    FOR adder_out_zero_comp   : zero_comparator USE CONFIGURATION work.cfg_zero_comp_behavioral;
    END FOR;
    FOR comparator_comp : comparator USE CONFIGURATION work.cfg_comp_behavioral;
    END FOR;
    FOR comp_mux              : mux_n_6_1 USE CONFIGURATION work.cfg_mux_n_6_1_behavioral;
    END FOR;
    FOR out_mux               : mux_n_6_1 USE CONFIGURATION work.cfg_mux_n_6_1_behavioral;
    END FOR;

=======
CONFIGURATION cfg_alu_structural_1 OF alu IS
  FOR structural
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
  END FOR;
END CONFIGURATION;
