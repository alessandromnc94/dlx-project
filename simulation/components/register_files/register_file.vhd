LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY register_file IS
  GENERIC (
    width_add  : INTEGER := 5;
    width_data : INTEGER := 64
    );
  PORT (
    clk     : IN  STD_LOGIC;
    reset   : IN  STD_LOGIC;
    enable  : IN  STD_LOGIC;
    rd1     : IN  STD_LOGIC;
    rd2     : IN  STD_LOGIC;
    wr      : IN  STD_LOGIC;
    add_wr  : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
    add_rd1 : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
    add_rd2 : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
    datain  : IN  STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    out1    : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    out2    : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF register_file IS

  -- define type for registers array
  TYPE reg_array IS (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);

  SIGNAL registers : reg_array(0 TO 2**width_add-1) := (OTHERS => (OTHERS => '0'));

BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF reset = '1' THEN
        out1      <= (OTHERS => 'z');
        out2      <= (OTHERS => 'z');
        registers <= (OTHERS => (OTHERS => '0'));
      ELSIF enable = '1' THEN
        IF wr = '1' THEN
          registers(conv_integer(add_wr)) <= datain;
        END IF;
        IF rd1 = '1' THEN
          out1 <= registers(conv_integer(add_rd1));
        END IF;
        IF rd2 = '1' THEN
          out2 <= registers(conv_integer(add_rd2));
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_register_file_behavioral OF register_file IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
