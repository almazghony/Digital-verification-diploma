vlib work
vlog +define+SIM -f src_files_wrapper.list +cover -covercells
vsim -voptargs=+acc work.wrapper_top -cover
add wave -position insertpoint sim:/wrapper_top/slaveif/*
add wave -position insertpoint sim:/wrapper_top/ramif/*
add wave -position insertpoint sim:/wrapper_top/wrapperif/*
add wave -position insertpoint sim:/wrapper_top/slave_dut/*

add wave -position insertpoint sim:/wrapper_top/dut/ram_dut/*
add wave -position insertpoint sim:/wrapper_top/slave_dut.received_address
add wave -position insertpoint sim:/wrapper_top/slaveif/*
add wave -position insertpoint sim:/wrapper_top/ramif/*
add wave -position insertpoint sim:/wrapper_top/wrapperif/*
coverage save WRAPPER_COV.ucdb -onexit

coverage exclude -src RAM.sv -line 27 -code b
coverage exclude -src RAM.sv -line 27 -code s

coverage exclude -src slave.sv -line 135 -code s
coverage exclude -src slave.sv -line 134 -code b
coverage exclude -src slave_ref.sv -line 46 -code b

run -all
