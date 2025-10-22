module FIFO_top();

    bit clk;
    always #1 clk = ~clk;

    FIFO_if intrf(clk);
    FIFO dut(intrf);
    FIFO_TB TB(intrf);
    FIFO_monitor mon(intrf);
endmodule