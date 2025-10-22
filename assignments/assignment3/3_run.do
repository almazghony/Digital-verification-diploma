vlib work
vlog 3_pkg.sv 3_ALSU.v 3_ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save 3_ALSU_tb.ucdb -onexit
coverage exclude -du ALSU -togglenode {cin_reg[1]}
coverage exclude -src 3_ALSU.v -line 111 -code b
coverage exclude -src 3_ALSU.v -line 111 -code s

run -all

