LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.alu_types.ALL;


ENTITY datapath IS
  GENERIC (
    instr_size    : INTEGER := 32;
    imm_val_size  : INTEGER := 16;
    j_val_size    : INTEGER := 26;
    reg_addr_size : INTEGER := 5;
    n_bit         : INTEGER := 32;
    ext_mem_bit   : INTEGER := 32  --to be modified, length of addresses of extern memory, data memory must have 32 bit of address to mantain compatibility!!!!
    );
  PORT (
    -- input
    instr  : IN     STD_LOGIC_VECTOR(instr_size-1 DOWNTO 0);  --current instruction from iram, feeds the ir
    lmdin  : IN     STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);  --lmd register data input
    clk    : IN     STD_LOGIC;          --clock signal
    -- 1st stage
    pcr    : IN     STD_LOGIC;          --program counter reset
    pce    : IN     STD_LOGIC;          --program counter enable
    npcr   : IN     STD_LOGIC;          --npc reset
    npce   : IN     STD_LOGIC;          --npc counter enable
    irr    : IN     STD_LOGIC;          --instruction register reset
    ire    : IN     STD_LOGIC;          --instruction register enable
    -- 2nd stage
    --register file signals
    rfr    : IN     STD_LOGIC;          --reset
    rfe    : IN     STD_LOGIC;          --enable
    rfr1   : IN     STD_LOGIC;          --read enable 1
    rfr2   : IN     STD_LOGIC;          --read enable 2
    rfw    : IN     STD_LOGIC;          --write enable
    --branch unit signals
    be     : IN     STD_LOGIC;          --beqz/!bnez
    jr     : IN     STD_LOGIC;          --jr/!nojr
    jmp    : IN     STD_LOGIC;          --jmp/!nojmp
    --sign extender and registers signals
    see    : IN     STD_LOGIC;          --sign extender enable
    ar     : IN     STD_LOGIC;          --a register reset
    ae     : IN     STD_LOGIC;          --a register enable
    br     : IN     STD_LOGIC;          --b register reset
    ben    : IN     STD_LOGIC;          --b register enable
    ir     : IN     STD_LOGIC;          --immediate register enable
    ie     : IN     STD_LOGIC;          --immediate register enable
    -- 3rd stage
    --forwarding unit signals
    arf1   : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0);  --addresses of registers for the current operation(content of a and b registers) 
    arf2   : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0);
    exear  : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0);  --address of reg in execute stage
    memar  : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0);  --address of reg in memory stage
    --alu signals
    alusel : IN     alu_array;          --alu operation selectors
    --muxes and registers signals
    m3s    : IN     STD_LOGIC;          --mux 3 selector
    aor    : IN     STD_LOGIC;          --alu_out register reset
    aoe    : IN     STD_LOGIC;          --alu_out registes enable
    mer    : IN     STD_LOGIC;          --me register reset
    mee    : IN     STD_LOGIC;          --me register enable
    -- 4th stage
    r1r    : IN     STD_LOGIC;          --register 1 reset
    r1e    : IN     STD_LOGIC;          --register 1 enable
    lmdr   : IN     STD_LOGIC;          --lmd register reset
    lmde   : IN     STD_LOGIC;          --lmd register reset
    m4s    : IN     STD_LOGIC;          --mux 5 selector
    -- 5th stage
    m5s    : IN     STD_LOGIC;          --mux 5 selector
    r2r    : IN     STD_LOGIC;          --register 2 reset
    r2e    : IN     STD_LOGIC;          --register 2 enable
    -- outputs
    pcout  : BUFFER STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);  --program counter output per le dimensioni puoi cambiarlo, la iram puo' essere diversa dalla dram
    aluout : BUFFER STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);  --alu outpud data
    meout  : OUT    STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0)   --me register data out
    );
END ENTITY;

ARCHITECTURE structural OF datapath IS

  COMPONENT register_n IS
    GENERIC (
      n : INTEGER := 8
      );
    PORT (
      din  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      clk  : IN  STD_LOGIC;
      rst  : IN  STD_LOGIC;
      set  : IN  STD_LOGIC;
      en   : IN  STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
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

  COMPONENT branch_unit IS
    GENERIC (
      n1 : INTEGER := 32
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
  END COMPONENT;

  COMPONENT register_file IS
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
  END COMPONENT;

  COMPONENT sign_extender IS
    GENERIC (
      n_in  : INTEGER := 32;
      n_out : INTEGER := 2*n_in
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n_in-1 DOWNTO 0);
      en    : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT forwarding_unit IS
    GENERIC (
      n : INTEGER := 32;                --address length
      m : INTEGER := 32                 --data length
      );
    PORT (
      arf1    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --addresses of regisers for the current operation 
      arf2    : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      exear   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --adrress of reg in execute stage
      memar   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);  --adrress of reg in memory stage
      exed    : IN  STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data coming from execute stage
      memd    : IN  STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data coming from memory stage
      clk     : IN  STD_LOGIC;
      out_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      dout1   : OUT STD_LOGIC_VECTOR(m-1 DOWNTO 0);  -- data to be forwarded
      dout2   : OUT STD_LOGIC_VECTOR(m-1 DOWNTO 0)
      );
  END COMPONENT;

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

  COMPONENT alu IS
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
  END COMPONENT;

  SIGNAL pcin, npcin, aconst, npcout                                : STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);
  SIGNAL irout                                                      : STD_LOGIC_VECTOR(instr_size-1 DOWNTO 0);
  SIGNAL om5, ain, bin, immin, aout, bout, immout, fuo1, fuo2, fuo3 : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);
  SIGNAL fuo4, om1, om2, om3, om4, oalu, meout, r1out, lmdout       : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);
  SIGNAL fum                                                        : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

  aconst(ext_mem_bit-1 DOWNTO 3) <= (OTHERS => '0');
  aconst(2 DOWNTO 0)             <= "100";  --brutto, trova un'alternativa per sommare 4!!!

  --fetch stage
  pc : register_n GENERIC MAP(n => ext_mem_bit)   --puo' cambiare
    PORT MAP(pcin, clk, pcr, '0', pce, pcout);
  ir : register_n GENERIC MAP(n => instr_size)
    PORT MAP(instr, clk, irr, '0', ire, irout);
  add : rca_n GENERIC MAP(n => ext_mem_bit)  --deve essere uguale al program counter                 
    PORT MAP(pcout, aconst, '0', npcin, OPEN);
  npc : register_n GENERIC MAP(n => ext_mem_bit)  --come pc
    PORT MAP(npcin, clk, npcr, '0', npce, npcout);

  --decode stage
  reg_file : register_file GENERIC MAP(width_add => reg_addr_size, width_data => n_bit)
    PORT MAP(clk, rfr, rfe, rfr1, rfr2, rfw, irout(instr_size-7 DOWNTO instr_size-11), irout(instr_size-12 DOWNTO instr_size-16), irout(instr_size-17 DOWNTO instr_size-21), om5, ain, bin);
  sign_extend : sign_extender GENERIC MAP(n_in => imm_val_size, n_out => n_bit)
    PORT MAP(irout(instr_size-17 DOWNTO 0), see, immin);
  branch : branch_unit GENERIC MAP(n1 => ext_mem_bit)  --lo stesso di pc
    PORT MAP(immin, ain, npcout, be, jr, jmp, pcin);  --occhio che l'immediato non ha la stessa dimensione di npc e pc, quindi devi estendere la dim di immediate dentro il modulo!!!!!!!
  areg : register_n GENERIC MAP(n => n_bit)
    PORT MAP(ain, clk, ar, '0', ae, aout);
  breg : register_n GENERIC MAP(n => n_bit)
    PORT MAP(bin, clk, br, '0', ben, bout);
  immreg : register_n GENERIC MAP(n => n_bit)
    PORT MAP(immin, clk, ir, '0', ie, immout);

  --execute stage
  mux1 : mux_n_2_1 GENERIC MAP(n => n_bit)
    PORT MAP(aout, fuo1, fum(0), om1);
  mux2 : mux_n_2_1 GENERIC MAP(n => n_bit)
    PORT MAP(bout, fuo2, fum(1), om2);
  mux3 : mux_n_2_1 GENERIC MAP(n => n_bit)
    PORT MAP(om2, immout, m3s, om3);
  me : register_n GENERIC MAP(n => n_bit)
    PORT MAP(bout, clk, mer, '0', mee, meout);
  aluinst : alu GENERIC MAP(n => n_bit)
    PORT MAP(om1, om3, alusel, oalu);
  aluoutinst : register_n GENERIC MAP(n => n_bit)
    PORT MAP(oalu, clk, aor, '0', aoe, aluout);
  forwinst : forwarding_unit GENERIC MAP(n => reg_addr_size, m => n_bit);
  PORT MAP(arf1, arf2, exear, memar, aluout, om4, clk, fum, fuo1, fuo2);

  --memory stage
  reg1inst : register_n GENERIC MAP(n => n_bit)
    PORT MAP(aluout, clk, r1r, '0', r2e, r1out);
  lmd : register_n GENERIC MAP(n => n_bit)
    PORT MAP(lmdin, clk, lmdr, '0', lmde, lmdout);
  mux4 : mux_n_2_1 GENERIC MAP(n => n_bit)
    PORT MAP(r1out, lmdout, m4s, om4);

  --write back stage
  mux5 : mux_n_2_1 GENERIC MAP(n => n_bit)
    PORT MAP(lmdout, r1out, m5s, om5);

END ARCHITECTURE;
