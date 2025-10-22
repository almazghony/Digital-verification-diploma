package ram_driver_pkg;
    import uvm_pkg::*;
    import ram_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class ram_driver extends uvm_driver #(ram_seq_item);
        `uvm_component_utils(ram_driver);
        virtual ram_if vif;
        ram_seq_item drv_item;

        function new(string name = "ram_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            drv_item = ram_seq_item::type_id::create("drv_item");
            forever begin
                seq_item_port.get_next_item(drv_item);
                vif.din = drv_item.din;
                vif.rx_valid = drv_item.rx_valid;
                vif.rst_n = drv_item.rst_n;
                seq_item_port.item_done();
                @(negedge vif.clk);
                `uvm_info("DRIVER", drv_item.convert2string_stimulus(), UVM_HIGH);
            end
        endtask
    endclass
endpackage