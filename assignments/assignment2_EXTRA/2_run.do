vlib work
vlog 2_ALU_pkg.sv 2_ALU.v 2_ALU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save 2_ALU_tb.ucdb -onexit -du work.ALU_4_bit
coverage exclude -src 2_ALU.v -line 26 -code s
coverage exclude -src 2_ALU.v -line 26 -code b

run -all