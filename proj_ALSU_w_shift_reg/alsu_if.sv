import shared_pkg::*;

interface alsu_if(input clk);

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    logic signed [2:0]  A;
    logic signed [2:0]  B;
    logic               cin;
    logic               serial_in;
    logic               red_op_A;
    logic               red_op_B;
    opcode_e            opcode;
    logic               bypass_A;
    logic               bypass_B;
    logic               rst;
    logic               direction;
    logic        [15:0] leds;
    logic signed [5:0]  out;
    
endinterface


