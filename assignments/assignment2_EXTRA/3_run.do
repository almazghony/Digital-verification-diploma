vlib work
vlog 3_golden_model.sv 3_FSM_pkg.sv 3_FSM_010.v 3_FSM_tb.sv +cover -covercells
vsim -voptargs=+acc work.FSM_010_tb -cover
add wave *
coverage save 3_FSM_tb.ucdb -onexit -du work.FSM_010
coverage exclude -du FSM_010 -togglenode {users_count[6]}
coverage exclude -du FSM_010 -togglenode {users_count[7]}
coverage exclude -du FSM_010 -togglenode {users_count[8]}
coverage exclude -du FSM_010 -togglenode {users_count[9]}

run -all

