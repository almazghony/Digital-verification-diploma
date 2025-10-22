import counter_pkg::*;

module counter_tb(counter_if.TB intrf);
    rand_stimuls my_inputs;

    logic clk;
    assign clk = intrf.clk;

    initial begin

        intrf.load_n = 0;
        intrf.up_down = 0;
        intrf.ce = 0;
        intrf.data_load = 0;

        //reset test
        intrf.rst_n = 0;
        @(negedge intrf.clk);
        
        //randomized test
        my_inputs = new(intrf.count_out, clk);
        for(int i = 0; i < 5000; i++) begin
            assert(my_inputs.randomize());
            intrf.rst_n = my_inputs.rst_n;
            intrf.load_n = my_inputs.load_n;
            intrf.up_down = my_inputs.up_down;
            intrf.ce = my_inputs.ce;
            intrf.data_load = my_inputs.data_load;
            @(negedge intrf.clk);
        end
        $stop;
    end
endmodule