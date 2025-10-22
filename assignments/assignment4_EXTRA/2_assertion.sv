
module SVA();
    property p1;
    @(posedge clk) disable iff (rst)
        $rose(request) |-> ##[2:5] grant;
    endproperty


    property p2;
    @(posedge clk) disable iff (rst)
        $rose(grant) |-> $fell(frame) && $fell(irdy);
    endproperty

    property p3;
    @(posedge clk) disable iff (rst)
        $rose(frame) && $rose(irdy) |-> ##1 $fell(grant);
    endproperty

    a1: assert property(p_request_to_grant);
    a2: assert property(p_grant_ack);
    a3: assert property(p_complete_transaction);

    c1: cover property(p_request_to_grant);
    c2: cover property(p_grant_ack);
    c3: cover property(p_complete_transaction);

endmodule

