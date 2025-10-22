module asser_ex();
    p1: assert property @(posedge clk) 
        a |-> ##2 b;
    endproperty

    p2: assert property @(posedge clk)
        a && b |-> ##[1:3] c;
    endproperty

    sequence s11b;
        ##2 !b;
    endsequence


    property p4;
        @(posedge clk)
        $onehot(Y);
    endproperty

    property p5;
        @(posedge clk)
        !D |-> ##1 !valid;
    endproperty
endmodule