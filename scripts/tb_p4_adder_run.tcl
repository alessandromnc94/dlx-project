# vsim work.ENTITY
vsim work.tb_p4_adder
# add wave [-label LABEL] [-color STD_COLOR] [-RADIX] SIGNAL_ABSOLUTE_REFERENCE
# Insert your waves below

add wave -group tb *
add wave -group p4_adder dut/*
add wave -group sg dut/sg/*
add wave -group cg dut/cg/*

run -all
