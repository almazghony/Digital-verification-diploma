////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_sva();
    property p1;
        @(posedge clk) D_in |-> dispense
    endproperty
    property p2;
        @(posedge clk) $rose(Q_in) |-> ##2 dispense && change
    endproperty
    property p2;
        @(posedge clk) Q_in |-> ##2 !change
    endproperty
endmodule