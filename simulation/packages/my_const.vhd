LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;


PACKAGE my_const IS

        CONSTANT n_bit : INTEGER := 32; --size of instruction and data memories and width of each register
        
        CONSTANT aconst     : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0) := conv_std_logic_vector(4, n_bit);
        CONSTANT offconst   : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0) := conv_std_logic_vector(8, n_bit);
        CONSTANT raddrconst : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0) := conv_std_logic_vector(31, n_bit);  
        
END PACKAGE;
