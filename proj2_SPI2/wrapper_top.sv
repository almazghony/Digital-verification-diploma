import uvm_pkg::*;
import wrapper_test_pkg::*;
module wrapper_top();
    bit clk;

    always #1 clk = ~clk;

    wrapper_if wrapperif(clk);
    slave_if slaveif(clk);
    ram_if ramif(clk);
    WRAPPER dut(wrapperif);
    SLAVE slave_dut (slaveif);
    SLAVE_REF slave_ref (slaveif);

    assign wrapperif.MISO = slaveif.MISO;

    assign slaveif.MOSI = wrapperif.MOSI;
    assign slaveif.SS_n = wrapperif.SS_n;
    assign slaveif.rst_n = wrapperif.rst_n;
    assign slaveif.tx_valid = dut.tx_valid;
    assign slaveif.tx_data = dut.tx_data_dout;
    
    assign ramif.din = dut.ram_dut.din;
    assign ramif.rst_n = dut.ram_dut.rst_n;
    assign ramif.rx_valid = dut.ram_dut.rx_valid;
    assign ramif.clk = dut.ram_dut.clk;
    assign ramif.dout = dut.ram_dut.dout;
    assign ramif.tx_valid = dut.ram_dut.tx_valid;
    assign ramif.dout_ref = dut.ram_ref.dout;
    assign ramif.tx_valid_ref = dut.ram_ref.tx_valid;

    assign dut.rx_data_din = slaveif.rx_data;
    assign dut.rx_valid = slaveif.rx_valid;


    initial begin
        uvm_config_db #(virtual wrapper_if)::set(null, "uvm_test_top", "WRAPPER VIF", wrapperif);
        uvm_config_db #(virtual slave_if)::set(null, "uvm_test_top", "SLAVE VIF", slaveif);
        uvm_config_db #(virtual ram_if)::set(null, "uvm_test_top", "RAM VIF", ramif);
        run_test ("wrapper_test");
    end
endmodule