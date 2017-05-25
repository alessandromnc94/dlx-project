LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

USE work.cu_hw_types.ALL;

PACKAGE cu_hw_functions IS
-- function to initialize cw_mem using a file (cw_input.txt)
  FUNCTION initialize_cw_mem RETURN cw_mem_matrix;
END PACKAGE;

PACKAGE BODY cu_hw_functions IS
-- function to initialize cw_mem using a file (cw_input.txt)
  FUNCTION initialize_cw_mem RETURN cw_mem_matrix IS
    FILE file_in                    : TEXT;
    VARIABLE line_in                : LINE;
    VARIABLE cw_mem_ret             : cw_mem_matrix := (OTHERS => (OTHERS => '0'));
    VARIABLE index_start, index_end : INTEGER;
    VARIABLE line_format            : CHARACTER;
    VARIABLE content                : cw_mem_array;
  BEGIN
    file_open(file_in, "cw_input.txt", READ_MODE);
    WHILE NOT endfile(file_in) LOOP
      readline(file_in, line_in);
      line_format := line_in.ALL(1);
      CASE line_format IS
        WHEN 'r' | 'r' =>
          read(line_in, line_format);
          read(line_in, index_start);
          read(line_in, index_end);
          read(line_in, content);
          cw_mem_ret(index_start TO index_end) := (index_start TO index_end => content);
        WHEN 's' | 's' =>
          read(line_in, line_format);
          read(line_in, index_start);
          read(line_in, content);
          cw_mem_ret(index_start) := content;
        WHEN '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' =>
          read(line_in, index_start);
          read(line_in, content);
          cw_mem_ret(index_start) := content;
        WHEN '#'    => NULL;
        WHEN OTHERS => REPORT "invalid line... line is skipped\n" & line_in.ALL SEVERITY WARNING;
      END CASE;
    END LOOP;
    RETURN cw_mem_ret;
  END FUNCTION;
END PACKAGE BODY;
