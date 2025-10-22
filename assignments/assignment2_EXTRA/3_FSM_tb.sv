import FSM_pkg::*;

module FSM_010_tb();
    logic clk;
    logic rst;
    logic x;
    logic y;
    logic [9:0]users_count;

    logic y_exp;
    logic [9:0]users_count_exp;

    integer correct_count, error_count;

    fsm_transaction my_input;

    FSM_010 dut(.*);
    FSM_010_golden golden(clk, rst, x, y_exp, users_count_exp);

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        correct_count = 0;
        error_count = 0;
        x = 0;

        //reset_test
        rst   = 1;
        check_result();

        //randomize test
        my_input = new();
        repeat(10000) begin
            assert(my_input.randomize());
            rst = my_input.rst;
            x = my_input.x;
            check_result();
        end

        $display("*** ERROR count: %0d, CORRECT count: %0d", error_count, correct_count);
        $stop;  
    end

    task check_result();
        @(negedge clk);
        if(y != y_exp || users_count != users_count_exp) begin
            $display("*** ERROR! at time %0t, y = %0d, Expected = %0d***",
                $time, y, y_exp);
            error_count++;
        end
        else
            correct_count++;
    
    endtask

endmodule