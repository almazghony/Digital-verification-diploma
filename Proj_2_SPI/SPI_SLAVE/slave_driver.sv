package slave_driver_pkg;
    import slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_driver extends uvm_driver #(slave_seq_item);
        `uvm_component_utils(slave_driver)
        slave_seq_item drv_item;
        virtual slave_if vif;

        function new(string name = "slave_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                drv_item = slave_seq_item::type_id::create("drv_item");
                seq_item_port.get_next_item(drv_item);
                vif.rst_n = drv_item.rst_n;
                vif.SS_n     = drv_item.SS_n;
                vif.tx_valid = drv_item.tx_valid;
                vif.tx_data  = drv_item.tx_data;
                vif.MOSI = drv_item.MOSI;
                @(negedge vif.clk);
                seq_item_port.item_done();
                `uvm_info("DRIVER RUN", drv_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
