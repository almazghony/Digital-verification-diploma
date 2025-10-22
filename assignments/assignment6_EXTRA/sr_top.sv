////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import sr_test_pkg::*;

module top();

    logic clk;
    initial clk = 0;
    always #1 clk = ~clk;

    sr_if intrf(clk);
    sr DUT(clk, intrf.reset, intrf.serial_in, intrf.direction, intrf.mode, intrf.datain, intrf.dataout);

    initial begin
      uvm_config_db #(virtual sr_if)::set(null, "uvm_test_top", "SHIFT_IF", intrf);
      run_test("sr_test");
    end
endmodule