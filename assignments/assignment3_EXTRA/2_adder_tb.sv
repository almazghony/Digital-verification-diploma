import adder_pkg::*;

module adder_tb();
    bit signed [3:0]   A;
    bit signed [3:0]   B;
    bit signed [4:0]   C;
    bit       clk;
    logic     rst;

    integer error_count, correct_count;

    localparam MAXPOS = 4'b0111;
    localparam MAXNEG = 4'b1000;

    adder dut(clk, rst, A, B, C);

    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end 

    rand_input ri;

    initial begin
        ri = new(clk);
        A = 0;
        B = 0;
        error_count = 0;
        correct_count = 0;
        assert_reset();

        for (int i = 0; i < 200; i++) begin
            assert(ri.randomize());
            A = ri.A;
            B = ri.B;
            rst = ri.rst;
            check_result(A + B);
        end

        $display("errors: %d, success: %d", error_count, correct_count);
        $stop;
    end

    task assert_reset();
        rst = 1;
        check_result(0);
        rst = 0;
    endtask

    task check_result(logic signed [4:0] C_exp);
        if(rst) C_exp = 0;
        @(negedge clk);
            if(C != C_exp) begin
                $display ("*** ERROR, A = %d, B = %d, C = %d", A, B, C, );
                error_count = error_count + 1;
            end
            else
                correct_count = correct_count + 1;
    endtask

    always @(posedge clk) begin
        if(!rst) begin
            ri.cg_A.sample();
            ri.cg_B.sample();
        end   
    end
endmodule

