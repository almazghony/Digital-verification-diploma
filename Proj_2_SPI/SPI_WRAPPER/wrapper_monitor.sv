package wrapper_monitor_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(wrapper_monitor)
        wrapper_seq_item seq_item;
        virtual wrapper_if vif;

        function new(string name = "wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = wrapper_seq_item::type_id::create("seq_item");
                @(negedge vif.clk);
                seq_item.rst_n = vif.rst_n;
                seq_item.SS_n = vif.SS_n;
                seq_item.MOSI = vif.MOSI;
                seq_item.MISO = vif.MISO;
                `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage
