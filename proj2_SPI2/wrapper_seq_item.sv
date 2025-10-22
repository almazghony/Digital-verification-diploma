package wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(wrapper_seq_item)
        rand bit rst_n;
        
        rand logic SS_n;
        rand logic MOSI;
        logic MISO;

        rand logic [10:0] mosi_data = 0;
        logic [10:0] prev_mosi_data = 0;

        int counter;

        function new(string name = "wrapper_seq_item");
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

        constraint wr_seq_c {
            mosi_data[10:8] inside {3'b000, 3'b001};
        }
            
        constraint rd_seq_c {
            mosi_data[10:8] inside {3'b110, 3'b111};
            if (prev_mosi_data[9:8] == 2'b10)
                mosi_data[9:8] == 2'b11;
            else if (prev_mosi_data[9:8] == 2'b11)
                mosi_data[9:8] == 2'b10;
        }

        constraint rd_wr_seq_c {    
                if (prev_mosi_data[9:8] == 2'b00)
                    mosi_data[9:8] inside { 2'b00, 2'b01};

                else if(prev_mosi_data[9:8] == 2'b01)
                    mosi_data[9:8] dist {2'b10 := 6, 2'b00 := 4};

                else if (prev_mosi_data[9:8] == 2'b10)
                    mosi_data[9:8] == 2'b11;
            
                else // 11
                    mosi_data[9:8] dist {2'b10 := 4, 2'b00 := 6};
        }

        function void pre_randomize();
            if((counter == 23)
                || counter == 13 && mosi_data[9:8] != 2'b11)
                counter = 0;
            else 
                counter++;
        endfunction

        function void post_randomize();
            prev_mosi_data = mosi_data;
            MOSI = mosi_data[10 - counter%11];
        endfunction


        function string convert2string();
            return $sformatf("%s rst_n = %0b, SS_n = %0b, MOSI = %0b, MISO = %0b", 
                            super.convert2string(), rst_n, SS_n, MOSI, MISO);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n = %0b, SS_n = %0b, MOSI = %0b", rst_n, SS_n, MOSI);
        endfunction
    endclass
endpackage