LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_comparator IS
END ENTITY;

ARCHITECTURE behavioral OF tb_comparator IS
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

  SIGNAL zero_out          : STD_LOGIC;
  SIGNAL carry_out         : STD_LOGIC;
  SIGNAL signed_comparison : STD_LOGIC;
  SIGNAL eq_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL gr_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL lo_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL ge_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL le_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL ne_out            : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN


  dut : comparator PORT MAP (
    zero_out          => zero_out,
    carry_out         => carry_out,
    signed_comparison => signed_comparison,
    eq_out            => eq_out (0),
    gr_out            => gr_out (0),
    lo_out            => lo_out (0),
    ge_out            => ge_out (0),
    le_out            => le_out (0),
    ne_out            => ne_out (0)
    );

  PROCESS
  BEGIN
    zero_out          <= '0';
    carry_out         <= '0';
    signed_comparison <= '0';
    WAIT FOR 1 NS;
    zero_out          <= '1';
    carry_out         <= '0';
    signed_comparison <= '0';
    WAIT FOR 1 NS;
    zero_out          <= '0';
    carry_out         <= '1';
    signed_comparison <= '0';
    WAIT FOR 1 NS;
    zero_out          <= '1';
    carry_out         <= '1';
    signed_comparison <= '0';
    WAIT FOR 1 NS;
    zero_out          <= '0';
    carry_out         <= '0';
    signed_comparison <= '1';
    WAIT FOR 1 NS;
    zero_out          <= '1';
    carry_out         <= '0';
    signed_comparison <= '1';
    WAIT FOR 1 NS;
    zero_out          <= '0';
    carry_out         <= '1';
    signed_comparison <= '1';
    WAIT FOR 1 NS;
    zero_out          <= '1';
    carry_out         <= '1';
    signed_comparison <= '1';
    WAIT FOR 1 NS;
    ASSERT FALSE REPORT "testbench finished!" SEVERITY FAILURE;
  END PROCESS;
END ARCHITECTURE;

CONFIGURATION cfg_tb_comparator_behavioral OF tb_comparator IS
  FOR behavioral
    FOR dut : comparator USE CONFIGURATION work.cfg_comparator_behavioral;
    END FOR;
  END FOR;
END CONFIGURATION;
