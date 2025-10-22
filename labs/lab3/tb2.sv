import test_pkg::*;

module xyz();
    transaction obj = new();
    byte operand1;
    byte operand2;
    opcode_e opcode;
    byte out;
    bit clk, rst;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            obj.clk = clk;
        end
    end

    alu_seq DUT(operand1, operand2, clk, rst, opcode, out);

    initial begin
        rst = 1;
        @(negedge clk);
        rst = 0;

        repeat (32) begin
            assert(obj.randomize());
            operand1 = obj.operand1;
            operand2 = obj.operand2;
            opcode   = obj.opcode;
            @(negedge clk);
        end

        $stop();
    end

endmodule