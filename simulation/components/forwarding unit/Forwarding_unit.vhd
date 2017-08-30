library ieee;
use ieee.std_logic_1164.all;
use work.mytypes.all;

entity forwarding_unit
  port (
    arf      : in  addregtype(1 downto 0);
    ar       : in  addregtype(3 downto 0);
    data_in  : in  regtype(2 downto 0);
    clk      : in  std_locic;
    out_mux  : out std_logic_vector(1 downto 0);
    data_out : out regtype(1 downto 0)
    );
end entity;


architecture behavioral of forwardin_unit is

begin
  
  process(clk)

  begin
    
    if(rising_edge(clk)) then
      out_mux(0) <= '0';
      out_mux(1) <= '1';
      for i in 0 to 3 loop
        for j in o to 1 loop
          if(arf(j) /= zero) then
            if(arf(j) = ar(i)) then
              out_mux(j)  <= '1';
              data_out(j) <= data_in(i);
            end if
          end if;
        end loop;
      end loop
    end if;
    
  end process;
  
end architecture;
