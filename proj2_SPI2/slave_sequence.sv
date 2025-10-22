package slave_sequence_pkg;
    import slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class reset_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(reset_seq)

        slave_seq_item rst_item;

        function new(string name ="reset_seq");
            super.new(name);
        endfunction

        task body;
            rst_item=slave_seq_item::type_id::create("rst_item");
            start_item(rst_item);
            rst_item.rst_n = 0;
            rst_item.SS_n = 1;
            rst_item.tx_valid = 0;
            rst_item.tx_data = 0;
            rst_item.MOSI = 0;
            finish_item(rst_item);
        endtask
    endclass


    class main_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(main_seq)
        
        slave_seq_item main_item;

        function new(string name = "main_seq");
            super.new(name);
        endfunction

        task body;
            main_item = slave_seq_item::type_id::create("main_item");
            repeat(10000)begin
                if((main_item.counter == 12 && main_item.mosi_data[9:8] != 2'b11)
                    || main_item.counter == 22)
                    main_item.mosi_data.rand_mode(1);
                else
                    main_item.mosi_data.rand_mode(0);
                start_item(main_item);
                assert(main_item.randomize());
                finish_item(main_item);
                
                `uvm_info("SEQUENCE MAIN", $sformatf("counter: %0d, mosi_data: %b, MOSI: %d, rst_n: %d, SS_n: %d, tx_valid: %d",
                    main_item.counter, main_item.mosi_data, main_item.MOSI, main_item.rst_n, main_item.SS_n, main_item.tx_valid), UVM_LOW);
            end
        endtask
    endclass
endpackage



