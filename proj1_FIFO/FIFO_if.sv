interface FIFO_if(input clk);
    
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    logic [FIFO_WIDTH-1:0]  data_in;
    logic                   rst_n;
    logic                   wr_en; 
    logic                   rd_en;
    logic [FIFO_WIDTH-1:0]  data_out;
    logic                   wr_ack;
    logic                   overflow;
    logic                   full;
    logic                   empty;
    logic                   almostfull;
    logic                   almostempty;
    logic                   underflow;

endinterface 

