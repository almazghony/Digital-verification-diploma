import transaction_pkg::*;
import shared_pkg::*;

module FIFO_TB (FIFO_if intrf);

    FIFO_transaction trans;
    initial begin
        data_out_error_count = 0;
        data_out_correct_count = 0;
        full_error_count = 0;
        full_correct_count = 0;
        almostfull_error_count = 0;
        almostfull_correct_count = 0;
        empty_error_count = 0;
        empty_correct_count = 0;
        almostempty_error_count = 0;
        almostempty_correct_count = 0;
        overflow_error_count = 0;
        overflow_correct_count = 0;
        underflow_error_count = 0;
        underflow_correct_count = 0;
        wr_ack_error_count = 0;
        wr_ack_correct_count = 0;
        
        trans = new();
        
        intrf.data_in = 0;
        intrf.wr_en = 0;
        intrf.rd_en = 0;

        //reset test
        intrf.rst_n = 0;
        #0; -> trigg;
        @(negedge intrf.clk);
        intrf.rst_n = 1;

        //random test
        repeat(100000) begin
            assert(trans.randomize());
            intrf.data_in = trans.data_in;
            intrf.wr_en = trans.wr_en;
            intrf.rd_en = trans.rd_en;
            intrf.rst_n = trans.rst_n;
            #0; -> trigg;
            @(negedge intrf.clk);
        end   
        test_finished = 1;
        #0; -> trigg;
    end
endmodule

