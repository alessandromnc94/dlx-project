library ieee;
use ieee.std_logic_1164.all;

use work.alu_types.all;

package cu_hw_types is

-- control unit std_logic_vector sizes
  constant opcode_size   : integer := 6;   -- opcode field size
  constant func_size     : integer := 11;  -- func field size 
  constant cw_array_size : integer := 51;  -- cw size

-- change the values of the instructions coding as you want, depending also on the type of control unit choosen
  subtype cw_array is std_logic_vector(cw_array_size-1 downto 0);
  type cw_mem_matrix is array (integer range 0 to 2**opcode_size-1) of cw_array;
  subtype opcode_array is std_logic_vector(opcode_size-1 downto 0);
  subtype func_array is std_logic_vector(func_size-1 downto 0);

-- define the control word for nop instruction
  constant cw_nop : cw_array := (others => '0');

-- r-type instruction -> opcode field
  constant rtype : opcode_array := "000001";  -- for any register-to-register operation
-- r-type instruction -> func field

  constant rtype_sll   : func_array   := to_stdlogicvector(x"04");
  constant rtype_srl   : func_array   := to_stdlogicvector(x"06");
  constant rtype_sra   : func_array   := to_stdlogicvector(x"07");
  constant rtype_add   : func_array   := to_stdlogicvector(x"20");
  constant rtype_addu  : func_array   := to_stdlogicvector(x"21");
  constant rtype_sub   : func_array   := to_stdlogicvector(x"22");
  constant rtype_subu  : func_array   := to_stdlogicvector(x"23");
  constant rtype_and   : func_array   := to_stdlogicvector(x"24");
  constant rtype_or    : func_array   := to_stdlogicvector(x"25");
  constant rtype_xor   : func_array   := to_stdlogicvector(x"26");
  constant rtype_seq   : func_array   := to_stdlogicvector(x"28");
  constant rtype_sne   : func_array   := to_stdlogicvector(x"29");
  constant rtype_slt   : func_array   := to_stdlogicvector(x"2a");
  constant rtype_sgt   : func_array   := to_stdlogicvector(x"2b");
  constant rtype_sle   : func_array   := to_stdlogicvector(x"2c");
  constant rtype_sge   : func_array   := to_stdlogicvector(x"2d");
  constant rtype_sltu  : func_array   := to_stdlogicvector(x"3a");
  constant rtype_sgtu  : func_array   := to_stdlogicvector(x"3b");
  constant rtype_sleu  : func_array   := to_stdlogicvector(x"3c");
  constant rtype_sgeu  : func_array   := to_stdlogicvector(x"3d");
  -- constant rtype_mul   : func_array   := to_stdlogicvector(x"20"); -- is floating point ?
-- i-type instruction -> opcode field
  constant nop         : opcode_array := to_stdlogicvector(x"00");
  constant itype_addi  : opcode_array := to_stdlogicvector(x"08");
  constant itype_addui : opcode_array := to_stdlogicvector(x"09");
  constant itype_subui : opcode_array := to_stdlogicvector(x"0a");
  constant itype_subi  : opcode_array := to_stdlogicvector(x"0b");
  constant itype_andi  : opcode_array := to_stdlogicvector(x"0c");
  constant itype_ori   : opcode_array := to_stdlogicvector(x"0d");
  constant itype_xori  : opcode_array := to_stdlogicvector(x"0e");
  constant itype_slli  : opcode_array := to_stdlogicvector(x"14");
  constant itype_srli  : opcode_array := to_stdlogicvector(x"16");
  constant itype_srai  : opcode_array := to_stdlogicvector(x"17");
  constant itype_seqi  : opcode_array := to_stdlogicvector(x"18");
  constant itype_snei  : opcode_array := to_stdlogicvector(x"19");
  constant itype_sgti  : opcode_array := to_stdlogicvector(x"1a");
  constant itype_sgtui : opcode_array := to_stdlogicvector(x"1b");
  constant itype_sgei  : opcode_array := to_stdlogicvector(x"1c");
  constant itype_sgeui : opcode_array := to_stdlogicvector(x"1d");
  constant itype_slti  : opcode_array := to_stdlogicvector(x"3a");
  constant itype_sltui : opcode_array := to_stdlogicvector(x"3b");
  constant itype_slei  : opcode_array := to_stdlogicvector(x"3c");
  constant itype_sleui : opcode_array := to_stdlogicvector(x"3d");
  -- constant itype_mul   : opcode_array := to_stdlogicvector(x"20"); -- as before
-- jump instruction -> opcode field
  constant j           : opcode_array := to_stdlogicvector(x"02");
  constant jal         : opcode_array := to_stdlogicvector(x"03");
  constant jr          : opcode_array := to_stdlogicvector(x"12");
  constant jalr         : opcode_array := to_stdlogicvector(x"13");
-- branch instruction -> opcode field
  constant beqz        : opcode_array := to_stdlogicvector(x"04");
  constant bnez        : opcode_array := to_stdlogicvector(x"05");
-- load instruction -> opcode field
  constant lhi         : opcode_array := to_stdlogicvector(x"0f");
  constant lb          : opcode_array := to_stdlogicvector(x"20");
  constant lw          : opcode_array := to_stdlogicvector(x"23");
  constant lbu         : opcode_array := to_stdlogicvector(x"24");
  constant lhu         : opcode_array := to_stdlogicvector(x"25");
-- store instruction -> opcode field
  constant sb          : opcode_array := to_stdlogicvector(x"28");
  constant sw          : opcode_array := to_stdlogicvector(x"2b");

end package;
