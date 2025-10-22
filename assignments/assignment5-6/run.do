vlib work
vlog -cover bcestf -f src_files.list
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
coverage save cov.ucdb -onexit
coverage exclude -src ALSU.sv -line 103 -code s
coverage exclude -src ALSU.sv -line 103 -code b
coverage exclude -du ALSU -togglenode {cin_reg[1]}
add wave -position insertpoint sim:/top/alsuif/*
add wave /top/dut/SVA_inst/a1 /top/dut/SVA_inst/a2 /top/dut/SVA_inst/a3 /top/dut/SVA_inst/a4 /top/dut/SVA_inst/a5 /top/dut/SVA_inst/a6 /top/dut/SVA_inst/a7 /top/dut/SVA_inst/a19 /top/dut/SVA_inst/a9 /top/dut/SVA_inst/a10 /top/dut/SVA_inst/a11 /top/dut/SVA_inst/a12 /top/dut/SVA_inst/a13 /top/dut/SVA_inst/a14 /top/dut/SVA_inst/a15 /top/dut/SVA_inst/a16 /top/dut/SVA_inst/a17
run -all

