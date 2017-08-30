LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.MyTypes.all;

ENTITY Branch_unit IS
  GENERIC (
    n : INTEGER := regsize
    );
  PORT (
    imm : IN  STD_LOGIC_VECTOR(n-1 downto 0);   --From datapath
    reg : IN  STD_LOGIC_VECTOR(n-1 downto 0);
    npc : IN  STD_LOGIC_VECTOR(n-1 downto 0);
    be  : IN  STD_LOGIC;                        --From CU
    jr  : IN  STD_LOGIC;
    jmp : IN  STD_LOGIC;
    pc  : OUT STD_LOGIC_VECTOR(n-1 downto 0);
    );
END ENTITY;

ARCHITECTURE Structural OF Branch_unit IS
  
  COMPONENT mux_n_2_1 IS
    GENERIC (
      n : INTEGER := 1
      );
    PORT (
      in_0  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_1  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      s     : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT zero_comparator IS
    GENERIC (
     n : INTEGER := 8
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  
  COMPONENT rca_n IS
    GENERIC (
      n : INTEGER := 4
     );
   PORT (
  <<<<<<< HEAD
      in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_in  : IN  STD_LOGIC;
      sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      carry_out : OUT STD_LOGIC
  =======
     in_1      : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     in_2      : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     carry_in  : STD_LOGIC;
     sum       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     carry_out : STD_LOGIC
  >>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      );
  END COMPONENT;
  
  COMPONENT not_gate IS
    PORT (
  <<<<<<< HEAD
      in_s  : IN  STD_LOGIC;
  =======
      i     : IN  STD_LOGIC;
  >>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
      out_s : OUT STD_LOGIC
      );
  END COMPONENT;
  
  SIGNAL om1 , os          : STD_LOGIC_VECTOR(regsize-1 DOWNTO 0);
  SIGNAL ocmp , oinv , om2 , om3 : STD_LOGIC;
  
  BEGIN
    
    mux1 : mux_n_2_1        generic map(n => regsize)
                            port map(imm , reg , jr , om1);
    comp : zero_comparator  generic map(n => regsize)
                            port map(reg , ocmp);
    add  : rca_n            generic map(n => regsize)
                            port map(npc , om1 , '0' , os , open);
    inv  : not_gate         port map(ocmp , oinv);
    mux2 : mux_n_2_1        generic map(n => 1)
                            port map(oinv , ocmp , be , om2);
    mux3 : mux_n_2_1        generic map(n => 1)
                            port map('0' , om2 , jmp , om3);
    mux4 : mux_n_2_1 generic map(n => regsize)
                     port map(npc , os , om3 , pc);
    
END ARCHITECTURE;