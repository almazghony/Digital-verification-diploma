vlib work
vlog 3_pkg.sv 3_counter.sv 3_counter_tb.sv 3_counter_top.sv 3_counter_if.sv 3_counter_SVA.sv +cover -covercells
vsim -voptargs=+acc work.counter_top -cover
add wave *
add wave -position insertpoint  \
sim:/counter_top/TB/my_inputs \
sim:/counter_top/TB/my_inputs.rst_n \
sim:/counter_top/TB/my_inputs.load_n \
sim:/counter_top/TB/my_inputs.up_down \
sim:/counter_top/TB/my_inputs.ce \
sim:/counter_top/TB/my_inputs.data_load
coverage save 3_counter_tb.ucdb -onexit

run -all


