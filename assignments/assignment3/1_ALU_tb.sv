import ALU_pkg::*;

module ALU_tb();
    transaction obj = new();
    byte operand1;
    byte operand2;
    opcode_e opcode;
    byte out;
    byte out_expected;
    bit clk, rst;

    integer correct_count, error_count;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            obj.clk = clk;
        end
    end

    ALU DUT(operand1, operand2, clk, rst, opcode, out);

    initial begin
        correct_count = 0;
        error_count = 0;
        assert_rst();

        repeat (32) begin
            assert(obj.randomize());
            operand1 = obj.operand1;
            operand2 = obj.operand2;
            opcode   = obj.opcode;
            rst = obj.rst;
            @(negedge clk);
            golden_model();
            check_result();
        end
        $display("Correct count: %0d, error count: %0d", correct_count, error_count);
        $stop();
    end

    task golden_model();
         if (rst)
            out_expected = 0;
        else begin
            case (opcode)
                ADD: out_expected = operand1 + operand2;
                SUB: out_expected = operand1 - operand2;
                MULT:out_expected = operand1 * operand2;
                DIV: out_expected = operand1 / operand2;
            endcase
        end
    endtask

    task assert_rst();
        rst = 1;
        @(negedge clk);
        check_result();
        rst = 0;
    endtask

    task check_result();
        if (out !== out_expected) begin
            $display("*** %t : Test failed! expected %0d, got %0d ***", $time, out_expected, out);
            error_count++;
        end else 
           correct_count++;
    endtask

endmodule

