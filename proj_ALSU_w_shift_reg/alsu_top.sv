import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_test_pkg::*;

module top();

    bit clk;
    always #1 clk = ~clk;

    alsu_if alsuif(clk);
    sr_if srif();

    ALSU dut(alsuif);

    assign srif.serial_in = dut.serial_in_reg;
    assign srif.direction = dut.direction_reg;
    assign srif.mode = dut.mode;
    assign srif.datain = alsuif.out;
    assign srif.dataout = dut.sr_dataout;

    bind ALSU SVA SVA_inst(alsuif);
    
    initial begin
        uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "ALSU_VIF", alsuif);
        uvm_config_db#(virtual sr_if)::set(null, "uvm_test_top", "SR_VIF", srif);
        run_test("alsu_test");
    end
endmodule


