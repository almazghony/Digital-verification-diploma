////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();

    logic clk;
    initial clk = 0;
    always #1 clk = ~clk;

    shift_reg_if intrf(clk);
    shift_reg DUT(clk, intrf.reset, intrf.serial_in, intrf.direction, intrf.mode, intrf.datain, intrf.dataout);

    initial begin
      uvm_config_db #(virtual shift_reg_if)::set(null, "uvm_test_top", "SHIFT_IF", intrf);
      run_test("shift_reg_test");
    end
endmodule