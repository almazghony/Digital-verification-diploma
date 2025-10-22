////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Interface
// 
////////////////////////////////////////////////////////////////////////////////
interface shift_reg_if (clk);
  input clk;
  logic reset;
  logic serial_in, direction, mode;
  logic [5:0] datain, dataout;
endinterface : shift_reg_if