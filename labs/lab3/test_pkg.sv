package test_pkg;
    typedef enum {ADD, SUB, MULT, DIV} opcode_e;

    class transaction;
        rand opcode_e opcode;
        rand byte operand1;
        rand byte operand2;
        bit clk;
        covergroup COVCODE @(posedge clk);
            cp1: coverpoint operand1 {
                bins max_neg = {-128};
                bins max_pos = {127};
                bins zero = {0};
                bins misc = default;
            }
            cp2: coverpoint opcode {
                bins add_sub = {ADD, SUB};
                bins add_sub2 = (ADD => SUB);
                illegal_bins no_div = {DIV};
            }
            cp3: cross cp1, cp2 {
                option.weight = 5;
                option.cross_auto_bin_max = 0;

                bins x1 = binsof(cp1.max_pos) && binsof(cp2.add_sub);
                bins x2 = binsof(cp1.max_neg) && binsof(cp2.add_sub);
            }
        endgroup

        function new();
            COVCODE = new();
        endfunction
    endclass
endpackage