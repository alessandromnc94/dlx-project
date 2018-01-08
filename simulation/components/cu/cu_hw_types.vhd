library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.alu_types.all;

package cu_hw_types is

-- control unit std_logic_vector sizes
  constant opcode_size   : integer := 6;   -- opcode field size
  constant func_size     : integer := 11;  -- func field size 
  constant cw_array_size : integer := 29;  -- cw size

-- change the values of the instructions coding as you want, depending also on the type of control unit choosen
  subtype cw_array is std_logic_vector(cw_array_size-1 downto 0);
  type cw_mem_matrix is array (integer range 0 to 2**opcode_size-1) of cw_array;
  subtype opcode_array is std_logic_vector(opcode_size-1 downto 0);
  subtype func_array is std_logic_vector(func_size-1 downto 0);

-- define the control word for nop instruction
  constant cw_nop : cw_array := (others => '0');

-- r-type instruction -> opcode field
  constant rtype       : integer := 16#01#;  -- for any register-to-register operation
---- r-type instruction -> func field
--
  constant rtype_sll   : integer := 16#04#;
  constant rtype_srl   : integer := 16#06#;
  constant rtype_sra   : integer := 16#07#;
  constant rtype_add   : integer := 16#20#;
  constant rtype_addu  : integer := 16#21#;
  constant rtype_sub   : integer := 16#22#;
  constant rtype_subu  : integer := 16#23#;
  constant rtype_and   : integer := 16#24#;
  constant rtype_or    : integer := 16#25#;
  constant rtype_xor   : integer := 16#26#;
  constant rtype_seq   : integer := 16#28#;
  constant rtype_sne   : integer := 16#29#;
  constant rtype_slt   : integer := 16#2a#;
  constant rtype_sgt   : integer := 16#2b#;
  constant rtype_sle   : integer := 16#2c#;
  constant rtype_sge   : integer := 16#2d#;
  constant rtype_sltu  : integer := 16#3a#;
  constant rtype_sgtu  : integer := 16#3b#;
  constant rtype_sleu  : integer := 16#3c#;
  constant rtype_sgeu  : integer := 16#3d#;
--  constant rtype_mul   : integer   := 16#20#; -- is floating point ?
-- i-type instruction -> opcode field
  constant nop         : integer := 16#00#;
  constant itype_addi  : integer := 16#08#;
  constant itype_addui : integer := 16#09#;
  constant itype_subui : integer := 16#0a#;
  constant itype_subi  : integer := 16#0b#;
  constant itype_andi  : integer := 16#0c#;
  constant itype_ori   : integer := 16#0d#;
  constant itype_xori  : integer := 16#0e#;
  constant itype_slli  : integer := 16#14#;
  constant itype_srli  : integer := 16#16#;
  constant itype_srai  : integer := 16#17#;
  constant itype_seqi  : integer := 16#18#;
  constant itype_snei  : integer := 16#19#;
  constant itype_sgti  : integer := 16#1a#;
  constant itype_sgtui : integer := 16#1b#;
  constant itype_sgei  : integer := 16#1c#;
  constant itype_sgeui : integer := 16#1d#;
  constant itype_slti  : integer := 16#3a#;
  constant itype_sltui : integer := 16#3b#;
  constant itype_slei  : integer := 16#3c#;
  constant itype_sleui : integer := 16#3d#;
  -- constant itype_mul   : integer := 16#20; -- as before
-- jump instruction -> opcode field
  constant j           : integer := 16#02#;
  constant jal         : integer := 16#03#;
  constant jr          : integer := 16#12#;
  constant jalr        : integer := 16#13#;
-- branch instruction -> opcode field
  constant beqz        : integer := 16#04#;
  constant bnez        : integer := 16#05#;
-- load instruction -> opcode field
  constant lhi         : integer := 16#0f#;
  constant lb          : integer := 16#20#;
  constant lw          : integer := 16#23#;
  constant lbu         : integer := 16#24#;
  constant lhu         : integer := 16#25#;
-- store instruction -> opcode field
  constant sb          : integer := 16#28#;
  constant sw          : integer := 16#2b#;

end package;
