package scoreboard_pkg;
    import shared_pkg::*;
    import transaction_pkg::*;

    class FIFO_scoreboard;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        logic  [FIFO_WIDTH-1:0] data_out_ref;
        logic full_ref;
        logic almostfull_ref;
        logic empty_ref;
        logic almostempty_ref;
        logic overflow_ref;
        logic underflow_ref;
        logic wr_ack_ref;

        logic [FIFO_WIDTH - 1:0] mem_ref [$];

        function void check_data(FIFO_transaction F_txn);
            reference_model(F_txn);
            if(F_txn.data_out != data_out_ref) begin
                $display("%t ERROR: data_out: %h, Expected: %h", $time(), F_txn.data_out, data_out_ref);
                data_out_error_count++;
            end
            else data_out_correct_count++;

            
            if(F_txn.full != full_ref) begin
                $display("%t ERROR: full = %h Expected: %h", $time(), F_txn.full, full_ref);
                full_error_count++;
            end
            else full_correct_count++;

            
            if(F_txn.almostfull != almostfull_ref) begin
                $display("%t ERROR: almostfull = %h, Expected = %h", $time(), F_txn.almostfull, almostfull_ref);
                almostfull_error_count++;
            end
            else almostfull_correct_count++;

            
            if(F_txn.empty != empty_ref) begin
                $display("%t ERROR: empty = %h, Expected = %h", $time(), F_txn.empty, empty_ref);
                empty_error_count++;
            end
            else empty_correct_count++;

            
            if(F_txn.almostempty != almostempty_ref) begin
                $display("%t ERROR: almostempty = %h, Expected = %h", $time(), F_txn.almostempty, almostempty_ref);
                almostempty_error_count++;
            end
            else almostempty_correct_count++;

            
            if(F_txn.overflow != overflow_ref) begin
                $display("%t ERROR: overflow = %h, Expected = %h", $time(), F_txn.overflow, overflow_ref);
                overflow_error_count++;
            end
            else overflow_correct_count++;

            
            if(F_txn.underflow != underflow_ref) begin
                $display("%t ERROR: underflow = %h, Expected = %h", $time(), F_txn.underflow, underflow_ref);
                underflow_error_count++;
            end
            else underflow_correct_count++;

            
            if(F_txn.wr_ack != wr_ack_ref) begin
                $display("%t ERROR: wr_ack = %h, Expected = %h", $time(), F_txn.wr_ack, wr_ack_ref);
                wr_ack_error_count++;
            end
            else wr_ack_correct_count++;
        endfunction


        function void reference_model(FIFO_transaction F_txn);
            //rst_n
            if(!F_txn.rst_n) begin           
                full_ref = 0;
                almostfull_ref = 0;
                empty_ref = 1;
                almostempty_ref = 0;
                overflow_ref = 0;
                underflow_ref = 0;
                wr_ack_ref = 0;
                count_ref = 0;
                mem_ref.delete();
            end
            else begin
                //write
                if(F_txn.wr_en && !full_ref) begin
                    mem_ref.push_back(F_txn.data_in);
                    wr_ack_ref = 1;
                end
                else wr_ack_ref = 0;
            
                //read
                if(F_txn.rd_en && !empty_ref)
                    data_out_ref = mem_ref.pop_front();
                    

                //overflow and underflow
                if(full_ref && F_txn.wr_en) overflow_ref = 1;
                else overflow_ref = 0;

                if(empty_ref && F_txn.rd_en) underflow_ref = 1;
                else underflow_ref = 0;


                //counter
                if(F_txn.wr_en && !full_ref)
                    count_ref++;
                
                if(F_txn.rd_en && !empty_ref)
                    count_ref--;


                //full/empty 
                if(count_ref == FIFO_DEPTH) full_ref = 1;
                else full_ref = 0;

                if(count_ref == 0) empty_ref = 1;
                else empty_ref = 0;

                if(count_ref == FIFO_DEPTH-1) almostfull_ref = 1;
                else almostfull_ref = 0;

                if(count_ref == 1) almostempty_ref = 1;
                else almostempty_ref = 0;
            end
        endfunction
    endclass
endpackage

