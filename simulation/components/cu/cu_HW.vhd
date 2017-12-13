-- cose da fare:
-- + inserire segnali aggiunti
-- + estendere case per la alu

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alu_types.all;
use work.cu_hw_types.all;
-- use work.cu_hw_functions.all;

entity cu_hw is
  generic (
    reg_addr_size : natural := 32
    );
  port (
    -- cw
    -- first pipe stage outputs: fetch
    pc_reset           : out std_logic;
    pc_en              : out std_logic;
    npc_reset          : out std_logic;
    npc_en             : out std_logic;
    ir_reset           : out std_logic;
    ir_en              : out std_logic;
    -- second pipe stage outputs: decode
    reg_file_reset     : out std_logic;
    reg_file_en        : out std_logic;
    reg_file_out_1     : out std_logic;
    reg_file_out_2     : out std_logic;
    pc_to_in_1         : out std_logic;
    pc_offset_to_in_2  : out std_logic;
    pc_store_reg_31    : out std_logic;
    branch_en          : out std_logic;
    -- eq_cond          : out std_logic;
    jump_en            : out std_logic;
    jump_reg           : out std_logic;
    sign_ext_en        : out std_logic;
    reg_out_1_reset    : out std_logic;
    reg_out_1_en       : out std_logic;
    reg_out_2_reset    : out std_logic;
    reg_out_2_en       : out std_logic;
    reg_imm_reset      : out std_logic;
    reg_imm_en         : out std_logic;
    -- third pipe stage outputs: execute
    alu_sel            : out alu_array;
    alu_get_imm_in     : out std_logic;
    alu_for_in_1_en    : out std_logic;
    alu_for_in_2_en    : out std_logic;
    alu_mem_reg_reset  : out std_logic;
    alu_mem_reg_en     : out std_logic;
    alu_reg_1_for_add  : out std_logic_vector(reg_addr_size-1 downto 0);
    alu_reg_2_for_add  : out std_logic_vector(reg_addr_size-1 downto 0);
    bypass_imm         : out std_logic;
    alu_out_reg_reset  : out std_logic;
    alu_out_reg_en     : out std_logic;
    alu_mem_masksel    : out std_logic_vector(1 downto 0);
    alu_mem_masksigned : out std_logic;
    -- fourth pipe stage outputs: memory
    dram_write_en      : out std_logic;
    dram_read_en       : out std_logic;
    lmd_reg_reset      : out std_logic;
    lmd_reg_en         : out std_logic;
    alu_out_for        : out std_logic;
    lmd_masksel        : out std_logic_vector(1 downto 0);
    lmd_masksigned     : out std_logic;
    -- fifth pipe stage outputs: write back
    rf_latch_en        : out std_logic;
    wb_mux_sel         : out std_logic;
    wb_en              : out std_logic;
    -- inputs
    branch_taken       : in  std_logic;
    opcode             : in  opcode_array;
    func               : in  func_array;
    clk                : in  std_logic;
    rst                : in  std_logic
    );
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of cu_hw is

  -- lut for control word
  signal cw_mem : cw_mem_matrix := (
    nop         => cw_nop,              -- nop
    rtype       => cw_nop,              -- rtype
    itype_addi  => cw_nop,
    itype_addui => cw_nop,
    itype_subui => cw_nop,
    itype_subi  => cw_nop,
    itype_andi  => cw_nop,
    itype_ori   => cw_nop,
    itype_xori  => cw_nop,
    itype_slli  => cw_nop,
    itype_srli  => cw_nop,
    itype_srai  => cw_nop,
    itype_seqi  => cw_nop,
    itype_snei  => cw_nop,
    itype_sgti  => cw_nop,
    itype_sgtui => cw_nop,
    itype_sgei  => cw_nop,
    itype_sgeui => cw_nop,
    itype_slti  => cw_nop,
    itype_sltui => cw_nop,
    itype_slei  => cw_nop,
    itype_sleui => cw_nop,
    j           => cw_nop,
    jal         => cw_nop,
    jr          => cw_nop,
    jalr        => cw_nop,
    beqz        => cw_nop,
    bnez        => cw_nop,
    lhi         => cw_nop,
    lb          => cw_nop,
    lw          => cw_nop,
    lbu         => cw_nop,
    lhu         => cw_nop,
    sb          => cw_nop,
    sw          => cw_nop,
    others      => cw_nop               -- instructions not defined
    );
  -- control word from lut
  signal cw               : cw_array                                    := (others => '0');
  -- split cw in stages
  constant cw1_array_size : integer                                     := cw_array_size;
  signal cw1              : cw_array                                    := (others => '0');
  constant cw2_array_size : integer                                     := cw1_array_size-6;
  signal cw2              : std_logic_vector(cw2_array_size-1 downto 0) := (others => '0');
  constant cw3_array_size : integer                                     := cw2_array_size-10;
  signal cw3              : std_logic_vector(cw3_array_size-1 downto 0) := (others => '0');
  constant cw4_array_size : integer                                     := cw3_array_size-10;
  signal cw4              : std_logic_vector(cw4_array_size-1 downto 0) := (others => '0');
  constant cw5_array_size : integer                                     := cw4_array_size-7;
  signal cw5              : std_logic_vector(cw5_array_size-1 downto 0) := (others => '0');
  -- delay alu control word
  signal alu1, alu2, alu3 : alu_array                                   := (others => '0');
  -- signals to manage cw words
  signal alu              : alu_array                                   := (others => '0');  -- alu code from func

begin
  -- get output from luts
  cw <= cw_mem(conv_integer(unsigned(opcode)));

-- todo
  -- first pipe stage outputs
  pc_reset           <= cw1(cw1_array_size-1);
  pc_en              <= cw1(cw1_array_size-2);
  npc_reset          <= cw1(cw1_array_size-3);
  npc_en             <= cw1(cw1_array_size-4);
  ir_reset           <= cw1(cw1_array_size-5);
  ir_en              <= cw1(cw1_array_size-6);
  -- second pipe stage outputs
  reg_file_reset     <= cw2(cw2_array_size-1);
  reg_file_en        <= cw2(cw2_array_size-2);
  reg_file_out_1     <= cw2(cw2_array_size-3);
  reg_file_out_2     <= cw2(cw2_array_size-4);
  pc_to_in_1         <= cw2(cw2_array_size-5);
  pc_offset_to_in_2  <= cw2(cw2_array_size-6);
  pc_store_reg_31    <= cw2(cw2_array_size-7);
  branch_en          <= cw2(cw2_array_size-8);
  jump_en            <= cw2(cw2_array_size-9);
  jump_reg           <= cw2(cw2_array_size-10);
  -- third pipe stage outputs
  alu_sel            <= alu3;
  alu_get_imm_in     <= '0';
  alu_for_in_1_en    <= cw3(cw3_array_size-1);
  alu_for_in_2_en    <= cw3(cw3_array_size-2);
  alu_mem_reg_reset  <= cw3(cw3_array_size-3);
  alu_mem_reg_en     <= cw3(cw3_array_size-4);
  --alu_reg_1_for_add <= cw3(cw3_array_size-5);
  --alu_reg_2_for_add <= cw3(cw3_array_size-6);
  bypass_imm         <= cw3(cw3_array_size-7);
  alu_mem_masksel    <= cw3(cw3_array_size-8 downto cw3_array_size-9);
  alu_mem_masksigned <= cw3(cw3_array_size-10);
  -- fourth pipe stage outputs
  dram_write_en      <= cw4(cw4_array_size-1);
  dram_read_en       <= cw4(cw4_array_size-2);
  lmd_reg_reset      <= cw4(cw4_array_size-3);
  lmd_reg_en         <= cw4(cw4_array_size-4);
  lmd_masksel        <= cw4(cw4_array_size-5 downto cw4_array_size-6);
  lmd_masksigned     <= cw4(cw4_array_size-7);
  -- fifth pipe stage outputs
  rf_latch_en        <= cw5(cw5_array_size-1);
  wb_mux_sel         <= cw5(cw5_array_size-2);
  wb_en              <= cw5(cw5_array_size-3);

  -- process to pipeline control words
  cw_pipe : process (clk, rst)
  begin
    if rst = '0' then                   -- asynchronous reset (active low)
      cw1  <= (others => '0');
      cw2  <= (others => '0');
      cw3  <= (others => '0');
      cw4  <= (others => '0');
      cw5  <= (others => '0');
      alu1 <= (others => '0');
      alu2 <= (others => '0');
      alu3 <= (others => '0');
    elsif rising_edge(clk) then         -- rising clock edge
      if branch_taken = '0' then
        cw1  <= cw;
        alu1 <= alu;
        cw2  <= cw1(cw2_array_size-1 downto 0);
        alu2 <= alu1;
        cw3  <= cw2(cw3_array_size-1 downto 0);
        alu3 <= alu2;
      else
        cw1  <= cw_nop;
        alu1 <= alu_nop;
        cw1  <= cw_nop;
        alu2 <= alu_nop;
        cw2  <= cw_nop(cw2_array_size-1 downto 0);
        alu3 <= alu_nop;
        cw3  <= cw_nop(cw3_array_size-1 downto 0);
      end if;
      cw4 <= cw3(cw4_array_size-1 downto 0);
      cw5 <= cw4(cw5_array_size-1 downto 0);
    end if;
  end process;

-- process to get alu control word
  alu_get_code : process (opcode, func)
  begin
    case conv_integer(unsigned(opcode)) is
      when rtype =>
        case conv_integer(unsigned(func)) is
          when rtype_add | rtype_addu => alu <= alu_add;
          when rtype_sub | rtype_subu => alu <= alu_sub;
          --when rtype_mul              => alu <= alu_mul;
          when rtype_sll              => alu <= alu_sll;
          when rtype_srl              => alu <= alu_srl;
          when rtype_sra              => alu <= alu_sra;
          when rtype_slt              => alu <= alu_slt;
          when rtype_sltu             => alu <= alu_sltu;
          when rtype_sle              => alu <= alu_sle;
          when rtype_sleu             => alu <= alu_sleu;
          when rtype_sgt              => alu <= alu_sgt;
          when rtype_sgtu             => alu <= alu_sgtu;
          when rtype_sge              => alu <= alu_sge;
          when rtype_sgeu             => alu <= alu_sgeu;
          when rtype_sne              => alu <= alu_sne;
          when rtype_seq              => alu <= alu_seq;
          when rtype_and              => alu <= alu_and;
          when rtype_or               => alu <= alu_or;
          when rtype_xor              => alu <= alu_xor;
          when others                 => alu <= alu_nop;
        end case;
      -- itype
      when itype_addi | itype_addui => alu <= alu_add;
      when itype_subi | itype_subui => alu <= alu_sub;
      --     when itype_muli               => alu <= alu_mul;
      when itype_slli               => alu <= alu_sll;
      when itype_srli               => alu <= alu_srl;
      when itype_srai               => alu <= alu_sra;
      when itype_slti               => alu <= alu_slt;
      when itype_sltui              => alu <= alu_sltu;
      when itype_slei               => alu <= alu_sle;
      when itype_sleui              => alu <= alu_sleu;
      when itype_sgti               => alu <= alu_sgt;
      when itype_sgtui              => alu <= alu_sgtu;
      when itype_sgei               => alu <= alu_sge;
      when itype_sgeui              => alu <= alu_sgeu;
      when itype_snei               => alu <= alu_sne;
      when itype_seqi               => alu <= alu_seq;
      when itype_andi               => alu <= alu_and;
      when itype_ori                => alu <= alu_or;
      when itype_xori               => alu <= alu_xor;
      -- jump
      when j | jal                  => alu <= alu_add;
      when jr | jalr                => alu <= alu_nop;
      -- branch
      when beqz                     => alu <= alu_nop;
      when bnez                     => alu <= alu_nop;
      -- store
      when sb | sw                  => alu <= alu_add;
      -- load
      when lb | lbu                 => alu <= alu_add;
      when lhi | lhu                => alu <= alu_add;
      when lw                       => alu <= alu_add;
      when others                   => alu <= alu_nop;
    end case;
  end process;
end architecture;

-- configurations

-- static behavioral configuration
configuration cfg_cu_hw_behavioral of cu_hw is
  for behavioral
  end for;
end configuration;
