import ram_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module ram_top();

    logic clk;
    initial clk = 0;
    always #1 clk = ~clk;

    ram_if ramif(clk);
    RAM ram_dut(ramif.din, clk, ramif.rst_n, ramif.rx_valid, ramif.dout, ramif.tx_valid);
    RAM_REF ram_ref(ramif.din, clk, ramif.rst_n, ramif.rx_valid, ramif.dout_ref, ramif.tx_valid_ref);
    

    initial begin
        uvm_config_db #(virtual ram_if)::set(null, "uvm_test_top", "RAM_VIF", ramif);
        run_test("ram_test");
    end
endmodule