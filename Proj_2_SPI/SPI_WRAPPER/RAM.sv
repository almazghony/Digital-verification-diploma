module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);

input      [9:0] din;
input            clk, rst_n, rx_valid;

output reg [7:0] dout;
output reg       tx_valid;

reg [7:0] MEM [255:0];

reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge clk) begin
    if (~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else begin //<<<<<<<<<<<<<<
        if (rx_valid) begin
            case (din[9:8])
                2'b00 : Wr_Addr <= din[7:0];
                2'b01 : MEM[Wr_Addr] <= din[7:0];
                2'b10 : Rd_Addr <= din[7:0];
                2'b11 : dout <= MEM[Rd_Addr]; //<<<<<<<<<<<<<<
                default : dout <= 0;
            endcase
        end
        
        tx_valid <= (din[9] && din[8] && rx_valid)? 1'b1 : 1'b0;
    end //<<<<<<<<<<<<<<<
end

    
    property rst_p;
        @(posedge clk)
        (!rst_n) |-> ##1  (!dout && !tx_valid);
    endproperty

    property tx_valid_p1;
        @(posedge clk) disable iff(!rst_n)
        (din[9:8] != 2'b11) |-> ##1 (tx_valid == 1'b0);
    endproperty

    property tx_valid_p2;
        @(posedge clk) disable iff(!rst_n)
        (din[9:8] == 2'b11 && rx_valid) |-> ##1 tx_valid ##[1:$] $fell(tx_valid);
    endproperty

    property wr_addr_p;
        @(negedge clk) disable iff(!rst_n)
        (din[9:8] == 2'b00) |-> ##[1:$] (din[9:8] == 2'b01);
    endproperty

    property rd_addr_p;
        @(negedge clk) disable iff(!rst_n)
        (din[9:8] == 2'b10) |-> ##[1:$] (din[9:8] == 2'b11);
    endproperty

    a1: assert property(rst_p);
    a2: assert property(tx_valid_p1);
    a3: assert property(tx_valid_p2);
    a4: assert property(wr_addr_p);
    a5: assert property(rd_addr_p);

    c1: cover property(rst_p);
    c2: cover property(tx_valid_p1);
    c3: cover property(tx_valid_p2);
    c4: cover property(wr_addr_p);
    c5: cover property(rd_addr_p);

endmodule