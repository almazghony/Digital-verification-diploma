vlib work
vlog 2_pkg.sv 2_counter.v 2_counter_tb.sv +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save 2_counter_tb.ucdb -onexit
run -all

