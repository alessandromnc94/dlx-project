LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xnor_gate_n IS
  generic (
    n : integer := 1
  )
  PORT (
<<<<<<< HEAD
    in_1  : IN  STD_LOGIC_vector(n-1 downto 0);
    in_2  : IN  STD_LOGIC_vector(n-1 downto 0);
    out_s : OUT STD_LOGIC_vector(n-1 downto 0)
=======
    in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    out_s : OUT STD_LOGIC
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF xnor_gate_n IS
  SIGNAL tmp_out_s : STD_LOGIC;
BEGIN
<<<<<<< HEAD
  out_s <= in_1 xnor in_2;
END ARCHITECTURE;

-- structural architecture
ARCHITECTURE structural OF xnor_gate_n IS
  component xnor_gate is 
  port (
    in_1 : in std_logic;
    in_2 : in std_logic;
    out_s : out std_logic
  );
  end component;

BEGIN
gate_gen : for i in 0 to n-1 generate
  xnor_gate_x : xnor_gate port map (
    in_1 => in_1(i),
    in_2 => in_2(i),
    out_s => out_s(i)
  );
  end generate;
=======
  tmp_out_s <= in_s(0);
  xor_gates_gen : FOR j IN 1 TO n-1 GENERATE
    tmp_out_s <= tmp_out_s XOR i(j);
  END GENERATE;

  out_s <= NOT tmp_out_s;

-- it works only with vhdl 2008
-- out_s <= xnor i;

>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_xnor_gate_n_behavioral OF xnor_gate_n IS
  FOR behavioral
  END FOR;
END CONFIGURATION;

-- structural configuration
CONFIGURATION cfg_xnor_gate_n_structural OF xnor_gate_n IS
  FOR structural
    for gate_gen
      for xnor_gate_x : xnor_gate use configuration work.cfg_xnor_gate_behavioral;
      end for;
    end for;
  END FOR;
END CONFIGURATION;
