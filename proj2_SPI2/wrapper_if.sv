interface wrapper_if(input bit clk);
    logic MOSI;
    logic SS_n;
    logic rst_n;
    logic MISO;

    modport DUT(input MOSI, SS_n, clk, rst_n,
                output MISO);
endinterface

