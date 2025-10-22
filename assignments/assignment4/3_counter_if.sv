interface counter_if #(parameter WIDTH = 4)(input clk);

    logic rst_n;
    logic [WIDTH-1:0] count_out;
    logic load_n;
    logic up_down;
    logic ce;
    logic [WIDTH-1:0] data_load;
    logic max_count;
    logic zero;

    modport DUT (input clk, rst_n, load_n, up_down, ce, data_load,
                 output count_out, max_count, zero);

    modport TB (output rst_n, load_n, up_down, ce, data_load,
                input count_out, max_count, zero, clk);

    modport SVA (input clk, rst_n, load_n, up_down, ce, data_load, 
            count_out, max_count, zero);

endinterface