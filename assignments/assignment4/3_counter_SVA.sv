module counter_SVA(counter_if.SVA intrf);

    property load_active;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (!intrf.load_n) |=> (intrf.count_out == $past(intrf.data_load));
    endproperty

    property no_load_no_cn;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (intrf.load_n && !intrf.ce) |=> (intrf.count_out == $past(intrf.count_out));
    endproperty

    property count_up;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (intrf.load_n && intrf.ce && intrf.up_down) |=> (intrf.count_out == $past(intrf.count_out)  + 1'b1);
    endproperty

    property count_down;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (intrf.load_n && intrf.ce && !intrf.up_down) |=> (intrf.count_out == $past(intrf.count_out) - 1'b1);
    endproperty

    property max_count_assert;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (intrf.count_out == 4'b1111) |-> intrf.max_count;
    endproperty

    property zero_assert;
        @(posedge intrf.clk) disable iff (!intrf.rst_n)
        (intrf.count_out == 4'b0000) |-> intrf.zero;
    endproperty



    always_comb begin
        if(!intrf.rst_n)
        async_rst: assert final (intrf.count_out == 0);
    end
    
    a1: assert property (load_active);
    a2: assert property (no_load_no_cn);
    a3: assert property (count_up);
    a4: assert property (count_down);
    a5: assert property (max_count_assert);
    a6: assert property (zero_assert);
    
    c1: cover property (load_active);
    c2: cover property (no_load_no_cn);
    c3: cover property (count_up);
    c4: cover property (count_down);
    c5: cover property (max_count_assert);
    c6: cover property (zero_assert);

endmodule

