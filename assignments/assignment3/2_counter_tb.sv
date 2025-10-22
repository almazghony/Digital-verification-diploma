import counter_pkg::*;

module counter_tb();
    parameter WIDTH = 4;
    bit             clk;
    bit             rst_n;
    bit             load_n;
    bit             up_down;
    bit             ce;
    bit [WIDTH-1:0] data_load;

    bit [WIDTH-1:0] count_out;
    bit             max_count;
    bit             zero;

    bit [WIDTH-1:0] count_out_exp;
    bit             max_count_exp;
    bit             zero_exp;

    rand_stimuls my_inputs;
    integer error_count, correct_count;

    counter dut(.*);

    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end

    initial begin
        error_count = 0;
        correct_count = 0;
        load_n = 0;
        up_down = 0;
        ce = 0;
        data_load = 0;

        //reset test
        rst_n = 0;
        @(negedge clk);
        check_result();
        
        //randomized test
        my_inputs = new(count_out, clk);
        for(int i = 0; i < 5000; i++) begin
            assert(my_inputs.randomize());
            rst_n = my_inputs.rst_n;
            load_n = my_inputs.load_n;
            up_down = my_inputs.up_down;
            ce = my_inputs.ce;
            data_load = my_inputs.data_load;

            check_result();
        end
        $display("*** ERROR count: %0d, CORRECT count: %0d", error_count, correct_count);
        $stop;
    end


    task check_result();
        @(negedge clk);
        exp_out(); //calculate the correct outputs
        if(count_out != count_out_exp || max_count != max_count_exp || zero != zero_exp) begin
            $display("*** ERROR! at time %0t, output = %0d, max_count = %0d, zero = %0d | EXPECTED : %0d, %0d, %0d ***",
                $time, count_out, max_count, zero, count_out_exp, max_count_exp, zero_exp);
            error_count++;
        end
        else
            correct_count++;
    endtask


    task exp_out();
        if (!rst_n) begin
            count_out_exp = 0;
            max_count_exp = 0;
            zero_exp = 1;
        end
        else if(!load_n)
            count_out_exp = data_load;
        else if(ce)
            if(up_down)
                count_out_exp++;
            else    
                count_out_exp--;

        if(count_out_exp == {WIDTH{1'b1}})
            max_count_exp = 1;
        else
            max_count_exp = 0;

        if(count_out_exp == 0)
            zero_exp = 1;
        else
            zero_exp = 0;
    endtask
endmodule

