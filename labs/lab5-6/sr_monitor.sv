package sr_monitor_pkg;

    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class sr_monitor extends uvm_monitor;
        `uvm_component_utils(sr_monitor);
        shift_reg_seq_item monitor_item;
        virtual shift_reg_if vif;
        uvm_analysis_port #(shift_reg_seq_item) mon_ap;

        function new(string name = "sr_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                monitor_item = shift_reg_seq_item::type_id::create("monitor_item");
                @(negedge vif.clk);
                monitor_item.reset = vif.reset;
                monitor_item.serial_in = vif.serial_in;
                monitor_item.direction = vif.direction;
                monitor_item.mode = vif.mode;
                monitor_item.datain = vif.datain;
                monitor_item.dataout = vif.dataout;
                mon_ap.write(monitor_item);
                `uvm_info("run_phase", monitor_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass

endpackage