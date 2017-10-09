LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mask IS
  GENERIC (
    n : INTEGER := 32
    );
  PORT (
    a   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    sel : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    sign_extend : in std_logic;
    b   : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF Mask IS
  
  BEGIN

    PROCESS(a , sel)
      
      BEGIN
        
        CASE sel IS
          
          WHEN "00"   => b <= a;
          WHEN "01"   => b(n-1 DOWNTO 8) <= (OTHERS => b(7) and sign_extend); b(7 DOWNTO 0) <= a(7 DOWNTO 0);
          WHEN "10"   => b(n-1 DOWNTO 16) <= (OTHERS => b(15) and sign_extend); b(15 DOWNTO 0) <= a(15 DOWNTO 0);
          WHEN OTHERS => b <= a;
            
          END CASE;
        
    END PROCESS;
    
END ARCHITECTURE;