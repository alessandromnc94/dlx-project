LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY datapath IS
  GENERIC (
    instr_size    : INTEGER := 32;
    imm_val_size  : INTEGER := 16;
    j_val_size    : INTEGER := 26;
    reg_addr_size : INTEGER := 6;
    n_bit         : INTEGER := 32
    );
  PORT (
    -- input
    instr : IN STD_LOGIC_VECTOR(instr_size-1 DOWNTO 0);
    -- 1st stage
    -- 2nd stage
    -- 3rd stage
    -- 4th stage
    -- 5th stage
    -- outputs
    out_s :    STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0)
    );
END datapath;
