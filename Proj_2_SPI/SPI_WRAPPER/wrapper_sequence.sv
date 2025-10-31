package wrapper_sequence_pkg;
    import uvm_pkg::*;
    import wrapper_seq_item_pkg::*;
    import ram_seq_item_pkg::*;
    import slave_seq_item_pkg::*;
    `include"uvm_macros.svh"

    class wrapper_rst_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_rst_seq)
        wrapper_seq_item rst_item;

        function new(string name = "wrapper_rst_seq");
            super.new(name);
        endfunction

        task body;
            rst_item = wrapper_seq_item::type_id::create("rst_item");
            start_item(rst_item);
            rst_item.rst_n = 0;
            rst_item.SS_n = 1;
            rst_item.MOSI = 0;
            finish_item(rst_item);
        endtask
    endclass

    class wrapper_wr_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_wr_seq)
        wrapper_seq_item wr_item;

        function new(string name = "wrapper_wr_seq");
            super.new(name);
        endfunction

        task body();
            wr_item = wrapper_seq_item::type_id::create("wr_item");
            wr_item.rd_seq_c.constraint_mode(0);
            wr_item.rd_wr_seq_c.constraint_mode(0);
            

            repeat(10000) begin
                if((wr_item.counter == 13 && wr_item.mosi_data[9:8] != 2'b11)
                    || wr_item.counter == 23) begin
                    wr_item.mosi_data.rand_mode(1);
                    wr_item.wr_seq_c.constraint_mode(1);
                    end
                else begin
                    wr_item.mosi_data.rand_mode(0);
                    wr_item.wr_seq_c.constraint_mode(0);
                end
                start_item(wr_item);
                assert(wr_item.randomize());

                `uvm_info("SEQUENCE MAIN", $sformatf("counter: %0d, mosi_data: %b, MOSI: %d, SS_n: %d",
                    wr_item.counter, wr_item.mosi_data, wr_item.MOSI, wr_item.SS_n), UVM_HIGH)
                finish_item(wr_item);
            end
        endtask
    endclass

    class wrapper_rd_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_rd_seq)

        wrapper_seq_item rd_item;

        function new(string name = "wrapper_rd_seq");
            super.new(name);
        endfunction

        task body();
            rd_item = wrapper_seq_item::type_id::create("rd_item");
            rd_item.wr_seq_c.constraint_mode(0);
            rd_item.rd_wr_seq_c.constraint_mode(0);
            
            repeat(10000) begin
                start_item(rd_item);
                if((rd_item.counter == 13 && rd_item.mosi_data[9:8] != 2'b11)
                    || rd_item.counter == 23) begin
                    rd_item.mosi_data.rand_mode(1);
                    rd_item.rd_seq_c.constraint_mode(1);
                    end
                else begin
                    rd_item.mosi_data.rand_mode(0);
                    rd_item.rd_seq_c.constraint_mode(0);
                end
                assert(rd_item.randomize());
                finish_item(rd_item);
                
            end
        endtask

    endclass

    class wrapper_rd_wr_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_rd_wr_seq)
        wrapper_seq_item rd_wr_item;

        function new(string name = "wrapper_rd_wr_seq");
            super.new(name);
        endfunction

        task body();
            rd_wr_item = wrapper_seq_item::type_id::create("rd_wr_item");
            rd_wr_item.wr_seq_c.constraint_mode(0);
            rd_wr_item.rd_seq_c.constraint_mode(0);
            
                
            repeat(10000) begin
                start_item(rd_wr_item);
                if((rd_wr_item.counter == 13 && rd_wr_item.mosi_data[9:8] != 2'b11)
                    || rd_wr_item.counter == 23) begin
                    rd_wr_item.mosi_data.rand_mode(1);
                    rd_wr_item.rd_wr_seq_c.constraint_mode(1);
                    end
                else begin
                    rd_wr_item.mosi_data.rand_mode(0);
                    rd_wr_item.rd_wr_seq_c.constraint_mode(0);
                end
                assert(rd_wr_item.randomize());
                finish_item(rd_wr_item);
            end

            start_item(rd_wr_item);
            
            finish_item(rd_wr_item);
        endtask
    endclass
endpackage
