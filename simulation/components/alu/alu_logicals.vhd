library ieee;
use ieee.std_logic_1164.all;

use work.alu_logicals_types.all;

entity alu_logicals is
	port (
		i1 : in std_logic;
		i2 : in std_logic;
		logic : in alu_logicals_array;
		o : out std_logic
	);
end entity;

-- architectures

-- behavioral architecture
architecture behavioral of alu_logicals is
begin

	process(all)
	begin
		case logic is
			when alu_logicals_and => o <= i1 and i2;
			when alu_logicals_nand => o <= i1 and i2;
			when alu_logicals_or => o <= i1 and i2;
			when alu_logicals_nor => o <= i1 and i2;
			when alu_logicals_xor => o <= i1 and i2;
			when alu_logicals_xnor => o <= i1 and i2;
			when others => o <= (others => 'Z');
		end case;
	end process;

end architecture;

-- structural architecture
architecture structural of alu_logicals is
begin


end architecture;

-- configurations

-- behavioral configuration
configuration cfg_alu_logical_n_behavioral of alu_logical_n is
for behavioral
end for;
end configuration;

-- structural configuration
configuration cfg_alu_logical_n_structural of alu_logical_n is
for structural
end for;
end configuration;