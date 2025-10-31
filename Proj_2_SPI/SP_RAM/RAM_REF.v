module RAM_REF #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
    input       [9:0]   din,
    input               clk,
    input               rst_n,
    input               rx_valid,
    output reg  [7:0]   dout,
    output reg          tx_valid
);
    reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

    reg [ADDR_SIZE-1:0] write_address;
    reg [ADDR_SIZE-1:0] read_address;

    always @(posedge clk) begin
        if(~rst_n) begin
            dout            <= 0;
            tx_valid        <= 0;
            write_address   <= 0;
            read_address    <= 0;
        end
        else begin
            tx_valid <= 0;
            if(rx_valid) begin
                case (din[9:8])
                    2'b00 : write_address <= din[7:0];
                    2'b01 : mem[write_address] <= din [7:0];
                    2'b10 : read_address <= din[7:0];
                    2'b11 : begin
                        tx_valid <= 1;
                        dout <= mem[read_address];
                    end
                endcase
            end
        end
    end
endmodule