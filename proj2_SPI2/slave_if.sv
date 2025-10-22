interface slave_if(input bit clk);
    logic       MOSI;
    logic       rst_n;
    logic       SS_n;
    logic       tx_valid;
    logic [7:0] tx_data;
    logic [9:0] rx_data;
    logic       rx_valid;
    logic       MISO;
    logic       rx_valid_ref;
    logic [9:0] rx_data_ref;
    logic       MISO_ref;

    modport DUT (
        input  clk, MOSI, rst_n, SS_n, tx_valid, tx_data,
        output rx_valid, MISO, rx_data
    );

    modport REF (
        input  clk, MOSI, rst_n, SS_n, tx_valid, tx_data,
        output rx_valid_ref, MISO_ref, rx_data_ref
    );

endinterface