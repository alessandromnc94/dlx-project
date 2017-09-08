LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.alu_types.ALL;


ENTITY Datapath IS
  GENERIC (
    instr_size    : INTEGER := 32;
    imm_val_size  : INTEGER := 16;
    j_val_size    : INTEGER := 26;
    reg_addr_size : INTEGER := 5;
    n_bit         : INTEGER := 32;
    ext_mem_bit   : INTEGER := 32 --to be modified, length of addresses of extern memory, DATA MEMORY MUST HAVE 32 BIT OF ADDRESS TO MANTAIN COMPATIBILITY!!!!
    );
  PORT (
    -- input
    instr  : IN     STD_LOGIC_VECTOR(instr_size-1 DOWNTO 0);    --Current instruction from IRAM, feeds the IR
    lmdin  : IN     STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);         --LMD Register Data Input
    clk    : IN     STD_LOGIC;                                  --Clock signal
    -- 1st stage
    pcr    : IN     STD_LOGIC;                                  --Program Counter Reset
    pce    : IN     STD_LOGIC;                                  --Program Counter Enable
    npcr   : IN     STD_LOGIC;                                  --NPC Reset
    npce   : IN     STD_LOGIC;                                  --NPC Counter Enable
    irr    : IN     STD_LOGIC;                                  --Instruction Register Reset
    ire    : IN     STD_LOGIC;                                  --Instruction Register Enable
    -- 2nd stage
      --Register File Signals
    rfr    : IN     STD_LOGIC;                                  --Reset
    rfe    : IN     STD_LOGIC;                                  --Enable
    rfr1   : IN     STD_LOGIC;                                  --Read Enable 1
    rfr2   : IN     STD_LOGIC;                                  --Read Enable 2
    rfw    : IN     STD_LOGIC;                                  --Write Enable
      --Branch Unit Signals
    be     : IN     STD_LOGIC;                                  --BEQZ/!BNEZ
    jr     : IN     STD_LOGIC;                                  --JR/!noJR
    jmp    : IN     STD_LOGIC;                                  --JMP/!noJMP
      --Sign Extender and Registers Signals
    see    : IN     STD_LOGIC;                                  --Sign Extender Enable
    ar     : IN     STD_LOGIC;                                  --A Register Reset
    ae     : IN     STD_LOGIC;                                  --A Register Enable
    br     : IN     STD_LOGIC;                                  --B Register Reset
    ben    : IN     STD_LOGIC;                                  --B Register Enable
    ir     : IN     STD_LOGIC;                                  --Immediate Register Enable
    ie     : IN     STD_LOGIC;                                  --Immediate Register Enable
    -- 3rd stage
      --Forwarding Unit Signals
    arf1   : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0); --addresses of registers for the current operation(content of A and B Registers) 
    arf2   : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0);
    exear  : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0); --address of reg in execute stage
    memar  : IN     STD_LOGIC_VECTOR(reg_addr_size-1 DOWNTO 0); --address of reg in memory stage
      --ALU Signals
    alusel : IN     alu_array;                                  --ALU Operation Selectors
      --Muxes and Registers Signals
    m3s    : IN     STD_LOGIC;                                  --Mux 3 Selector
    aor    : IN     STD_LOGIC;                                  --ALU_Out Register Reset
    aoe    : IN     STD_LOGIC;                                  --ALU_Out Registes Enable
    mer    : IN     STD_LOGIC;                                  --ME Register Reset
    mee    : IN     STD_LOGIC;                                  --ME Register Enable
    -- 4th stage
    r1r    : IN     STD_LOGIC;                                  --Register 1 Reset
    r1e    : IN     STD_LOGIC;                                  --Register 1 Enable
    lmdr   : IN     STD_LOGIC;                                  --LMD Register Reset
    lmde   : IN     STD_LOGIC;                                  --LMD Register Reset
    m4s    : IN     STD_LOGIC;                                  --Mux 5 Selector
    -- 5th stage
    m5s    : IN     STD_LOGIC;                                  --Mux 5 Selector
    r2r    : IN     STD_LOGIC;                                  --Register 2 Reset
    r2e    : IN     STD_LOGIC;                                  --Register 2 Enable
    -- outputs
    pcout  : BUFFER STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);   --Program Counter Output PER LE DIMENSIONI PUOI CAMBIARLO, LA IRAM PUO' ESSERE DIVERSA DALLA DRAM
    aluout : BUFFER STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);   --ALU Outpud Data
    meout  : OUT    STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0)         --ME Register Data Out
    );
END ENTITY;

ARCHITECTURE Structural OF Datapath IS
  
  COMPONENT register_n IS
    GENERIC (
     n : INTEGER := 8
      );
    PORT (
      din  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      clk  : IN  STD_LOGIC;
      rst  : IN  STD_LOGIC;
      set  : IN  STD_LOGIC;
      en   : IN  STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT rca_n IS
    GENERIC (
     n : INTEGER := 4
      );
    PORT (
     in_1      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     in_2      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     carry_in  : IN  STD_LOGIC;
     sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
     carry_out : OUT STD_LOGIC
     );
  END COMPONENT;
  
  COMPONENT Branch_unit IS
    GENERIC (
      n1 : INTEGER := 32
      );
    PORT (
      imm : IN  STD_LOGIC_VECTOR(n1-1 downto 0);   --From datapath
      reg : IN  STD_LOGIC_VECTOR(n1-1 downto 0);
      npc : IN  STD_LOGIC_VECTOR(n1-1 downto 0);
      be  : IN  STD_LOGIC;                        --From CU
      jr  : IN  STD_LOGIC;
      jmp : IN  STD_LOGIC;
      pc  : OUT STD_LOGIC_VECTOR(n1-1 downto 0)
      );
  END COMPONENT;
  
  COMPONENT register_file IS
    GENERIC (
      width_add  : INTEGER := 5;
      width_data : INTEGER := 64
      );
    PORT (
      clk     : IN  STD_LOGIC;
      reset   : IN  STD_LOGIC;
      enable  : IN  STD_LOGIC;
      rd1     : IN  STD_LOGIC;
      rd2     : IN  STD_LOGIC;
      wr      : IN  STD_LOGIC;
      add_wr  : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
      add_rd1 : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
      add_rd2 : IN  STD_LOGIC_VECTOR(width_add-1 DOWNTO 0);
      datain  : IN  STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
      out1    : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
      out2    : OUT STD_LOGIC_VECTOR(width_data-1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT sign_extender IS
    GENERIC (
      n_in  : INTEGER := 32;
      n_out : INTEGER := 2*n_in
      );
    PORT (
      in_s  : IN  STD_LOGIC_VECTOR(n_in-1 DOWNTO 0);
      en    : IN  STD_LOGIC;
      out_s : OUT STD_LOGIC_VECTOR(n_out-1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT forwarding_unit IS
    GENERIC (
      n : integer := 32; --address length
      m : integer := 32 --data length
      );
    PORT (
      arf1     : IN  std_logic_vector(n-1 DOWNTO 0); --addresses of regisers for the current operation 
      arf2     : IN  std_logic_vector(n-1 DOWNTO 0);
      exear    : IN  std_logic_vector(n-1 DOWNTO 0); --adrress of reg in execute stage
      memar    : IN  std_logic_vector(n-1 DOWNTO 0); --adrress of reg in memory stage
      exed     : IN  std_logic_vector(m-1 DOWNTO 0); -- data coming from execute stage
      memd     : IN  std_logic_vector(m-1 DOWNTO 0); -- data coming from memory stage
      clk      : IN  std_logic;
      out_mux  : OUT std_logic_vector(1 DOWNTO 0);
      dout1    : OUT std_logic_vector(m-1 DOWNTO 0); -- data to be forwarded
      dout2    : OUT std_logic_vector(m-1 DOWNTO 0) 
      );
  END COMPONENT;

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
  
  COMPONENT alu IS
    GENERIC (
      n : INTEGER := 32
      );
    PORT (
      in_1   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      in_2   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      op_sel : IN  alu_array;
      -- outputs
      out_s  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
      );
    END COMPONENT;
    
    SIGNAL pcin , npcin , aconst , npcout                                      : STD_LOGIC_VECTOR(ext_mem_bit-1 DOWNTO 0);
    SIGNAL irout                                                               : STD_LOGIC_VECTOR(instr_size-1 DOWNTO 0);
    SIGNAL om5 , ain , bin , immin , aout , bout , immout , fuo1 , fuo2 , fuo3 : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);
    SIGNAL fuo4 , om1 , om2 , om3 , om4 , oalu , meout , r1out , lmdout        : STD_LOGIC_VECTOR(n_bit-1 DOWNTO 0);
    SIGNAL fum                                                                 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
    BEGIN
      
      aconst(ext_mem_bit-1 DOWNTO 3) <= (OTHERS => '0');
      aconst(2 DOWNTO 0) <= "100"; --BRUTTO, TROVA UN'ALTERNATIVA PER SOMMARE 4!!!
      
      --Fetch Stage
      pc          : register_n      GENERIC MAP(n => ext_mem_bit) --PUO' CAMBIARE
                                    PORT MAP(pcin , clk , pcr , '0' , pce , pcout);
      ir          : register_n      GENERIC MAP(n => instr_size)
                                    PORT MAP(instr , clk , irr , '0' , ire , irout);
      add         : rca_n           GENERIC MAP(n => ext_mem_bit) --DEVE ESSERE UGUALE AL PROGRAM COUNTER                 
                                    PORT MAP(pcout , aconst , '0' , npcin , open);
      npc         : register_n      GENERIC MAP(n => ext_mem_bit) --COME PC
                                    PORT MAP(npcin , clk , npcr , '0' , npce , npcout);
                         
      --Decode Stage
      reg_file    : register_file   GENERIC MAP(width_add => reg_addr_size , width_data => n_bit)
                                    PORT MAP(clk , rfr , rfe , rfr1 , rfr2 , rfw , irout(instr_size-7 DOWNTO instr_size-11) , irout(instr_size-12 DOWNTO instr_size-16) , irout(instr_size-17 DOWNTO instr_size-21) , om5 , ain , bin);
      sign_extend : sign_extender   GENERIC MAP(n_in => imm_val_size , n_out => n_bit)
                                    PORT MAP(irout(instr_size-17 DOWNTO 0) , see , immin);
      branch      : Branch_unit     GENERIC MAP(n1 => ext_mem_bit) --LO STESSO DI PC
                                    PORT MAP(immin ,  ain , npcout , be , jr , jmp , pcin); --OCCHIO CHE L'IMMEDIATO NON HA LA STESSA DIMENSIONE DI NPC E PC, QUINDI DEVI ESTENDERE LA DIM DI IMMEDIATE DENTRO IL MODULO!!!!!!!
      areg        : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(ain , clk , ar , '0' , ae , aout);
      breg        : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(bin , clk , br , '0' , ben , bout);
      immreg      : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(immin , clk , ir , '0' , ie , immout);
                                    
      --Execute Stage
      mux1        : mux_n_2_1       GENERIC MAP(n => n_bit)
                                    PORT MAP(aout , fuo1 , fum(0) , om1);
      mux2        : mux_n_2_1       GENERIC MAP(n => n_bit)
                                    PORT MAP(bout , fuo2 , fum(1) , om2);
      mux3        : mux_n_2_1       GENERIC MAP(n => n_bit)
                                    PORT MAP(om2 , immout , m3s , om3);
      me          : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(bout , clk , mer , '0' , mee , meout);
      aluinst     : alu             GENERIC MAP(n => n_bit)
                                    PORT MAP(om1 , om3 , alusel , oalu);
      aluoutinst  : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(oalu , clk , aor , '0' , aoe , aluout);
      forwinst    : forwarding_unit GENERIC MAP(n => reg_addr_size , m => n_bit);
                                    PORT MAP(arf1 , arf2 , exear , memar , aluout , om4 , clk , fum , fuo1 , fuo2);
                                      
      --Memory Stage
      reg1inst    : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(aluout , clk , r1r , '0' , r2e , r1out);
      lmd         : register_n      GENERIC MAP(n => n_bit)
                                    PORT MAP(lmdin , clk , lmdr , '0' , lmde , lmdout);
      mux4        : mux_n_2_1       GENERIC MAP(n => n_bit)
                                    PORT MAP(r1out , lmdout , m4s , om4);
                                      
      --Write Back Stage
      mux5        : mux_n_2_1       GENERIC MAP(n => n_bit)
                                    PORT MAP(lmdout , r1out , m5s , om5);
            
END ARCHITECTURE;
