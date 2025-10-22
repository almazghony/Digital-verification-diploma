module SLAVE (slave_if.DUT slaveif);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;


reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;
reg [7:0] MISO_BUS;
reg [9:0] MOSI_BUS;

always @(posedge slaveif.clk) begin
    if (~slaveif.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (slaveif.SS_n)
                ns = IDLE;
            else            
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (slaveif.SS_n)
                ns = IDLE;
            else begin
                if (~slaveif.MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA;    //read data after recive address 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (slaveif.SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (slaveif.SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (slaveif.SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge  slaveif.clk) begin
    if (~slaveif.rst_n) begin 
        slaveif.rx_valid <= 0;
        slaveif.rx_data <= 0;
        received_address <= 0;
        slaveif.MISO <= 0;
        MOSI_BUS<=0;
        MISO_BUS<=0; 
    end
    else begin
        case (cs)
            IDLE : begin
                slaveif.rx_valid <= 0;
                slaveif.MISO <= 0;         // miso not set to zero in idle
                MOSI_BUS<=0;
                MISO_BUS<=0; 
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    MOSI_BUS[counter-1] <= slaveif.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    slaveif.rx_valid <= 1;
                    slaveif.rx_data<=MOSI_BUS;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    MOSI_BUS[counter-1] <= slaveif.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    slaveif.rx_valid <= 1;
                    received_address <= 1;
                    slaveif.rx_data<=MOSI_BUS;
                end
            end
            READ_DATA : begin
                if (slaveif.tx_valid) begin
                    MISO_BUS<=slaveif.tx_data;
                    if (counter > 0) begin
                        slaveif.MISO <= MISO_BUS[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                        slaveif.rx_valid <= 0; // for tx_valid to be asserted during read data
                    end
                end
                else begin
                    if (counter > 0) begin
                        MOSI_BUS[counter-1] <= slaveif.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        slaveif.rx_valid <= 1;
                        slaveif.rx_data<=MOSI_BUS;
                        counter <= 8;
                    end
                end
            end
            default: begin
                slaveif.MISO <= 0;
            end
        endcase
    end
end

/////////////////////////////////////////////////////assertions///////////////////////////////////////////////////////////////////

property asser1;
    @(posedge slaveif.clk) (~slaveif.rst_n) |=> (slaveif.rx_data == 0) && (slaveif.rx_valid == 0) && (slaveif.MISO == 0);
endproperty

property asser2;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) 
    (MOSI_BUS==3'b000 || MOSI_BUS==3'b110 || MOSI_BUS==3'b111||MOSI_BUS==3'b001) |-> ##10($rose(slaveif.rx_valid) && $rose(slaveif.SS_n)[->1]);
endproperty

property asser3;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) (cs==IDLE && !slaveif.SS_n) |-> (ns==CHK_CMD);
endproperty

property asser4;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) (cs==CHK_CMD && !slaveif.SS_n)|-> (ns==READ_DATA || ns==WRITE || ns==READ_ADD);
endproperty

property asser5;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) (cs==WRITE && slaveif.SS_n) |-> (ns==IDLE);
endproperty
property asser6;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) (cs==READ_DATA && slaveif.SS_n)|-> (ns==IDLE);
endproperty
property asser7;
    @(posedge slaveif.clk) disable iff(~slaveif.rst_n) (cs==READ_ADD && slaveif.SS_n)|-> (ns==IDLE);
endproperty

// `ifdef SIM
as1:  assert property (asser1)  else $display("ERROR1");
as2:  assert property (asser2)  else $display("ERROR2");
as3:  assert property (asser3)  else $display("ERROR3");
as4:  assert property (asser4)  else $display("ERROR4");
as5:  assert property (asser5)  else $display("ERROR5");
as6:  assert property (asser6)  else $display("ERROR6");
as7:  assert property (asser7)  else $display("ERROR7");

cov1:  cover property (asser1); 
cov2:  cover property (asser2);  
cov3:  cover property (asser3);  
cov4:  cover property (asser4);  
cov5:  cover property (asser5);
cov6:  cover property (asser6); 
cov7:  cover property (asser7);

// `endif
endmodule