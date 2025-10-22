package wrapper_driver_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_driver extends uvm_driver #(wrapper_seq_item);
        `uvm_component_utils(wrapper_driver)
        wrapper_seq_item drv_item;
        virtual wrapper_if vif;

        function new(string name = "wrapper_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                drv_item = wrapper_seq_item::type_id::create("drv_item");
                seq_item_port.get_next_item(drv_item);
                vif.rst_n = drv_item.rst_n;
                vif.SS_n     = drv_item.SS_n;
                vif.MOSI = drv_item.MOSI;
                @(negedge vif.clk);
                seq_item_port.item_done();
                `uvm_info("DRIVER RUN", drv_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
