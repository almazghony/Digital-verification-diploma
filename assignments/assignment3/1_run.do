vlib work
vlog 1_PKG.sv 1_ALU.sv 1_ALU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save 1_ALU_tb.ucdb -onexit
coverage exclude -src 1_ALU.sv -line 18 -code s
coverage exclude -src 1_ALU.sv -line 18 -code b
run -all

