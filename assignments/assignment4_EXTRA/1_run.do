vlib work
vlog 1_priority_enc.sv 1_priority_enc_tb.sv 1_priority_enc_SVA.sv +cover -covercells 
vsim -voptargs=+acc work.priority_enc_tb -cover
add wave *
coverage save priority_enc_tb.ucdb -onexit

add wave /priority_enc_tb/dut/priority_enc_SVA_inst/a2 /priority_enc_tb/dut/priority_enc_SVA_inst/a4 /priority_enc_tb/dut/priority_enc_SVA_inst/a5 /priority_enc_tb/dut/priority_enc_SVA_inst/a6 /priority_enc_tb/dut/priority_enc_SVA_inst/a1 /priority_enc_tb/dut/priority_enc_SVA_inst/a3
run -all