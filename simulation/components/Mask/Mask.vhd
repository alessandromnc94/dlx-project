LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mask IS
  GENERIC (
    n : INTEGER := 32
    );
  PORT (
    a   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    sel : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    b   : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Beh OF Mask IS
  
  BEGIN
    
    PROCESS(a , sel)
      
      BEGIN
        
        CASE sel IS
          
          WHEN "00"   => b <= a;
          WHEN "01"   => b(n-1 DOWNTO 8) <= (OTHERS => '0'); b(7 DOWNTO 0) <= a(7 DOWNTO 0);
          WHEN "10"   => b(n-1 DOWNTO 16) <= (OTHERS => '0'); b(15 DOWNTO 0) <= a(15 DOWNTO 0);
          WHEN OTHERS => b <= a;
            
          END CASE;
        
    END PROCESS;
    
END ARCHITECTURE;