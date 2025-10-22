package sr_seq_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class main_seq extends uvm_sequence #(sr_seq_item);
        `uvm_object_utils(main_seq);

        sr_seq_item main_seq_item;

        function new(string name = "main_seq");
            super.new(name);
        endfunction

        task body();
            main_seq_item = sr_seq_item::type_id::create("main_seq_item");
            repeat(10000) begin
                start_item(main_seq_item); 
                assert(main_seq_item.randomize());
                finish_item(main_seq_item); 
            end
        endtask
    endclass
endpackage

