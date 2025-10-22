vlib work
vlog -cover bcestf -f alsu_src_files.list
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
coverage save cov.ucdb -onexit
coverage exclude -src ALSU.sv -line 99 -code s
coverage exclude -src ALSU.sv -line 99 -code b
coverage exclude -du ALSU -togglenode {cin_reg[1]}
add wave -position insertpoint sim:/top/alsuif/*
add wave -position insertpoint sim:/top/srif/*
run -all

