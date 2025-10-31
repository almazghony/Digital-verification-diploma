package ram_sequence_pkg;
    import ram_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_reset_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_reset_seq);

        ram_seq_item rst_item;

        function new(string name = "ram_reset_seq");
            super.new(name);
        endfunction

        task body();
            rst_item = ram_seq_item::type_id::create("rst_item");
            rst_item.wr_seq_c.constraint_mode(0);
            rst_item.rd_seq_c.constraint_mode(0);
            rst_item.rd_wr_seq_c.constraint_mode(0);
            start_item(rst_item);
            rst_item.rst_n = 0;
            rst_item.din = 0;
            rst_item.rx_valid = 0;
            finish_item(rst_item);
        endtask
    endclass
    
    class ram_wr_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_wr_seq);
        
        ram_seq_item wr_item;
        
        function new(string name = "ram_rd_seq");
            super.new(name);
        endfunction
        
        task body();
            wr_item = ram_seq_item::type_id::create("wr_item");
            wr_item.rd_seq_c.constraint_mode(0);
            wr_item.rd_wr_seq_c.constraint_mode(0);
            repeat(1000) begin
                start_item(wr_item);
                assert(wr_item.randomize());
                wr_item.din[9] = 1'b0;
                finish_item(wr_item);
            end
        endtask
    endclass
    
    class ram_rd_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_rd_seq);
        
        ram_seq_item rd_item;
        
        function new(string name = "ram_rd_seq");
            super.new(name);
        endfunction
        
        task body();
            rd_item = ram_seq_item::type_id::create("rd_item");
            rd_item.wr_seq_c.constraint_mode(0);
            rd_item.rd_wr_seq_c.constraint_mode(0);
            repeat(1000) begin
                start_item(rd_item);
                assert(rd_item.randomize());
                rd_item.din[9] = 1'b1;
                finish_item(rd_item);
            end
        endtask
    endclass
    
    class ram_rd_wr_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_rd_wr_seq);
        
        ram_seq_item rd_wr_item;
        
        function new(string name = "ram_rd_wr_seq");
            super.new(name);
        endfunction
        
        task body();
            rd_wr_item = ram_seq_item::type_id::create("rd_wr_item");
            rd_wr_item.wr_seq_c.constraint_mode(0);
            rd_wr_item.rd_seq_c.constraint_mode(0);
            repeat(1000) begin
                start_item(rd_wr_item);
                assert(rd_wr_item.randomize());
                finish_item(rd_wr_item);
            end
        endtask
    endclass
endpackage