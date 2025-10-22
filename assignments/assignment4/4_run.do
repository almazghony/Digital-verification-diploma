vlib work
vlog 4_config_reg_buggy_questa.svp 4_buggy_reg_tb.sv +cover -covercells
vsim -voptargs=+acc work.config_reg_tb -cover
add wave *
run -all