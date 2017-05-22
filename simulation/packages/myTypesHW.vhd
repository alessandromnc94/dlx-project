LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE mytypeshw IS

-- control unit std_logic_vector sizes
  CONSTANT opcode_size        : INTEGER := 6;   -- opcode field size
  CONSTANT func_size          : INTEGER := 11;  -- func field size 
  CONSTANT alu_array_size     : INTEGER := 2;   -- alu control bits size
  CONSTANT alu_mem_array_size : INTEGER := 1+alu_array_size;  -- size for alu_mem_array (added valid output pin)
  CONSTANT cw_array_size      : INTEGER := 11 + alu_array_size;  -- cw size
  CONSTANT cw_mem_array_size  : INTEGER := 1+cw_array_size;  -- size for cw_mem_array (added rtype output pin)

-- change the values of the instructions coding as you want, depending also on the type of control unit choosen
  SUBTYPE cw_array IS STD_LOGIC_VECTOR(cw_array_size-1 DOWNTO 0);
  SUBTYPE cw_mem_array IS STD_LOGIC_VECTOR(cw_mem_array_size-1 DOWNTO 0);
  TYPE cw_mem_matrix IS ARRAY (INTEGER RANGE 0 TO 2**opcode_size-1) OF cw_mem_array;
  SUBTYPE alu_array IS STD_LOGIC_VECTOR(alu_array_size-1 DOWNTO 0);
  SUBTYPE opcode_array IS STD_LOGIC_VECTOR(opcode_size-1 DOWNTO 0);
  SUBTYPE func_array IS STD_LOGIC_VECTOR(func_size-1 DOWNTO 0);

-- r-type instruction -> opcode field
  CONSTANT rtype          : opcode_array := "000001";  -- for any register-to-register operation
-- r-type instruction -> func field
  CONSTANT rtype_nop      : func_array   := "00000000000";  -- nop
  CONSTANT rtype_add      : func_array   := "00000000001";  -- add rs1,rs2,rd
  CONSTANT rtype_sub      : func_array   := "00000000010";  -- sub rs1,rs2,rd
  CONSTANT rtype_and_op   : func_array   := "00000000011";  -- and rs1,rs2,rd
  CONSTANT rtype_or_op    : func_array   := "00000000100";  -- or rs1,rs2,rd
-- i-type instruction -> opcode field
  CONSTANT nop            : opcode_array := "000000";  -- nop
  CONSTANT itype_addi1    : opcode_array := "000010";  -- addi1 rs1,rd,inp1
  CONSTANT itype_subi1    : opcode_array := "000011";  -- subi1 rs1,rd,inp1
  CONSTANT itype_andi1_op : opcode_array := "000100";  -- and1 rs1,rd,inp1
  CONSTANT itype_ori1_op  : opcode_array := "000101";  -- ori1 rs1,rd,inp1
  CONSTANT itype_addi2    : opcode_array := "000110";  -- subi2 rs1,rd,inp1
  CONSTANT itype_subi2    : opcode_array := "000111";  -- subi2 rs1,rd,inp1
  CONSTANT itype_andi2_op : opcode_array := "001000";  -- and2 rs1,rd,inp1
  CONSTANT itype_ori2_op  : opcode_array := "001001";  -- ori2 rs1,rd,inp1
  CONSTANT itype_mov      : opcode_array := "001010";  -- mov rs1,rd,inp1
  CONSTANT itype_s_reg1   : opcode_array := "001011";  -- s_reg1 rs1,rd,inp1
  -- constant itype_s_mem1 : opcode_array :=  "001100";    -- s_mem1 rs1,rd,inp1
  CONSTANT itype_l_mem1   : opcode_array := "001101";  -- l_mem1 rs1,rd,inp1
  CONSTANT itype_s_reg2   : opcode_array := "001110";  -- s_reg2 rs1,rd,inp1
  CONSTANT itype_s_mem2   : opcode_array := "001111";  -- s_mem2 rs1,rd,inp1
  CONSTANT itype_l_mem2   : opcode_array := "010000";  -- l_mem2 rs1,rd,inp1

END PACKAGE;

