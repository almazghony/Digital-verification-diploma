module adder_tb();
    bit signed [3:0]   A;
    bit signed [3:0]   B;
    bit signed [4:0]   C;
    logic       clk;
    logic       rst;

    integer error_count, correct_count;

    localparam MAXPOS = 4'b0111;
    localparam MAXNEG = 4'b1000;

    adder dut(clk, rst, A, B, C);

    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end 

    initial begin
        rst = 1;
        A = 0;
        B = 0;
        error_count = 0;
        correct_count = 0;
        assert_reset();

        //TEST1
        A = MAXPOS;
        B = MAXPOS;
        check_result(14);

        //TEST2
        A = MAXPOS;
        B = MAXNEG;
        check_result(-1);

        //TEST3
        A = MAXNEG;
        B = MAXPOS;
        check_result(-1);

        //TEST4
        A = MAXNEG;
        B = MAXNEG;
        check_result(-16);

        //TEST5
        A = 0;
        B = MAXPOS;
        check_result(7);

        //TEST6
        A = MAXPOS;
        B = 0;
        check_result(7);

        //TEST7
        A = 0;
        B = 0;
        check_result(0);

        //TEST8
        A = 0;
        B = MAXNEG;
        check_result(-8);

        //TEST9
        A = MAXNEG;
        B = 0;
        check_result(-8);

        $display("errors: %d, success: %d", error_count, correct_count);
        $stop;
    end


    task assert_reset();
        rst = 1;
        check_result(0);
        rst = 0;
    endtask

    task check_result(logic signed [4:0] C_exp);
        @(negedge clk);
        if(C != C_exp) begin
            $display ("*** ERROR, A = %d, B = %d, C = %d", A, B, C, );
            error_count = error_count + 1;
        end
        else
            correct_count = correct_count + 1;
    endtask
endmodule