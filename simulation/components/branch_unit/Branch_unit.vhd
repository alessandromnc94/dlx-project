LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY branch_unit IS
  GENERIC (
    n1 : INTEGER := 32;
    );
  PORT (
    imm : IN  STD_LOGIC_VECTOR(n1-1 DOWNTO 0);  --from datapath
    reg : IN  STD_LOGIC_VECTOR(n1-1 DOWNTO 0);
    npc : IN  STD_LOGIC_VECTOR(n1-1 DOWNTO 0);
    be  : IN  STD_LOGIC;                        --from cu
    jr  : IN  STD_LOGIC;
    jmp : IN  STD_LOGIC;
    pc  : OUT STD_LOGIC_VECTOR(n1-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF branch_unit IS

  COMPONENT mux_n_2_1 IS
    GENERIC (
      n : INTEGER := 1
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT zero_comparator IS
    GENERIC (
      n : INTEGER := 8
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER := 4
      );
    PORT (
      in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT not_gate IS
    PORT (
      in_s  : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;

  SIGNAL om1, os              : STD_LOGIC_VECTOR(n1-1 DOWNTO 0);
  SIGNAL ocmp, oinv, om2, om3 : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN

  comp : zero_comparator GENERIC MAP(n => n1)
    PORT MAP(reg, ocmp(0));
  add : rca_n GENERIC MAP(n => n1)
    PORT MAP(npc, imm, '0', os, OPEN);
  inv  : not_gate PORT MAP(ocmp(0), oinv(0));
  mux1 : mux_n_2_1 GENERIC MAP(n => n1)
    PORT MAP(os, reg, jr, om1);
  mux2 : mux_n_2_1 GENERIC MAP(n => 1)
    PORT MAP(oinv, ocmp, be, om2);
  mux3 : mux_n_2_1 GENERIC MAP(n => 1)
    PORT MAP("0", om2, jmp, om3);
  mux4 : mux_n_2_1 GENERIC MAP(n => n1)
    PORT MAP(npc, om1, om3(0), pc);

END ARCHITECTURE;
