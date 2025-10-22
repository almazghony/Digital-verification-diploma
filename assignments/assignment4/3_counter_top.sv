module counter_top();

    logic clk;

    always #1 clk = ~clk;
    initial clk = 0;

    counter_if intrf(clk);


    counter DUT(intrf);
    counter_tb TB(intrf);
    

    bind counter counter_SVA counter_SVA_inst(intrf);

endmodule