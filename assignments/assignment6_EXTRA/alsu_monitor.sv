package alsu_monitor_pkg;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_monitor extends uvm_monitor;
        `uvm_component_utils(alsu_monitor);
        uvm_analysis_port #(alsu_item) mon_ap;
        virtual alsu_if vif;
        alsu_item item;

        function new(string name = "alsu_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                item = alsu_item::type_id::create("item");
                @(negedge vif.clk);
                item.A = vif.A;
                item.B = vif.B;
                item.cin = vif.cin;
                item.serial_in = vif.serial_in;
                item.red_op_A = vif.red_op_A;
                item.red_op_B = vif.red_op_B;
                item.opcode = vif.opcode;
                item.bypass_A = vif.bypass_A;
                item.bypass_B = vif.bypass_B;
                item.rst = vif.rst;
                item.direction = vif.direction;
                item.leds = vif.leds;
                item.out = vif.out;
                mon_ap.write(item);
                `uvm_info("MONITOR", item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage


