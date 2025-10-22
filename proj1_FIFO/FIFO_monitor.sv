import transaction_pkg::*;
import coverage_pkg::*;
import scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_monitor(FIFO_if intrf);
    FIFO_transaction trans;
    FIFO_coverage cov;
    FIFO_scoreboard score;

    initial begin
        trans = new();
        cov = new();
        score = new();
        
        forever begin
            wait(trigg.triggered);
            @(negedge intrf.clk)
            trans.data_in = intrf.data_in;
            trans.rst_n = intrf.rst_n;
            trans.wr_en = intrf.wr_en;
            trans.rd_en = intrf.rd_en;
            trans.data_out = intrf.data_out;
            trans.wr_ack = intrf.wr_ack;
            trans.overflow = intrf.overflow;
            trans.full = intrf.full;
            trans.empty = intrf.empty;
            trans.almostfull = intrf.almostfull;
            trans.almostempty = intrf.almostempty;
            trans.underflow = intrf.underflow;

            fork
                begin
                    cov.sample_data(trans);
                end

                begin
                    score.check_data(trans);
                end
            join

            if(test_finished) begin
                $display("================DATA OUT===================");
                $display("==== Error count: %0d", data_out_error_count);
                $display("==== Correct count: %0d", data_out_correct_count);
                $display("================FULL===================");
                $display("==== Error count: %0d ", full_error_count);
                $display("==== Correct count: %0d", full_correct_count);
                $display("================ALMOST FULL===================");
                $display("==== Error count: %0d", almostfull_error_count);
                $display("==== Correct count: %0d", almostfull_correct_count);
                $display("================EMPTY===================");
                $display("==== Error count: %0d", empty_error_count);
                $display("==== Correct count: %0d", empty_correct_count);
                $display("================ALMOST EMPTY===================");
                $display("==== Error count: %0d", almostempty_error_count);
                $display("==== Correct count: %0d", almostempty_correct_count);
                $display("================OVERFLOW===================");
                $display("==== Error count: %0d", overflow_error_count);
                $display("==== Correct count: %0d", overflow_correct_count);
                $display("================UNDERFLOW===================");
                $display("==== Error count: %0d", underflow_error_count);
                $display("==== Correct count: %0d", underflow_correct_count);
                $display("================ACKNOWLEDGE===================");
                $display("==== Error count: %0d", wr_ack_error_count);
                $display("==== Correct count: %0d", wr_ack_correct_count);
                $stop;
            end
        end
    end
endmodule