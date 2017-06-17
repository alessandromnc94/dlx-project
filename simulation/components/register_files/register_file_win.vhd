LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.my_arith_functions.ALL;

ENTITY register_file_win IS
  GENERIC (
    width_data         : INTEGER := 64;
    n_global_registers : INTEGER := 8;
    n_local_registers  : INTEGER := 8;
    windows            : INTEGER := 8);
  PORT (
    clk              : IN  STD_LOGIC;
    reset            : IN  STD_LOGIC;
    enable           : IN  STD_LOGIC;
    rd1              : IN  STD_LOGIC;
    rd2              : IN  STD_LOGIC;
    wr               : IN  STD_LOGIC;
    add_wr           : IN  STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0);
    add_rd1          : IN  STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0);
    add_rd2          : IN  STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0);
    datain           : IN  STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    out1             : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    out2             : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    sub_call         : IN  STD_LOGIC;
    sub_ret          : IN  STD_LOGIC;
    spill            : OUT STD_LOGIC;
    fill             : OUT STD_LOGIC;
    to_memory_data   : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
    from_memory_data : IN  STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)
    );
END ENTITY;

-- architectures

-- behavioral architecture
ARCHITECTURE behavioral OF register_file_win IS
  -- define constants
  -- offset_cwp is used to shift pointers swp and cwp
  CONSTANT offset_cwp            : INTEGER := 2 * n_local_registers;
  -- n_window_registers contains the number of registers (except global) of a window (in + local + out)
  CONSTANT n_window_registers    : INTEGER := 3 * n_local_registers;
  -- width_add contains the number of bits to address registers in a window (global + in + local + out )
  CONSTANT width_add             : INTEGER := log2int(n_window_registers + n_global_registers);
  -- total_registers contains the number of all registers (except global)
  CONSTANT n_total_win_registers : INTEGER := windows * offset_cwp;
  
  -- define type for registers array
  TYPE reg_array IS (natural range <>) OF STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);

  -- define signals
  -- 'global_registers' is the collection of global registers
  SIGNAL global_registers        : reg_array(0 TO n_global_registers-1)    := (OTHERS => (OTHERS => '0'));
  -- 'win_registers' is the collection of in, local (and out) registers
  SIGNAL win_registers           : reg_array(0 TO n_total_win_registers-1) := (OTHERS => (OTHERS => '0'));
  -- 'swp' and 'cwp' contains the address of the 1st register of stored window and current window
  SIGNAL cwp, swp                : INTEGER                                                        := 0;
  -- 'in_spilling' and 'in_filling' are signals used to check which operation is in execution.
  -- they are needed because 'spill' and 'fill' outputs can be only modified but not checked in 'if' conditions
  SIGNAL in_spilling, in_filling : STD_LOGIC                                                      := '0';
  -- 'rf_cycles' contains how many times cycles are started.
  -- it is used to check if at the least one window is stored in memory
  SIGNAL rf_cycles               : INTEGER                                                        := 0;
  -- 'memory_cnt' is an offset used during filling and spilling operation
  SIGNAL memory_cnt              : INTEGER                                                        := 0;

BEGIN

  spill <= in_spilling;
  fill  <= in_filling;

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      -- reset operation is synchronous
      IF reset = '1' THEN
        win_registers    <= (OTHERS => (OTHERS => '0'));
        global_registers <= (OTHERS => (OTHERS => '0'));
        out1             <= (OTHERS => 'Z');
        out2             <= (OTHERS => 'Z');
        cwp              <= 0;
        swp              <= 0;
        in_spilling      <= '0';
        in_filling       <= '0';
        to_memory_data   <= (OTHERS => 'Z');
        rf_cycles        <= 0;
      ELSIF enable = '1' THEN
        IF in_spilling = '1' THEN
          -- continue the spill operation if the number of stored registers is lower than the number of registers in e local in a windows
          -- else terminate it
          IF memory_cnt < offset_cwp THEN
            to_memory_data <= win_registers(getregpointer(swp, memory_cnt, windows, n_local_registers));
            memory_cnt     <= memory_cnt + 1;
          ELSE
            in_spilling <= '0';
            -- if swp is 0
            -- increase rf_cycles
            -- (new cycle started)
            IF swp = 0 THEN
              rf_cycles <= rf_cycles + 1;
            END IF;
            -- change pointers values
            swp <= getregpointer(swp, offset_cwp, windows, n_local_registers);
            cwp <= getregpointer(cwp, offset_cwp, windows, n_local_registers);
          END IF;
        ELSIF in_filling = '1' THEN
          -- like before but starting from the top
          IF memory_cnt > 0 THEN
            win_registers(getregpointer(swp, memory_cnt-1-offset_cwp, windows, n_local_registers)) <= from_memory_data;
            memory_cnt                                                                             <= memory_cnt - 1;
          ELSE
            in_filling <= '0';
            -- if swp = offset_cwp
            -- decrease rf_cycles
            -- (a cycle is completed)
            IF swp = offset_cwp THEN
              rf_cycles <= rf_cycles - 1;
            END IF;
            -- change pointers values
            swp <= getregpointer(swp, -offset_cwp, windows, n_local_registers);
            cwp <= getregpointer(cwp, -offset_cwp, windows, n_local_registers);
          END IF;
        -- call sub-routine
        ELSIF sub_call = '1' THEN
          -- the next condition checks if the next window is the last available
          -- thus if cwp+2*(offset_cwp) is equal to swp do a spill
          -- else increase cwp by offset_cwp
          IF getregpointer(cwp, 2*offset_cwp, windows, n_local_registers) = swp THEN
            in_spilling <= '1';
            memory_cnt  <= 0;
          ELSE
            cwp <= getregpointer(cwp, offset_cwp, windows, n_local_registers);
          END IF;
        -- ret sub-routine
        ELSIF sub_ret = '1' THEN
          -- the next condition checks if it is possible do a ret
          -- checking how many times t-he swp has to change its value from offset_cwp (poiter to the 2nd window)
          -- to 0 (pointer to the 1st window).
          -- if it is greater than 0 a ret is possible
          -- else report a warning to console
          IF rf_cycles > 0 THEN
            -- if cwp = swp a fill operation must be executed
            -- else decrease cwp by offset_cwp
            IF cwp = swp THEN
              in_filling <= '1';
              -- memory_cnt <= n_window_registers;
              memory_cnt <= offset_cwp;
            ELSE
              cwp <= getregpointer(cwp, -offset_cwp, windows, n_local_registers);
            END IF;
          ELSE
            REPORT "no ret routine: no window to return!" SEVERITY WARNING;
          END IF;
        ELSE
          -- write operation
          IF wr = '1' THEN
            -- if 'add_wr' is lower than 'n_global_registers' read global register
            IF conv_integer(add_wr) < n_global_registers THEN
              -- global registers
              global_registers(conv_integer(add_wr)) <= datain;
            -- else read a register of the window
            ELSE
              -- window registers (in, local, out)
              win_registers(getregpointer(cwp, conv_integer(add_wr)-n_global_registers, windows, n_local_registers)) <= datain;
            END IF;
          END IF;
          -- read from out1 operation
          IF rd1 = '1' THEN
            -- as before
            IF conv_integer(add_rd1) < n_global_registers THEN
              -- global registers
              out1 <= global_registers(conv_integer(add_rd1));
            ELSE
              -- window registers (in, local, out)
              out1 <= win_registers(getregpointer(cwp, conv_integer(add_rd1)-n_global_registers, windows, n_local_registers));
            END IF;
          END IF;
          -- read from out2 operation
          IF rd2 = '1' THEN
            -- as before
            IF conv_integer(add_rd2) < n_global_registers THEN
              -- global registers
              out2 <= global_registers(conv_integer(add_rd2));
            ELSE
              -- window registers (in, local, out)
              out2 <= win_registers(getregpointer(cwp, conv_integer(add_rd2)-n_global_registers, windows, n_local_registers));
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;

-- configurations

-- behavioral configuration
CONFIGURATION cfg_register_file_win_behavioral OF register_file_win IS
  FOR behavioral
  END FOR;
END CONFIGURATION;
