module struct_e();

    typedef bit [6:0] ubyte_t;

    typedef struct {
        ubyte_t header;
        ubyte_t cmd;
        ubyte_t data;
        ubyte_t crc;
    } packet;

    packet my_packet;

    initial begin
        my_packet.header = 7'h5A;
        $display("my_packet.header = %h", my_packet.header);
        $display("my_packet.header = %p", my_packet);
    end
endmodule

