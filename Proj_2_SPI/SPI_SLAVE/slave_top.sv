import slave_test_pkg::*;
import uvm_pkg::*;

module slave_top();

    bit clk;
    always #1 clk = ~clk;

    slave_if slaveif(clk);
    SLAVE slave_dut(slaveif);
    SLAVE_REF slave_ref(slaveif);
    


    initial begin
        uvm_config_db #(virtual slave_if)::set(null, "uvm_test_top", "SLAVE_VIF", slaveif);
        run_test("slave_test");
    end
endmodule