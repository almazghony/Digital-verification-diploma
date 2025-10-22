module WRAPPER (wrapper_if.DUT wrapperif);

wire [9:0] rx_data_din;
wire       rx_valid;
wire       tx_valid;
wire       tx_ref;
wire [7:0] tx_data_dout;
wire [7:0] tx_data_dout_ref;

RAM    ram_dut   (rx_data_din, wrapperif.clk, wrapperif.rst_n, rx_valid, tx_data_dout, tx_valid);
RAM_REF ram_ref(rx_data_din, wrapperif.clk, wrapperif.rst_n, rx_valid, tx_data_dout_ref, tx_valid_ref);

rst_as  : assert property (@(posedge wrapperif.clk) (~wrapperif.rst_n) |=> (~wrapperif.MISO));
rst_cov : cover  property (@(posedge wrapperif.clk) (~wrapperif.rst_n) |=> (~wrapperif.MISO));

MISO_as  : assert property (@(posedge wrapperif.clk) disable iff(~wrapperif.rst_n) (rx_data_din[9:8] != 2'b11) |=> $stable(wrapperif.MISO));
MISO_cov : cover  property (@(posedge wrapperif.clk) disable iff(~wrapperif.rst_n) (rx_data_din[9:8] != 2'b11) |=> $stable(wrapperif.MISO));
endmodule

