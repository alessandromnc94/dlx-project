LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE iee.std_logic_signed.ALL;
USE ieee.std_logic_arith.ALL;

USE work.mux_n_m_1_types.ALL;
USE work.logicals_types.ALL;
USE work.comparator_types.ALL;
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
ARCHITECTURE structural OF alu IS
  COMPONENT mux_2_1_n IS
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
      );
  END COMPONENT;

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
  END COMPONENT;

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

  not_in_2_gen : FOR i IN 0 TO n-1 GENERATE
    not_in_2_x : not_gate PORT MAP (
      in_s  => in_2(i),
      out_s => not_in_2(i)
      );
  END GENERATE;

-- this mux select the input for p4_adder: s = 0 means in_2 (adding) else not in_2 (subtracting)
  mux_in_2_select_comp : mux_2_1_n GENERIC MAP (
    n => n
    ) PORT MAP (
      in_0  => in_2,
      in_1  => not_in_2,
      s     => addsub_sel_in,
      out_s => mux_in_2_select
      );

-- this adder is used for adding or subtracting two values (addsub_sel_in select the operation)
  p4_adder_comp : p4_adder GENERIC MAP (
    n => n,
    m => 4
    ) PORT MAP (
      in_1      => in_1,
      in_2      => mux_in_2_select,
      carry_in  => addsub_sel_in,
      sum       => addsub_out,
      carry_out => addsub_carry_out
      );
-- this component does the logic operation between inputs
  logicals_comp : logicals GENERIC MAP (
    n => n
    ) PORT MAP (
      in_1  => in_1,
      in_2  => in_2,
      logic => (OTHERS => '0'),
      out_s => logicals_out
      );

  -- this zero_comparator is used for the comparator
  adder_out_zero_comp : zero_comparator GENERIC MAP (
    n => n
    ) PORT MAP (
      in_s  => addsub_out,
      out_s => zero_comparator_out
      );

  -- this comparator compares the carry out from adder and the zero_out from zero_comparator
  -- which kind comparison is choosen externally
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

--
-- insert: shifter/rotator
-- insert: multiplier
-- insert: divider
--
END ARCHITECTURE;

-- configurations

-- structural configuration with behavioral components
CONFIGURATION cfg_alu_structural_1 OF alu IS
  FOR structural
  END FOR;
END CONFIGURATION;
