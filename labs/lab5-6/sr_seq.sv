package sr_seq_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class reset_seq extends uvm_sequence #(shift_reg_seq_item);
        `uvm_object_utils(reset_seq);

        shift_reg_seq_item reset_seq_item;

        function new(string name = "reset_seq");
            super.new(name);
        endfunction

        task body;
            reset_seq_item = shift_reg_seq_item::type_id::create("reset_seq_item");
            start_item(reset_seq_item);
            reset_seq_item.reset = 1;
            reset_seq_item.serial_in = 0;
            reset_seq_item.direction = 0;
            reset_seq_item.mode = 0;
            reset_seq_item.datain = 0;
            finish_item(reset_seq_item);
        endtask
    endclass

    class main_seq extends uvm_sequence #(shift_reg_seq_item);
        `uvm_object_utils(main_seq);

        shift_reg_seq_item main_seq_item;

        function new(string name = "main_seq");
            super.new(name);
        endfunction

        task body();
            main_seq_item = shift_reg_seq_item::type_id::create("main_seq_item");
            repeat(10000) begin
                start_item(main_seq_item); 
                assert(main_seq_item.randomize());
                finish_item(main_seq_item); 
            end
        endtask
    endclass
endpackage

