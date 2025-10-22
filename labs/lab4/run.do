vlib work
vlog *v  +cover
vsim -voptargs=+acc vending_machine_top -cover
add wave *
coverage save vending_machine_top.ucdb -onexit
run -all