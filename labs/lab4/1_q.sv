a1: assert property @(posedge clk) 
    $rose(a) |-> ##1 fell(b[->1]);
endproperty

a2: assert property @(posedge clk)
    valid_signal |-> ##1 (wr_ack throughout done[->1])
endproperty

a3: assert property @(posedge clk)
    $rose(req) |=> ack[->1] ##1 !ack
endproperty
cover a1;
cover a2;
cover a3;