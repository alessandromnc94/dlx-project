library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

package alu_logicals_types is
	constant alu_logicals_array_size : integer := 2;
	subtype alu_logicals_array is std_logic_vector(alu_logicals_array_size-1 downto 0)

	constant alu_logicals_and : alu_logicals_array := conv_std_logic_vector(0, alu_logicals_array_size);
	constant alu_logicals_nand : alu_logicals_array := conv_std_logic_vector(1, alu_logicals_array_size);
	constant alu_logicals_or : alu_logicals_array := conv_std_logic_vector(2, alu_logicals_array_size);
	constant alu_logicals_nor : alu_logicals_array := conv_std_logic_vector(3, alu_logicals_array_size);
	constant alu_logicals_xor : alu_logicals_array := conv_std_logic_vector(4, alu_logicals_array_size);
	constant alu_logicals_xnor : alu_logicals_array := conv_std_logic_vector(5, alu_logicals_array_size);

end package;