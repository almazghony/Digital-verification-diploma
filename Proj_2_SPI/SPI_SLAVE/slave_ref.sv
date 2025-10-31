module SLAVE_REF (slave_if.REF slaveif);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;


(* fsm_encoding = "sequential" *)
reg [2:0]cs,ns;
reg READ_FLAG;
reg [3:0] count;
reg [7:0] MISO_BUS;
reg [9:0] MOSI_BUS;
always@(posedge slaveif.clk)begin
    if(~slaveif.rst_n)begin
        cs<=IDLE;
    end
    else
        cs<=ns;
    end

always@(*)begin
    case (cs)
    IDLE : begin
        if(slaveif.SS_n==0)
            ns=CHK_CMD;
        else
            ns=IDLE;
    end
    CHK_CMD : begin
        if(slaveif.SS_n)
        ns=IDLE;
        else if(slaveif.SS_n==0&&slaveif.MOSI==0)begin
            ns=WRITE;
        end
        else if (slaveif.SS_n==0&&slaveif.MOSI==1&&READ_FLAG==0)begin
            ns=READ_ADD;

        end

        else if(slaveif.SS_n==0&&slaveif.MOSI==1&&READ_FLAG==1)begin
            ns=READ_DATA;
        end
        else
            ns=CHK_CMD;
        end
    WRITE : begin
        if(slaveif.SS_n)
            ns=IDLE;
        else
            ns=WRITE;
        end
    READ_ADD : begin
        if(slaveif.SS_n)
            ns=IDLE;
        else
            ns=READ_ADD; 
        end
    READ_DATA : begin
        if(slaveif.SS_n)
            ns=IDLE;
        else
            ns=READ_DATA;
    end
    endcase
end
   
always@(posedge slaveif.clk)begin
        if(~slaveif.rst_n)begin
            count<=10;
            slaveif.rx_valid_ref<=0;
            slaveif.rx_data_ref<=0;
            slaveif.MISO_ref<=0;
            READ_FLAG<=0;
            MISO_BUS<=0;
            MOSI_BUS<=0;
        end
        else begin
        case(cs)
            IDLE : begin
                count<=10;
                slaveif.rx_valid_ref<=0;
                slaveif.MISO_ref<=0;
                MOSI_BUS<=0;
                MISO_BUS<=0;
            end
        
            WRITE : begin
                if(count>0)begin
                    MOSI_BUS<={MOSI_BUS[9:0],slaveif.MOSI};
                    slaveif.rx_valid_ref<=0;
                    count<=count-1;
                end
                else  begin
                    slaveif.rx_data_ref<=MOSI_BUS;
                    slaveif.rx_valid_ref<=1;
                end
            end
            READ_ADD : begin
                if(count>0)begin
                    MOSI_BUS<={MOSI_BUS[9:0],slaveif.MOSI};
                    slaveif.rx_valid_ref<=0;
                    count<=count-1;
                end
                else begin
                    slaveif.rx_data_ref<=MOSI_BUS;
                    slaveif.rx_valid_ref<=1;
                    READ_FLAG<=1;
                end
            end

            READ_DATA : begin
                if (slaveif.tx_valid) begin
                    MISO_BUS<=slaveif.tx_data;
                    if (count > 0) begin
                        slaveif.MISO_ref <= MISO_BUS[count-1];
                        count <= count - 1;
                    end
                    else begin
                        READ_FLAG <= 0;
                        slaveif.rx_valid_ref <= 0;
                    end
                end
                else begin
                    if (count > 0) begin
                        MOSI_BUS[count-1] <= slaveif.MOSI;
                        count <= count - 1;
                    end
                    else begin
                        slaveif.rx_valid_ref <= 1;
                        slaveif.rx_data_ref <= MOSI_BUS;
                        count <= 8;
                    end
                end
            end
endcase
        end
end
endmodule