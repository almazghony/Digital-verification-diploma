vlib work
vlog 2_adder_pkg.sv 2_adder.v 2_adder_tb.sv  +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit
run -all

