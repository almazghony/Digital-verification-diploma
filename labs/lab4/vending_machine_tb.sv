////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_tb();
    parameter WAIT = 0;
    parameter Q_25 = 1;
    parameter Q_50 =2;
    logic clk;
    logic Q_in;
    logic D_in;
    logic dispense;
    logic change;
	//reset and initial values for inputs
  initial begin
    rstn = 0;
    Q_in = 0;
    D_in = 0;
    #50
    rstn = 1;
    #100;
        //Test dollars
         D_in = 1; Q_in = 0; 
        //Test Quarters 
    #100 D_in = 0; Q_in = 1; 
    #100 D_in = 0; Q_in = 0;
    #10;
    $stop;
  end

endmodule
