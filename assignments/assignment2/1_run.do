vlib work
vlog 1_dyn_arr.sv  +cover -covercells
vsim -voptargs=+acc work.dyn_arr -cover
add wave *
run -all