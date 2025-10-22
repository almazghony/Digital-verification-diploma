vdel -all
vlib work
vlog +define+SIM -f src_files.list  +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
coverage save cov.ucdb -onexit
add wave *
add wave -position insertpoint sim:/FIFO_top/intrf/*
add wave -position insertpoint sim:/FIFO_top/dut/*
add wave -position insertpoint sim:/FIFO_top/dut.mem

run 0
run -all

