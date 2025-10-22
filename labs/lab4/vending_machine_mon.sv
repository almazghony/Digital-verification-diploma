////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor();
initial begin
    $monitor("At time %0t, clk = %b, Q_in = %b, D_in = %b, dispense = %b, change = %b", $time, clk, Q_in, D_in, dispense, change);
end

endmodule