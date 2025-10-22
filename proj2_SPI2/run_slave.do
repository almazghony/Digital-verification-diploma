vlib work
vlog -f src_files_slave.list +cover -covercells
vsim -voptargs=+acc work.slave_top -cover
add wave -position insertpoint sim:/slave_top/slaveif/*
add wave -position insertpoint sim:/slave_top/slave_dut/*

run -all
