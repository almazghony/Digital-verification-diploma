////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_top(input clk);
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end
    vending_machine dut();
endmodule
