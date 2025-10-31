package ram_monitor_pkg;
    import ram_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_monitor extends uvm_monitor;
        `uvm_component_utils(ram_monitor);
        ram_seq_item mon_item;
        virtual ram_if vif;
        uvm_analysis_port #(ram_seq_item) mon_ap;

        function new(string name = "ram_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                mon_item = ram_seq_item::type_id::create("mon_item");
                @(negedge vif.clk);
                mon_item.rx_valid = vif.rx_valid;
                mon_item.din = vif.din;
                mon_item.rst_n = vif.rst_n;
                mon_item.dout = vif.dout;
                mon_item.tx_valid = vif.tx_valid;
                mon_item.dout_ref = vif.dout_ref;
                mon_item.tx_valid_ref = vif.tx_valid_ref;
                mon_ap.write(mon_item);
                `uvm_info("MONITOR RUN", mon_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass

endpackage