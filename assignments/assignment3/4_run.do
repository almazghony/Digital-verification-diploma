vlib work
vlog 4_mem.sv 4_mem_tb.sv +cover -covercells
vsim -voptargs=+acc work.my_mem_tb -cover
add wave *
coverage save 4_mem_tb.ucdb -onexit

run -all

