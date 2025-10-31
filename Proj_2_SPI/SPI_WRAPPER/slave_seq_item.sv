package slave_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(slave_seq_item)
             logic       MOSI;
        rand logic       rst_n;
        rand logic       SS_n;
        rand logic       tx_valid;
        rand logic [7:0] tx_data;
             logic [9:0] rx_data;
             logic       rx_valid;
             logic       MISO;

             logic [9:0] rx_data_ref;
             logic       rx_valid_ref;
             logic       MISO_ref;

        rand logic [10:0] mosi_data = 0;

        int counter;

        function new(string name = "slave_seq_item");
            super.new(name);
        endfunction

        constraint rst_c {
            rst_n dist{0 := 1, 1 := 99};
        }

        constraint SS_c {
            (mosi_data[9:8] == 2'b11) -> SS_n == (counter == 23);
            (mosi_data[9:8] != 2'b11) -> SS_n == (counter == 13);
        }

        constraint valid_first_three_c {
            mosi_data[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
        }

        constraint tx_valid_c {
            tx_valid == (mosi_data[9:8] == 2'b11);
        }

        function void pre_randomize();
            if((counter == 22)
                || counter == 12 && mosi_data[9:8] != 2'b11)
                counter = 0;
            else 
                counter++;
        endfunction

        
        function void post_randomize();
            MOSI = mosi_data[10 - counter%11];
        endfunction


        function string convert2string();
            return $sformatf("%s MOSI: %d, rst_n: %d, SS_n: %d, tx_valid: %d, tx_data: %d, rx_data: %d, rx_valid: %d MISO: %d", 
                            super.convert2string(), MOSI, rst_n, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("MOSI: %d, rst_n: %d, SS_n: %d, tx_valid: %d, tx_data: %d", 
                            MOSI, rst_n, SS_n, tx_valid, tx_data);
        endfunction

    endclass
endpackage