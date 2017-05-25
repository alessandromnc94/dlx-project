# dlx-project

This repository contains the DLX project developed for Politecnico di Torino Microelectronics course.

# TO DO

* Convert files from VHDL 2008 to VHDL 1998
  * MUX_n_m_1 (not possible full generic)
  * XXX_gate_n (not possible __*"logic\_op std\_logic\_vector"*__ )
  * probably other stuff
* Implement
  * Counters
  * Adders/Subtracters
  * Multipliers
  * Dividers
  * Shifters
  * Floating Point Elements
  * Comparators
* Draw schematic



## File Tree
* scripts : all scripts to automate compilation, analysis and simulations
* simulation : all files for simulations (MODELSIM)
  * components : all components with own packages are placed here<!--* others : all not vhdl files are placed here-->
  * packages : all generic packages are placed here
* synthesis : all output files from synthesis (SYNOPSYS)
* how to format vhdl file.txt
* README.md

### __*"scripts"*__ directory

This directory contains TCL scripts to compile, analyze and run testbenches from __*"simulation > components"*__ folder.
This scripts refer to files starting from the root.

### __*"simulation"*__ directory

#### __*"components"*__ directory
#### __*"packages"*__ directory

### __*"synthesis"*__ directory

## How to

### How to compile the project

In order to compile the project (or part of it) it's needed VHDL 2008 compilator.
To set the compiler in Modelsim click on __*"Compile > Compile Option"*__ and select the correct version.
Later you can run the compilation manually choosing files from __*"simulation > components"*__ directory or automatically using one of the scripts placed in __*"scripts"*__ directory.

### How to run a testbench

In order to run a testbench you can manually set waves or use the script placed in __*"scripts"*__ directory.
The testbench contains an __*"ASSERT"*__ that stops the __*"run -all"*__ command of __*"xxxx_run.tcl"*__.

### How to analyze the project

As the compiling, you can manually analyze by choosing files or use one of the scripts placed in __*"scripts"*__ directory.
However __*"synthesis"*__ folder contains some output files for helping with analysises.