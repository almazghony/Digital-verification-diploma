package ram_seq_item_pkg ;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_seq_item extends uvm_sequence_item;
        `uvm_object_utils(ram_seq_item);

        rand logic [9:0] din;
        rand logic       rst_n;
        rand logic       rx_valid;
             logic [7:0] dout;
             logic       tx_valid;
             logic [7:0] dout_ref;
             logic       tx_valid_ref;

             logic [9:0] prev_din = 0;

        function new(string name = "ram_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s din: %d rst_n: %d rx_valid: %d dout: %d tx_valid: %d",
                super.convert2string(), din, rst_n, rx_valid, dout, tx_valid);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("din: %d rst_n: %d rx_valid: %d",
                din, rst_n, rx_valid);
        endfunction

        constraint rst_c {
            rst_n dist {1 := 9, 0 := 1};
        }

        constraint rx_valid_c {
            rx_valid dist {1 := 9, 0 := 1};
        }


        constraint wr_seq_c {
            if (prev_din[9:8] == 2'b00)
                    din[9] == 1'b0;
        }
            
        constraint rd_seq_c {
            if (prev_din[9:8] == 2'b10)
                din[9] == 2'b11;
            else if (prev_din[9:8] == 2'b11)
                din[9] == 2'b10;
        }

        constraint rd_wr_seq_c {      
                if (prev_din[9:8] == 2'b00)
                    din[9] == 1'b0;

                else if(prev_din[9:8] == 2'b01)
                    din[9] dist {1 := 6, 0 := 4};

                else if (prev_din[9:8] == 2'b10)
                    din[9:8] == 2'b11;
            
                else // 11
                    din[9:8] == 2'b10;
        }
        
        function void post_randomize();
            prev_din = din;
        endfunction
    endclass
endpackage