vlib work
vlog 1_pkg.sv 1_ALSU.v 1_ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save 1_ALSU_tb.ucdb -onexit
coverage exclude -du ALSU -togglenode {cin_reg[1]}
coverage exclude -src 1_ALSU.v -line 111 -code b
coverage exclude -src 1_ALSU.v -line 111 -code s

run -all

