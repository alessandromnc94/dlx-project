LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY tb_register_file_win IS
  GENERIC (
    width_data         : INTEGER := 4;
    n_global_registers : INTEGER := 1;
    n_local_registers  : INTEGER := 1;
    windows            : INTEGER := 4
    );
END ENTITY;

ARCHITECTURE testbench OF tb_register_file_win IS
  CONSTANT clk_period : TIME := 1 NS;

  COMPONENT register_file_win IS
    GENERIC (
      width_data         : INTEGER := 64;
      n_global_registers : INTEGER := 8;
      n_local_registers  : INTEGER := 8;
      windows            : INTEGER := 4
      );
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
  END COMPONENT;

  SIGNAL clk              : STD_LOGIC                                                                    := '0';
  SIGNAL reset            : STD_LOGIC                                                                    := '0';
  SIGNAL enable           : STD_LOGIC                                                                    := '0';
  SIGNAL rd1              : STD_LOGIC                                                                    := '0';
  SIGNAL rd2              : STD_LOGIC                                                                    := '0';
  SIGNAL wr               : STD_LOGIC                                                                    := '0';
  SIGNAL add_wr           : STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL add_rd1          : STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL add_rd2          : STD_LOGIC_VECTOR(log2int(3*n_local_registers+n_global_registers)-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL datain           : STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)                                      := (OTHERS => '0');
  SIGNAL out1             : STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)                                      := (OTHERS => '0');
  SIGNAL out2             : STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)                                      := (OTHERS => '0');
  SIGNAL sub_call         : STD_LOGIC                                                                    := '0';
  SIGNAL sub_ret          : STD_LOGIC                                                                    := '0';
  SIGNAL spill            : STD_LOGIC                                                                    := '0';
  SIGNAL fill             : STD_LOGIC                                                                    := '0';
  SIGNAL to_memory_data   : STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)                                      := (OTHERS => '0');
  SIGNAL from_memory_data : STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)                                      := (OTHERS => '0');

  -- signals for testbench
  SIGNAL windows_in_memory : INTEGER := 0;
  SIGNAL windows_in_rf     : INTEGER := 1;

  -- signal added only for show the clk_period during simulation
  SIGNAL clk_period_s : TIME := clk_period;
BEGIN  -- architecture behavioral
  -- clock signal
  clk              <= NOT clk AFTER clk_period/2;
  -- 'from_memory_data' is always the # of windows in rf
  from_memory_data <= conv_std_logic_vector(windows_in_rf, from_memory_data'LENGTH);

  dut : register_file_win
    GENERIC MAP (
      n_global_registers => n_global_registers,
      n_local_registers  => n_local_registers,
      width_data         => width_data,
      windows            => windows
      )
    PORT MAP (
      clk              => clk,
      reset            => reset,
      enable           => enable,
      rd1              => rd1,
      rd2              => rd2,
      wr               => wr,
      add_wr           => add_wr,
      add_rd1          => add_rd1,
      add_rd2          => add_rd2,
      datain           => datain,
      out1             => out1,
      out2             => out2,
      sub_call         => sub_call,
      sub_ret          => sub_ret,
      spill            => spill,
      fill             => fill,
      to_memory_data   => to_memory_data,
      from_memory_data => from_memory_data
      );

  PROCESS(spill, fill, reset)
  BEGIN
    IF reset = '1' THEN
      windows_in_memory <= 0;
    ELSIF rising_edge(spill) THEN
      windows_in_memory <= windows_in_memory + 1;
    ELSIF rising_edge(fill) THEN
      windows_in_memory <= windows_in_memory - 1;
    END IF;
  END PROCESS;

  PROCESS (sub_ret, sub_call, reset) IS
  BEGIN  -- process
    IF reset = '1' THEN
      windows_in_rf <= 1;
    ELSIF rising_edge(sub_call) THEN
      windows_in_rf <= windows_in_rf + 1;
    ELSIF rising_edge(sub_ret) THEN
      IF windows_in_rf > 1 THEN
        windows_in_rf <= windows_in_rf - 1;
      ELSE
        REPORT "no window in rf!!!" SEVERITY WARNING;
      END IF;
    END IF;
  END PROCESS;

  PROCESS
  BEGIN
    -- reset the register file
    REPORT "reset the register file in order to write on globals registers (the value of register is its address)" SEVERITY NOTE;
    reset  <= '1';
    WAIT UNTIL falling_edge(clk);
    WAIT FOR 5 * clk_period;
    -- enable 
    reset  <= '0';
    enable <= '1';
    -- outputs are setted to high impedence
    WAIT FOR 5 * clk_period;
    -- write in all global registers their indexes starting from 1
    wr     <= '1';
    FOR i IN 0 TO n_global_registers-1 LOOP
      add_wr <= conv_std_logic_vector(i, add_wr'LENGTH);
      datain <= conv_std_logic_vector(i, datain'LENGTH);
      WAIT FOR clk_period;
    END LOOP;  -- i

    REPORT "write on the first window registers (the value of register is its address in the section preceded by 3 bits: '001' is for in registers, '010' is for local and '100' is for out)" SEVERITY FAILURE;
    WAIT UNTIL falling_edge(clk);
    WAIT FOR 5 * clk_period;
    reset <= '1';
    WAIT FOR clk_period;
    reset <= '0';
    WAIT FOR clk_period;
    -- test writing on first window
    FOR i IN 0 TO n_local_registers-1 LOOP
      datain <= "001" & conv_std_logic_vector(i, datain'LENGTH-3);
      add_wr <= conv_std_logic_vector(n_global_registers+i, add_wr'LENGTH);
      WAIT FOR clk_period;
      datain <= "010" & conv_std_logic_vector(i, datain'LENGTH-3);
      add_wr <= conv_std_logic_vector(n_global_registers+n_local_registers+i, add_wr'LENGTH);
      WAIT FOR clk_period;
      datain <= "100" & conv_std_logic_vector(i, datain'LENGTH-3);
      add_wr <= conv_std_logic_vector(n_global_registers+2*n_local_registers+i, add_wr'LENGTH);
      WAIT FOR clk_period;
    END LOOP;  -- i
    wr     <= '0';
    WAIT FOR clk_period;
    REPORT "reset register file to test call and ret subroutine: registers in a window contains its number" SEVERITY FAILURE;
    WAIT FOR 1 US;
    WAIT UNTIL falling_edge(clk);
    reset  <= '1';
    datain <= (OTHERS => '0');
    WAIT FOR clk_period;
    reset  <= '0';
    WAIT FOR clk_period;

    -- test call routine 'windows'+1 times
    -- 2 spills done
    FOR i IN 0 TO windows + 1 LOOP
      datain <= conv_std_logic_vector(windows_in_rf, datain'LENGTH);
      WAIT FOR clk_period;
      -- set registers as # of window
      wr     <= '1';
      FOR k IN 0 TO n_global_registers + 3 * n_local_registers -1 LOOP
        add_wr <= conv_std_logic_vector(n_global_registers+k, add_wr'LENGTH);
        WAIT FOR clk_period;
      END LOOP;  -- k
      wr       <= '0';
      WAIT FOR clk_period;
      sub_call <= '1';
      WAIT FOR clk_period;
      sub_call <= '0';
      WAIT FOR clk_period;
      IF spill = '1' THEN
        WAIT UNTIL spill = '0';
        WAIT FOR clk_period;
      END IF;
      WAIT FOR 5 * clk_period;
    END LOOP;  -- i
    WAIT FOR 5 * clk_period;

    -- test ret routine 3 times
    -- no fills done
    FOR i IN 0 TO 2 LOOP
      sub_ret <= '1';
      WAIT FOR clk_period;
      sub_ret <= '0';
      WAIT FOR clk_period;
      IF fill = '1' THEN
        WAIT UNTIL fill = '0';
        WAIT FOR clk_period;
      END IF;
    END LOOP;  -- i

    WAIT FOR 10 * clk_period;

    -- test ret routine all windows
    -- 2 fills done
    WHILE windows_in_memory > 0 LOOP
      sub_ret <= '1';
      WAIT FOR clk_period;
      sub_ret <= '0';
      WAIT FOR clk_period;
      IF fill = '1' THEN
        WAIT UNTIL fill = '0';
        WAIT FOR clk_period;
      END IF;
      WAIT FOR 5 * clk_period;
    END LOOP;
    REPORT "testbench finished" SEVERITY FAILURE;
    WAIT;
  END PROCESS;
END ARCHITECTURE;

CONFIGURATION cfg_tb_register_file_win_behavioral OF tb_register_file_win
  FOR testbench
  FOR dut : register_file_win USE CONFIGURATION work.cfg_register_file_win_behavioral;
END FOR;
END FOR;
END CONFIGURATION;
