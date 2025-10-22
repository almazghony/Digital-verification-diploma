package shared_pkg;
    bit test_finished;

    event trigg;
    
    int count_ref;
    integer data_out_error_count, data_out_correct_count;
    integer full_error_count, full_correct_count;
    integer almostfull_error_count, almostfull_correct_count;
    integer empty_error_count, empty_correct_count;
    integer almostempty_error_count, almostempty_correct_count;
    integer wr_ack_error_count, wr_ack_correct_count;
    integer overflow_error_count, overflow_correct_count;
    integer underflow_error_count, underflow_correct_count;

endpackage



