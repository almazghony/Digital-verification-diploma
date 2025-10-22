
module SVA();

    property p1;
    @(posedge clk) disable iff (rst)
        $onehot(cs);
    endproperty

    property p2;
    @(posedge clk) disable iff (rst)
        (cs == IDLE && $rose(get_data)) |=> (cs == GEN_BLK_ADDR [*64] ##1 cs == WAITO);
    endproperty


    a1: assert property (p1);
    a2: assert property (p2);

    c1: cover property (p1);
    c2: cover property (p2);

endmodule
