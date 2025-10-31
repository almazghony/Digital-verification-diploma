vlib work
vlog +define+SIM -f src_files.list +cover -covercells
vsim -voptargs=+acc work.ram_top -cover

coverage save RAM_COV.ucdb -onexit
coverage exclude -src RAM.sv -line 27 -code s
coverage exclude -src RAM.sv -line 27 -code b
add wave -position insertpoint sim:/ram_top/ramif/*
run -all

