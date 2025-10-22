vlib work
vlog 2_ALU.sv 2_ALU_tb.sv 2_ALU_SVA.sv +cover -covercells 
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save 2_ALU_tb.ucdb -onexit
coverage exclude -src 2_ALU.sv -line 25 -code s
coverage exclude -src 2_ALU.sv -line 25 -code b
add wave /ALU_tb/dut/SVA/a1 /ALU_tb/dut/SVA/a2 /ALU_tb/dut/SVA/a3 /ALU_tb/dut/SVA/a4 /ALU_tb/dut/SVA/a5
run -all

