package transaction_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    class FIFO_transaction;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic wr_en;
        rand logic rd_en;
        rand logic rst_n;
        logic [FIFO_WIDTH-1:0] data_out;
        logic full;
        logic almostfull;
        logic empty;
        logic almostempty;
        logic overflow;
        logic underflow;
        logic wr_ack;
        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        function new(int RD_EN_ON_DIST = 30, int WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

        constraint reset_c {rst_n dist {0 := 1, 1 := 9};}
        constraint wr_en_c {wr_en dist {1 := WR_EN_ON_DIST, 0 := (100 - WR_EN_ON_DIST)};}
        constraint rd_en_c {rd_en dist {1 := RD_EN_ON_DIST, 0 := (100 - RD_EN_ON_DIST)};}
    endclass
endpackage

