library ieee;
use ieee.std_logic_1164.all;
use work.alu_types.all;
use work.my_const.all;


entity datapath is
  generic (
    imm_val_size  : natural := 16;
    j_val_size    : natural := 26;
    reg_addr_size : natural := 32;
    n_bit         : natural := 32
    );
  port (
    -- input
    instr      : in     std_logic_vector(n_bit-1 downto 0);  --current instruction from iram, feeds the ir
    lmdin      : in     std_logic_vector(n_bit-1 downto 0);  --lmd register data input
    clk        : in     std_logic;      --clock signal
    rst        : in     std_logic;      --general reset signal
    -- 1st stage
    pce        : in     std_logic;      --program counter enable
    npce       : in     std_logic;      --npc counter enable
    ire        : in     std_logic;      --instruction register enable
    -- 2nd stage
    --register file signals
    rfe        : in     std_logic;      --enable
    rfr1       : in     std_logic;      --read enable 1
    rfr2       : in     std_logic;      --read enable 2
    rfw        : in     std_logic;      --write enable
    --branch unit signals
    be         : in     std_logic;      --branch enable
    bnez         : in     std_logic;      --beqz/!bnez
    jr         : in     std_logic;      --jr/!nojr
    jmp        : in     std_logic;      --jmp/!nojmp
    --sign extender and registers signals
    see        : in     std_logic;      --sign extender enable
    ae         : in     std_logic;      --a register enable
    ben        : in     std_logic;      --b register enable
    ie         : in     std_logic;      --immediate register enable
    pre        : in     std_logic;      --pc pipeline reg enable
    aw1e       : in     std_logic;      --address write1 reg enable
    -- 3rd stage
    --alu signals
    alusel     : in     alu_array;      --alu operation selectors
    --muxes and registers signals
    m3s        : in     std_logic;      --mux 3 selector
    aoe        : in     std_logic;      --alu_out registes enable
    mee        : in     std_logic;      --me register enable
    mps        : in     std_logic;      --mux from pc selector
    mss        : in     std_logic;      --mux to sum 8 to pc selector
    aw2e       : in     std_logic;      --address write2 reg enable
    -- 4th stage
    r1e        : in     std_logic;      --register 1 enable
    msksel2    : in     std_logic;      --selector for load byte mask
    msksigned2 : in     std_logic;      -- mask is signed if enabled
    lmde       : in     std_logic;      --lmd register enable
    m4s        : in     std_logic;      --mux 5 selector
    aw3e       : in     std_logic;      --address write3 reg enable
    -- 5th stage
    m5s        : in     std_logic;      --mux 5 selector
    mws        : in     std_logic;  --write addr mux selector(mux is physically in decode stage, but driven in wb stage)
    -- outputs
    pcout      : buffer std_logic_vector(n_bit-1 downto 0);  --program counter output per le dimensioni puoi cambiarlo, la iram puo' essere diversa dalla dram
    aluout     : buffer std_logic_vector(n_bit-1 downto 0);  --alu outpud data
    meout      : out    std_logic_vector(n_bit-1 downto 0)  --me register data out
    );
end entity;

architecture structural of datapath is

  component register_n is
    generic (
      n : natural := 8
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
      n : natural := 4
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
      n1 : natural := 32
      );
    port (
      imm : in  std_logic_vector(n1-1 downto 0);  --from datapath
      reg : in  std_logic_vector(n1-1 downto 0);
      npc : in  std_logic_vector(n1-1 downto 0);
      be  : in  std_logic;                        --from cu
      bnez  : in  std_logic;                        --from cu
      jr  : in  std_logic;
      jmp : in  std_logic;
      pc  : out std_logic_vector(n1-1 downto 0)
      );
  end component;

  component register_file is
    generic (
      width_add  : natural := 5;
      width_data : natural := 64
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
      n_in  : natural := 32;
      n_out : natural := 64
      );
    port (
      in_s  : in  std_logic_vector(n_in-1 downto 0);
      en    : in  std_logic;
      out_s : out std_logic_vector(n_out-1 downto 0)
      );
  end component;

  component forwarding_unit is
    generic (
      n : natural := 32;                --address length
      m : natural := 32                 --data length
      );
    port (
      arf1    : in  std_logic_vector(n-1 downto 0);  --addresses of registers for the current operation 
      arf2    : in  std_logic_vector(n-1 downto 0);
      aluar   : in  std_logic_vector(n-1 downto 0);  --address of reg in output to the alu
      exear   : in  std_logic_vector(n-1 downto 0);  --adrress of reg in execute stage
      memar   : in  std_logic_vector(n-1 downto 0);  --adrress of reg in memory stage
      alue    : in  std_logic;
      exe     : in  std_logic;
      meme    : in  std_logic;
      alud    : in  std_logic_vector(m-1 downto 0);  -- data coming from output of alu
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
      n : natural := 1
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
      n : natural := 32
      );
    port (
      in_1   : in  std_logic_vector(n-1 downto 0);
      in_2   : in  std_logic_vector(n-1 downto 0);
      op_sel : in  alu_array;
      -- outputs
      out_s  : out std_logic_vector(n-1 downto 0)
      );
  end component;

  component mask is
    generic (
      n : natural := 32
      );
    port (
      a           : in  std_logic_vector(n-1 downto 0);
      sel         : in  std_logic;
      sign_extend : in  std_logic;
      b           : out std_logic_vector(n-1 downto 0)
      );
  end component;

  signal pcin, npcin, npcout, pcregout, mux31win, addrd1, addrd2    : std_logic_vector(n_bit-1 downto 0);
  signal irout                                                      : std_logic_vector(n_bit-1 downto 0);
  signal om5, ain, bin, immin, aout, bout, immout, fuo1, fuo2, fuo3 : std_logic_vector(n_bit-1 downto 0);
  signal fuo4, om1, om2, om3, om4, oalu, r1out, lmdout, ompc        : std_logic_vector(n_bit-1 downto 0);
  signal omopc, wri, msk2out, aw1o, aw2o, aw3o                      : std_logic_vector(n_bit-1 downto 0);
  signal fum                                                        : std_logic_vector(1 downto 0);

begin

  --fetch stage
  pc : register_n generic map(n => n_bit)
    port map(pcin, clk, rst, '0', pce, pcout);
  inrreg : register_n generic map(n => n_bit)
    port map(instr, clk, rst, '0', ire, irout);
  add : rca_n generic map(n => n_bit)
    port map(pcout, aconst, '0', npcin, open);
  npc : register_n generic map(n => n_bit)
    port map(npcin, clk, rst, '0', npce, npcout);

  --decode stage
  mux31win(n_bit-1 downto 5) <= (others => '0');
  mux31win(4 downto 0) <= irout(n_bit-7 downto n_bit-11);
  addrd1(n_bit-1 downto 5) <= (others => '0');
  addrd1(4 downto 0) <= irout(n_bit-12 downto n_bit-16);
  addrd2(n_bit-1 downto 5) <= (others => '0');
  addrd2(4 downto 0) <= irout(n_bit-17 downto n_bit-21);
  
  
  mux31w : mux_n_2_1 generic map(n => n_bit)
    port map(mux31win, raddrconst, mws, wri);
  reg_file : register_file generic map(width_add => reg_addr_size, width_data => n_bit)
    port map(clk, rst, rfe, rfr1, rfr2, rfw, aw3o, addrd1, addrd2, om5, ain, bin);
  sign_extend : sign_extender generic map(n_in => imm_val_size, n_out => n_bit)
    port map(irout(n_bit-17 downto 0), see, immin);
  branch : branch_unit generic map(n1 => n_bit)
    port map(immin, om1, npcout, be, bnez, jr, jmp, pcin);
  forwinst : forwarding_unit generic map(n => reg_addr_size, m => n_bit)
    port map(addrd1, addrd2, aw1o, aw2o, aw3o, aw1e, aw2e, aw3e, oalu, aluout, om4, clk, fum, fuo1, fuo2);
  mux1 : mux_n_2_1 generic map(n => n_bit)
    port map(ain, fuo1, fum(0), om1);
  mux2 : mux_n_2_1 generic map(n => n_bit)
    port map(bin, fuo2, fum(1), om2);
  areg : register_n generic map(n => n_bit)
    port map(om1, clk, rst, '0', ae, aout);
  breg : register_n generic map(n => n_bit)
    port map(om2, clk, rst, '0', ben, bout);
  immreg : register_n generic map(n => n_bit)
    port map(immin, clk, rst, '0', ie, immout);
  pcpreg : register_n generic map(n => n_bit)
    port map(pcout, clk, rst, '0', pre, pcregout);
  add_w1 : register_n generic map(n => n_bit)
    port map(wri, clk, rst, '0', aw1e, aw1o);

  --execute stage
  mux3 : mux_n_2_1 generic map(n => n_bit)
    port map(bout, immout, m3s, om3);
  muxpc : mux_n_2_1 generic map(n => n_bit)
    port map(aout, pcregout, mps, ompc);
  muxoffpc : mux_n_2_1 generic map(n => n_bit)
    port map(om3, offconst, mss, omopc);
  me : register_n generic map(n => n_bit)
    port map(bout, clk, rst, '0', mee, meout);
  aluinst : alu generic map(n => n_bit)
    port map(ompc, omopc, alusel, oalu);
  aluoutinst : register_n generic map(n => n_bit)
    port map(oalu, clk, rst, '0', aoe, aluout);
  add_w2 : register_n generic map(n => n_bit)
    port map(aw1o, clk, rst, '0', aw2e, aw2o);

  --memory stage
  reg1inst : register_n generic map(n => n_bit)
    port map(aluout, clk, rst, '0', r1e, r1out);
  mask02 : mask generic map(n => n_bit)
    port map(lmdin, msksel2, msksigned2, msk2out);
  lmd : register_n generic map(n => n_bit)
    port map(msk2out, clk, rst, '0', lmde, lmdout);
  mux4 : mux_n_2_1 generic map(n => n_bit)
    port map(r1out, lmdout, m4s, om4);
  add_w3 : register_n generic map(n => n_bit)
    port map(aw2o, clk, rst, '0', aw3e, aw3o);

  --write back stage
  mux5 : mux_n_2_1 generic map(n => n_bit)
    port map(lmdout, r1out, m5s, om5);

end architecture;
