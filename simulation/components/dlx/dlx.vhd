library ieee;
use ieee.std_logic_1164.all;

use work.alu_types.all;
use work.cu_hw_types.all;
use work.my_const.all;

entity dlx is
  port (
    rst : in std_logic;
    clk : in std_logic
    );
end entity dlx;

-- structural architecture
architecture structural of dlx is


  component cu_hw is
    port (
      -- cw
      -- first pipe stage outputs: fetch
      -- pc_en              : out std_logic;
      -- npc_en             : out std_logic;
      -- ir_en              : out std_logic;
      --
      -- second pipe stage outputs: decode
      -- reg_file_en        : out std_logic;
      reg_file_read_1    : out std_logic;  -- enable read from out_1 & store in reg a
      reg_file_read_2    : out std_logic;  -- same as before for out 2 & reg b
      reg_imm_en         : out std_logic;  -- load data from immediate
      imm_sign_ext_en    : out std_logic;
      branch_en          : out std_logic;
      branch_nez         : out std_logic;
      jump_en            : out std_logic;
      jr_en              : out std_logic;  -- enable also pc_delay and store_in_r_31
      jl_en              : out std_logic;
      -- check
      forwarding_in_1_en : out std_logic;  -- enable forwarding 1
      forwarding_in_2_en : out std_logic;  -- enable forwarding 2
      --
      -- third pipe stage outputs: execute
      -- alu selector
      alu_op_sel         : out alu_array;
      -- cw_mem signals
      alu_pc_sel         : out std_logic;  -- put pc on alu in_1 && "+8" on alu in_2 
      alu_get_imm_in     : out std_logic;
      alu_out_reg_en     : out std_logic;
      b_bypass_en        : out std_logic;
      add_w_pipe_2_en    : out std_logic;
      --
      -- fourth pipe stage outputs: memory
      -- cw_mem signals
      alu_bypass_en      : out std_logic;
      dram_read_en       : out std_logic;
      dram_write_en      : out std_logic;
      dram_write_byte    : out std_logic;
      mask_2_signed      : out std_logic;
      mask_2_en          : out std_logic;
      add_w_pipe_3_en    : out std_logic;
      --
      -- fifth pipe stage outputs: write back
      -- cw
      mem_out_sel        : out std_logic;
      reg_file_write     : out std_logic;
      -- inputs
      branch_taken       : in  std_logic;
      opcode             : in  opcode_array;
      func               : in  func_array;
      clk                : in  std_logic;
      rst                : in  std_logic
      );
  end component;

  component datapath is
    generic (
      imm_val_size  : integer := 16;
      j_val_size    : integer := 26; --NOT USED
      reg_addr_size : integer := 5
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
      be         : in     std_logic;      --beqz/!bnez
      jr         : in     std_logic;      --jr/!nojr
      jmp        : in     std_logic;      --jmp/!nojmp
      --sign extender and registers signals
      see        : in     std_logic;      --sign extender enable
      ae         : in     std_logic;      --a register enable
      ben        : in     std_logic;      --b register enable
      ie         : in     std_logic;      --immediate register enable
      pre        : in     std_logic;      --pc pipeline reg enable
      aw1e       : in     std_logic;      --Address write1 reg enable
      -- 3rd stage
      --alu signals
      alusel     : in     alu_array;      --alu operation selectors
      --muxes and registers signals
      m3s        : in     std_logic;      --mux 3 selector
      aoe        : in     std_logic;      --alu_out registes enable
      mee        : in     std_logic;      --me register enable
      mps        : in     std_logic;      --mux from pc selector
      mss        : in     std_logic;      --mux to sum 8 to pc selector
      aw2e       : in     std_logic;      --Address write2 reg enable
      -- 4th stage
      r1e        : in     std_logic;      --register 1 enable
      msksel2    : in     std_logic;      --selector for load byte mask
      msksigned2 : in     std_logic;      -- mask is signed if enabled
      lmde       : in     std_logic;      --lmd register enable
      m4s        : in     std_logic;      --mux 5 selector
      aw3e       : in     std_logic;      --Address write3 reg enable
      -- 5th stage
      m5s        : in     std_logic;      --mux 5 selector
      mws        : in     std_logic;      --write addr mux selector(mux is physically in decode stage, but driven in wb stage)
      -- outputs
      pcout      : buffer std_logic_vector(n_bit-1 downto 0);  --program counter output per le dimensioni puoi cambiarlo, la iram puo' essere diversa dalla dram
      aluout     : buffer std_logic_vector(n_bit-1 downto 0);  --alu outpud data
      meout      : out    std_logic_vector(n_bit-1 downto 0)  --me register data out
      );
  end component;

  component iram is
    generic (
      ram_depth  : integer;
      data_width : integer;
      addr_size  : integer
      );
    port (
      rst  : in  std_logic;
      addr : in  std_logic_vector(addr_size - 1 downto 0);
      dout : out std_logic_vector(4*data_width - 1 downto 0)
      );

  end component;

  component dram is
    generic (
      ram_depth  : integer;
      data_width : integer;
      addr_size  : integer
      );
    port (
      rst               : in  std_logic;
      addr_r            : in  std_logic_vector(addr_size - 1 downto 0);
      addr_w            : in  std_logic_vector(addr_size - 1 downto 0);
      read_enable       : in  std_logic;
      write_enable      : in  std_logic;
      write_single_cell : in  std_logic;
      din               : in  std_logic_vector(4*data_width - 1 downto 0);
      dout              : out std_logic_vector(4*data_width - 1 downto 0)
      );

  end component;

  -- iram
  constant iram_addr_size       : integer := 32;
  constant iram_data_depth      : integer = 2**iram_addr_size;
  constant iram_data_cell_width : integer := 8;
  signal iram_addr              : std_logic_vector(iram_addr_size-1 downto 0);
  signal iram_dout              : std_logic_vector(4*iram_data_cell_width-1 downto 0);
  
  -- dram
  constant dram_addr_size       : integer := 32;
  constant dram_data_depth      : integer = 2**dram_addr_size;
  constant dram_data_cell_width : integer := 8;
  signal dram_addr_r            : std_logic_vector(dram_addr_size-1 downto 0);
  signal dram_addr_w            : std_logic_vector(dram_addr_size-1 downto 0);
  signal dram_din               : std_logic_vector(4*dram_data_cell_width-1 downto 0);
  signal dram_dout              : std_logic_vector(4*dram_data_cell_width-1 downto 0);
  signal dram_read_enable       : std_logic;
  signal dram_write_enable      : std_logic;
  signal dram_write_single_cell : std_logic;

-- datapath
-- TODO
  constant imm_val_size         : integer := 16;
  constant j_val_size           : integer := 26; --NOT USED
  constant reg_addr_size        : integer := 5;

  signal datapath_iram_addr   : std_logic_vector(iram_addr_size-1 downto 0);
  signal datapath_iram_dout   : std_logic_vector(4*iram_data_cell_width-1 downto 0);
  signal datapath_dram_addr_r : std_logic_vector(dram_addr_size-1 downto 0);
  signal datapath_dram_addr_w : std_logic_vector(dram_addr_size-1 downto 0);
  signal datapath_dram_din    : std_logic_vector(4*dram_data_cell_width-1 downto 0);
  signal datapath_dram_dout   : std_logic_vector(4*dram_data_cell_width-1 downto 0);

  -- check which signals are useless (they are cloned by cu_hw port map)
  signal datapath_reg_file_read_1    : std_logic;
  signal datapath_reg_file_read_2    : std_logic;
  signal datapath_reg_imm_en         : std_logic;
  signal datapath_imm_sign_ext_en    : std_logic;
  signal datapath_branch_en          : std_logic;
  signal datapath_branch_nez         : std_logic;
  signal datapath_jump_en            : std_logic;
  signal datapath_jr_en              : std_logic;
  signal datapath_jl_en              : std_logic;
  signal datapath_forwarding_in_1_en : std_logic;
  signal datapath_forwarding_in_2_en : std_logic;
  signal datapath_alu_op_sel         : alu_array;
  signal datapath_alu_pc_sel         : std_logic;
  signal datapath_alu_get_imm_in     : std_logic;
  signal datapath_alu_out_reg_en     : std_logic;
  signal datapath_b_bypass_en        : std_logic;
  signal datapath_add_w_pipe_2_en    : std_logic;
  signal datapath_alu_bypass_en      : std_logic;
  signal datapath_dram_read_en       : std_logic;
  signal datapath_dram_write_en      : std_logic;
  signal datapath_dram_write_byte    : std_logic;
  signal datapath_mask_2_signed      : std_logic;
  signal datapath_mask_2_en          : std_logic;
  signal datapath_add_w_pipe_3_en    : std_logic;
  signal datapath_mem_out_sel        : std_logic;
  signal datapath_reg_file_write     : std_logic;
  signal datapath_branch_taken       : std_logic;
  signal datapath_opcode             : opcode;
  signal datapath_func               : func_code;
  
  -- add missing signals

-- cu_hw
  signal cu_hw_reg_file_read_1    : std_logic;
  signal cu_hw_reg_file_read_2    : std_logic;
  signal cu_hw_reg_imm_en         : std_logic;
  signal cu_hw_imm_sign_ext_en    : std_logic;
  signal cu_hw_branch_en          : std_logic;
  signal cu_hw_branch_nez         : std_logic;
  signal cu_hw_jump_en            : std_logic;
  signal cu_hw_jr_en              : std_logic;
  signal cu_hw_jl_en              : std_logic;
  signal cu_hw_forwarding_in_1_en : std_logic;
  signal cu_hw_forwarding_in_2_en : std_logic;
  signal cu_hw_alu_op_sel         : alu_array;
  signal cu_hw_alu_pc_sel         : std_logic;
  signal cu_hw_alu_get_imm_in     : std_logic;
  signal cu_hw_alu_out_reg_en     : std_logic;
  signal cu_hw_b_bypass_en        : std_logic;
  signal cu_hw_add_w_pipe_2_en    : std_logic;
  signal cu_hw_alu_bypass_en      : std_logic;
  signal cu_hw_dram_read_en       : std_logic;
  signal cu_hw_dram_write_en      : std_logic;
  signal cu_hw_dram_write_byte    : std_logic;
  signal cu_hw_mask_2_signed      : std_logic;
  signal cu_hw_mask_2_en          : std_logic;
  signal cu_hw_add_w_pipe_3_en    : std_logic;
  signal cu_hw_mem_out_sel        : std_logic;
  signal cu_hw_reg_file_write     : std_logic;
  signal cu_hw_branch_taken       : std_logic;
  signal cu_hw_opcode             : opcode;
  signal cu_hw_func               : func_code;


begin  -- architecture structural

-- component instancing
  dram0 : dram generic map(
    ram_depth  => dram_depth;
    data_width => dram_data_cell_width;
    addr_size  => dram_addr_size
    ) port map(
      rst               => rst;
      addr_r            => dram_addr_r;
      addr_w            => dram_addr_w;
      read_enable       => dram_read_enable;
      write_enable      => dram_write_enable;
      write_single_cell => dram_write_single_cell;
      din               => dram_din;
      dout              => dram_dout
      );

  iram0 : iram generic map(
    ram_depth  => iram_depth;
    data_width => iram_data_cell_width;
    addr_size  => iram_addr_size
    ) port map(
      rst  => rst;
      addr => iram_addr;
      dout => iram_dout
      );

  cu_hw0 : cu_hw port map(
    reg_file_read_1    => cu_hw_reg_file_read_1;
    reg_file_read_2    => cu_hw_reg_file_read_2;
    reg_imm_en         => cu_hw_reg_imm_en;
    imm_sign_ext_en    => cu_hw_imm_sign_ext_en;
    branch_en          => cu_hw_branch_en;
    branch_nez         => cu_hw_branch_nez;
    jump_en            => cu_hw_jump_en;
    jr_en              => cu_hw_jr_en;
    jl_en              => cu_hw_jl_en;
    forwarding_in_1_en => cu_hw_forwarding_in_1_en;
    forwarding_in_2_en => cu_hw_forwarding_in_2_en;
    alu_op_sel         => cu_hw_alu_op_sel;
    alu_pc_sel         => cu_hw_alu_pc_sel;
    alu_get_imm_in     => cu_hw_alu_get_imm_in;
    alu_out_reg_en     => cu_hw_alu_out_reg_en;
    b_bypass_en        => cu_hw_b_bypass_en;
    add_w_pipe_2_en    => cu_hw_add_w_pipe_2_en;
    alu_bypass_en      => cu_hw_alu_bypass_en;
    dram_read_en       => cu_hw_dram_read_en;
    dram_write_en      => cu_hw_dram_write_en;
    dram_write_byte    => cu_hw_dram_write_byte;
    mask_2_signed      => cu_hw_mask_2_signed;
    mask_2_en          => cu_hw_mask_2_en;
    add_w_pipe_3_en    => cu_hw_add_w_pipe_3_en;
    mem_out_sel        => cu_hw_mem_out_sel;
    reg_file_write     => cu_hw_reg_file_write;
    branch_taken       => cu_hw_branch_taken;
    opcode             => cu_hw_opcode;
    func               => cu_hw_func;
    clk                => clk;
    rst                => rst
    );

    -- TODO
  datapath0 : datapath generic map(
           imm_val_size =>  imm_val_size;
           j_val_size =>    j_val_size;
           reg_addr_size => reg_addr_size
           ) port map(
           instr      =>  iram_dout;
           lmdin      =>  dram_out;
           clk        =>  clk;
           rst        =>  rst;
           pce        =>
           npce       =>
           ire        =>
           rfe        =>
           rfr1       =>  cu_hw_reg_file_read_1;
           rfr2       =>  cu_hw_reg_file_read_2;
           rfw        =>  cu_hw_reg_file_write;
           be         =>  cu_hw_branch_en;
           jr         =>  cu_hw_jr_en;
           jmp        =>  cu_hw_jump_en;
           see        =>  cu_hw_imm_sign_ext_en;
           ae         =>
           ben        =>
           ie         =>
           pre        =>
           aw1e       =>
           alusel     =>  cu_hw_alu_op_sel;
           m3s        =>
           aoe        =>  cu_hw_alu_out_reg_en;
           mee        =>
           mps        =>
           mss        =>
           aw2e       =>  cu_hw_add_w_pipe_2_en;
           r1e        =>
           msksel2    =>  cu_hw_mask_2_en;;
           msksigned2 =>  cu_hw_mask_2_signed;
           lmde       =>
           m4s        =>
           aw3e       =>  cu_hw_add_w_pipe_3_en;
           m5s        =>
           mws        =>
           pcout      => iram_addr;
           aluout     => dram_addr_w;
           meout      => dram_din
           );

  -- signal redirects
  -- datapath <--> iram
  iram_addr                   <= datapath_iram_addr;
  datapath_iram_dout          <= iram_dout;
  -- datapath <--> dram
  dram_addr_r                 <= datapath_dram_addr_r;
  dram_addr_w                 <= datapath_dram_addr_w;
  dram_din                    <= datapath_dram_din;
  datapath_dram_dout          <= dram_dout;
  dram_read_enable            <= datapath_dram_read_enable;
  dram_write_enable           <= datapath_dram_write_enable;
  dram_write_single_cell      <= datapath_dram_write_single_cell;
  -- cu_hw <--> datapath 
  datapath_reg_read_1         <= cu_hw_reg_read_1;
  datapath_reg_read_2         <= cu_hw_reg_read_2;
  datapath_reg_imm_en         <= cu_hw_reg_imm_en;
  datapath_reg_file_read_1    <= cu_hw_reg_file_read_1;
  datapath_reg_file_read_2    <= cu_hw_reg_file_read_2;
  datapath_reg_imm_en         <= cu_hw_reg_imm_en;
  datapath_imm_sign_ext_en    <= cu_hw_imm_sign_ext_en;
  datapath_branch_en          <= cu_hw_branch_en;
  datapath_branch_nez         <= cu_hw_branch_nez;
  datapath_jump_en            <= cu_hw_jump_en;
  datapath_jr_en              <= cu_hw_jr_en;
  datapath_jl_en              <= cu_hw_jl_en;
  datapath_forwarding_in_1_en <= cu_hw_forwarding_in_1_en;
  datapath_forwarding_in_2_en <= cu_hw_forwarding_in_2_en;
  datapath_alu_op_sel         <= cu_hw_alu_op_sel;
  datapath_alu_pc_sel         <= cu_hw_alu_pc_sel;
  datapath_alu_get_imm_in     <= cu_hw_alu_get_imm_in;
  datapath_alu_out_reg_en     <= cu_hw_alu_out_reg_en;
  datapath_b_bypass_en        <= cu_hw_b_bypass_en;
  datapath_add_w_pipe_2_en    <= cu_hw_add_w_pipe_2_en;
  datapath_alu_bypass_en      <= cu_hw_alu_bypass_en;
  datapath_dram_read_en       <= cu_hw_dram_read_en;
  datapath_dram_write_en      <= cu_hw_dram_write_en;
  datapath_dram_write_byte    <= cu_hw_dram_write_byte;
  datapath_mask_2_signed      <= cu_hw_mask_2_signed;
  datapath_mask_2_en          <= cu_hw_mask_2_en;
  datapath_add_w_pipe_3_en    <= cu_hw_add_w_pipe_3_en;
  datapath_mem_out_sel        <= cu_hw_mem_out_sel;
  datapath_reg_file_write     <= cu_hw_reg_file_write;
  cu_hw_branch_taken          <= datapath_branch_taken;
  cu_hw_opcode                <= datapath_opcode;
  cu_hw_func                  <= datapath_func;
end architecture structural;
