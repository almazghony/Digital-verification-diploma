vlib work
vlog +define+SIM -f src_files_slave.list +cover -covercells
vsim -voptargs=+acc work.slave_top -cover
add wave -position insertpoint sim:/slave_top/slaveif/*
add wave -position insertpoint sim:/slave_top/slave_dut/*
coverage exclude -src slave.sv -line 135 -code s
coverage exclude -src slave.sv -line 134 -code b
coverage save Slave_cov.ucdb -onexit
run -all
