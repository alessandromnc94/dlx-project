library ieee;
use ieee.std_logic_1164.all;

use work.alu_logicals_types.all;

entity alu_logicals_n is 
	generic (
		n : integer : 8
	);
	port (
		i1 : in std_logic_vector(n-1 downto 0);
		i2 : in std_logic_vector(n-1 downto 0);
		logic : in alu_logicals_n_array;
		o : out std_logic_vector(n-1 downto 0)
	);
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of alu_logicals_n is
begin

end architecture;

-- structural architecture
architecture structural of alu_logicals_n is
begin

end architecture;

-- configurations

-- behavioral configuration
configuration cfg_alu_logicals_n_behavioral of alu_logicals_n is
for behavioral
end for;
end configuration;

-- structural configuration with behavioral components
configuration cfg_alu_logicals_n_structural_1 of alu_logicals_n is
for structural
end for;
end configuration;

-- structural configuration with structural components
configuration cfg_alu_logicals_n_structural_2 of alu_logicals_n is
for structural
end for;
end configuration;