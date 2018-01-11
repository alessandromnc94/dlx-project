library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- instruction memory for dlx
-- memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity iram is
  generic (
    ram_depth : integer := 64;
    i_size    : integer := 32);
  port (
    rst  : in  std_logic;
    addr : in  std_logic_vector(i_size - 1 downto 0);
    dout : out std_logic_vector(i_size - 1 downto 0)
    );

end iram;

architecture iram_bhe of iram is

  type ramtype is array (0 to ram_depth - 1) of std_logic_vector(i_size/4-1 downto 0);  -- std_logic_vector(i_size - 1 downto 0);

  signal iram_mem : ramtype;

begin  -- iram_bhe

  dout <= conv_std_logic_vector(iram_mem(conv_integer(unsigned(addr))), i_size);

  -- purpose: this process is in charge of filling the instruction ram with the firmware
  -- type   : combinational
  -- inputs : rst
  -- outputs: iram_mem
  fill_mem_p : process (rst)
    file mem_fp         : text;
    variable file_line  : line;
    variable index      : integer := 0;
    variable tmp_data_u : std_logic_vector(i_size-1 downto 0);
  begin  -- process fill_mem_p
    if (rst = '0') then
      file_open(mem_fp, "test.asm.mem", read_mode);
      while (not endfile(mem_fp)) loop
        readline(mem_fp, file_line);
        hread(file_line, tmp_data_u);
        iram_mem(index) <= conv_integer(unsigned(tmp_data_u));
        index           := index + 1;
      end loop;
    end if;
  end process fill_mem_p;

end iram_bhe;
