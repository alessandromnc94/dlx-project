library ieee;
use ieee.std_logic_1164.all;
use work.alu_types.all;


entity datapath is
  generic (
    instr_size    : integer := 32;
    imm_val_size  : integer := 16;
    j_val_size    : integer := 26;
    reg_addr_size : integer := 5;
    n_bit         : integer := 32;
    ext_mem_bit   : integer := 32  --to be modified, length of addresses of extern memory, data memory must have 32 bit of address to mantain compatibility!!!!
    );
  port (
    -- input
    instr  : in     std_logic_vector(instr_size-1 downto 0);  --current instruction from iram, feeds the ir
    lmdin  : in     std_logic_vector(n_bit-1 downto 0);  --lmd register data input
    clk    : in     std_logic;          --clock signal
    -- 1st stage
    pcr    : in     std_logic;          --program counter reset
    pce    : in     std_logic;          --program counter enable
    npcr   : in     std_logic;          --npc reset
    npce   : in     std_logic;          --npc counter enable
    irr    : in     std_logic;          --instruction register reset
    ire    : in     std_logic;          --instruction register enable
    -- 2nd stage
    --register file signals
    rfr    : in     std_logic;          --reset
    rfe    : in     std_logic;          --enable
    rfr1   : in     std_logic;          --read enable 1
    rfr2   : in     std_logic;          --read enable 2
    rfw    : in     std_logic;          --write enable
    --branch unit signals
    be     : in     std_logic;          --beqz/!bnez
    jr     : in     std_logic;          --jr/!nojr
    jmp    : in     std_logic;          --jmp/!nojmp
    --sign extender and registers signals
    see    : in     std_logic;          --sign extender enable
    ar     : in     std_logic;          --a register reset
    ae     : in     std_logic;          --a register enable
    br     : in     std_logic;          --b register reset
    ben    : in     std_logic;          --b register enable
    ir     : in     std_logic;          --immediate register enable
    ie     : in     std_logic;          --immediate register enable
    -- 3rd stage
    --forwarding unit signals
    arf1   : in     std_logic_vector(reg_addr_size-1 downto 0);  --addresses of registers for the current operation(content of a and b registers) 
    arf2   : in     std_logic_vector(reg_addr_size-1 downto 0);
    exear  : in     std_logic_vector(reg_addr_size-1 downto 0);  --address of reg in execute stage
    memar  : in     std_logic_vector(reg_addr_size-1 downto 0);  --address of reg in memory stage
    --alu signals
    alusel : in     alu_array;          --alu operation selectors
    --muxes and registers signals
    m3s    : in     std_logic;          --mux 3 selector
    aor    : in     std_logic;          --alu_out register reset
    aoe    : in     std_logic;          --alu_out registes enable
    mer    : in     std_logic;          --me register reset
    mee    : in     std_logic;          --me register enable
    -- 4th stage
    r1r    : in     std_logic;          --register 1 reset
    r1e    : in     std_logic;          --register 1 enable
    lmdr   : in     std_logic;          --lmd register reset
    lmde   : in     std_logic;          --lmd register reset
    m4s    : in     std_logic;          --mux 5 selector
    -- 5th stage
    m5s    : in     std_logic;          --mux 5 selector
    r2r    : in     std_logic;          --register 2 reset
    r2e    : in     std_logic;          --register 2 enable
    -- outputs
    pcout  : buffer std_logic_vector(ext_mem_bit-1 downto 0);  --program counter output per le dimensioni puoi cambiarlo, la iram puo' essere diversa dalla dram
    aluout : buffer std_logic_vector(ext_mem_bit-1 downto 0);  --alu output data
    meout  : out    std_logic_vector(n_bit-1 downto 0)   --me register data out
    );
end entity;

architecture structural of datapath is

  component register_n is
    generic (
      n : integer := 8
      );
    port (
      din  : in  std_logic_vector(n-1 downto 0);
      clk  : in  std_logic;
      rst  : in  std_logic;
      set  : in  std_logic;
      en   : in  std_logic;
      dout : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component rca_n is
    generic (
      n : integer := 4
      );
    port (
      in_1      : in  std_logic_vector(n-1 downto 0);
      in_2      : in  std_logic_vector(n-1 downto 0);
      carry_in  : in  std_logic;
      sum       : out std_logic_vector(n-1 downto 0);
      carry_out : out std_logic
      );
  end component;

  component branch_unit is
    generic (
      n1 : integer := 32
      );
    port (
      imm : in  std_logic_vector(n1-1 downto 0);  --from datapath
      reg : in  std_logic_vector(n1-1 downto 0);
      npc : in  std_logic_vector(n1-1 downto 0);
      be  : in  std_logic;                        --from cu
      jr  : in  std_logic;
      jmp : in  std_logic;
      pc  : out std_logic_vector(n1-1 downto 0)
      );
  end component;

  component register_file is
    generic (
      width_add  : integer := 5;
      width_data : integer := 64
      );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      enable  : in  std_logic;
      rd1     : in  std_logic;
      rd2     : in  std_logic;
      wr      : in  std_logic;
      add_wr  : in  std_logic_vector(width_add-1 downto 0);
      add_rd1 : in  std_logic_vector(width_add-1 downto 0);
      add_rd2 : in  std_logic_vector(width_add-1 downto 0);
      datain  : in  std_logic_vector(width_data-1 downto 0);
      out1    : out std_logic_vector(width_data-1 downto 0);
      out2    : out std_logic_vector(width_data-1 downto 0)
      );
  end component;

  component sign_extender is
    generic (
      n_in  : integer := 32;
      n_out : integer := 2*n_in
      );
    port (
      in_s  : in  std_logic_vector(n_in-1 downto 0);
      en    : in  std_logic;
      out_s : out std_logic_vector(n_out-1 downto 0)
      );
  end component;

  component forwarding_unit is
    generic (
      n : integer := 32;                --address length
      m : integer := 32                 --data length
      );
    port (
      arf1    : in  std_logic_vector(n-1 downto 0);  --addresses of regisers for the current operation 
      arf2    : in  std_logic_vector(n-1 downto 0);
      exear   : in  std_logic_vector(n-1 downto 0);  --adrress of reg in execute stage
      memar   : in  std_logic_vector(n-1 downto 0);  --adrress of reg in memory stage
      exed    : in  std_logic_vector(m-1 downto 0);  -- data coming from execute stage
      memd    : in  std_logic_vector(m-1 downto 0);  -- data coming from memory stage
      clk     : in  std_logic;
      out_mux : out std_logic_vector(1 downto 0);
      dout1   : out std_logic_vector(m-1 downto 0);  -- data to be forwarded
      dout2   : out std_logic_vector(m-1 downto 0)
      );
  end component;

  component mux_n_2_1 is
    generic (
      n : integer := 1
      );
    port (
      in_0  : in  std_logic_vector(n-1 downto 0);
      in_1  : in  std_logic_vector(n-1 downto 0);
      s     : in  std_logic;
      out_s : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component alu is
    generic (
      n : integer := 32
      );
    port (
      in_1   : in  std_logic_vector(n-1 downto 0);
      in_2   : in  std_logic_vector(n-1 downto 0);
      op_sel : in  alu_array;
      -- outputs
      out_s  : out std_logic_vector(n-1 downto 0)
      );
  end component;

  signal pcin, npcin, aconst, npcout                                : std_logic_vector(ext_mem_bit-1 downto 0);
  signal irout                                                      : std_logic_vector(instr_size-1 downto 0);
  signal om5, ain, bin, immin, aout, bout, immout, fuo1, fuo2, fuo3 : std_logic_vector(n_bit-1 downto 0);
  signal fuo4, om1, om2, om3, om4, oalu, meout, r1out, lmdout       : std_logic_vector(n_bit-1 downto 0);
  signal fum                                                        : std_logic_vector(1 downto 0);

begin

  -- indici sbagliati: n-1 downto 3; 2 downto 0
  -- indici giust per il x4: n-1 downto 2; 1 downto 0
  -- è la soluzione migliore perchè usi meno risorse
  aconst(ext_mem_bit-1 downto 2) <= (others => '0');
  aconst(1 downto 0)             <= "100";  --brutto, trova un'alternativa per sommare 4!!!

  --fetch stage
  pc : register_n generic map(n => ext_mem_bit)   --puo' cambiare
    port map(pcin, clk, pcr, '0', pce, pcout);
  ir : register_n generic map(n => instr_size)
    port map(instr, clk, irr, '0', ire, irout);
  add : rca_n generic map(n => ext_mem_bit)  --deve essere uguale al program counter                 
    port map(pcout, aconst, '0', npcin, open);
  npc : register_n generic map(n => ext_mem_bit)  --come pc
    port map(npcin, clk, npcr, '0', npce, npcout);

  --decode stage
  reg_file : register_file generic map(width_add => reg_addr_size, width_data => n_bit)
    port map(clk, rfr, rfe, rfr1, rfr2, rfw, irout(instr_size-7 downto instr_size-11), irout(instr_size-12 downto instr_size-16), irout(instr_size-17 downto instr_size-21), om5, ain, bin);
  sign_extend : sign_extender generic map(n_in => imm_val_size, n_out => n_bit)
    port map(irout(instr_size-17 downto 0), see, immin);
  branch : branch_unit generic map(n1 => ext_mem_bit)  --lo stesso di pc
    port map(immin, ain, npcout, be, jr, jmp, pcin);  --occhio che l'immediato non ha la stessa dimensione di npc e pc, quindi devi estendere la dim di immediate dentro il modulo!!!!!!!
  areg : register_n generic map(n => n_bit)
    port map(ain, clk, ar, '0', ae, aout);
  breg : register_n generic map(n => n_bit)
    port map(bin, clk, br, '0', ben, bout);
  immreg : register_n generic map(n => n_bit)
    port map(immin, clk, ir, '0', ie, immout);

  --execute stage
  mux1 : mux_n_2_1 generic map(n => n_bit)
    port map(aout, fuo1, fum(0), om1);
  mux2 : mux_n_2_1 generic map(n => n_bit)
    port map(bout, fuo2, fum(1), om2);
  mux3 : mux_n_2_1 generic map(n => n_bit)
    port map(om2, immout, m3s, om3);
  me : register_n generic map(n => n_bit)
    port map(bout, clk, mer, '0', mee, meout);
  aluinst : alu generic map(n => n_bit)
    port map(om1, om3, alusel, oalu);
  aluoutinst : register_n generic map(n => n_bit)
    port map(oalu, clk, aor, '0', aoe, aluout);
  forwinst : forwarding_unit generic map(n => reg_addr_size, m => n_bit);
  port map(arf1, arf2, exear, memar, aluout, om4, clk, fum, fuo1, fuo2);

  --memory stage
  reg1inst : register_n generic map(n => n_bit)
    port map(aluout, clk, r1r, '0', r2e, r1out);
  lmd : register_n generic map(n => n_bit)
    port map(lmdin, clk, lmdr, '0', lmde, lmdout);
  mux4 : mux_n_2_1 generic map(n => n_bit)
    port map(r1out, lmdout, m4s, om4);

  --write back stage
  mux5 : mux_n_2_1 generic map(n => n_bit)
    port map(lmdout, r1out, m5s, om5);

end architecture;
