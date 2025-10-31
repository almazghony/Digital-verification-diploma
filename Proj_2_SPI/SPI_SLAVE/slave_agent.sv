package slave_agent_pkg;
    import slave_sequencer_pkg::*;
    import slave_driver_pkg::*;
    import slave_monitor_pkg::*;
    import slave_seq_item_pkg::*;
    import slave_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_agent extends uvm_agent;
        `uvm_component_utils(slave_agent)

        slave_driver driver;
        slave_monitor monitor;
        slave_sequencer sqr;
        slave_config slave_cfg;

        uvm_analysis_port #(slave_seq_item) agt_ap;

        function new(string name ="slave_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(slave_config)::get(this, "", "CFG", slave_cfg))
                `uvm_fatal("AGENT BUILD", "Failed to get CFG");

            if(slave_cfg.is_active == UVM_ACTIVE) begin
                sqr    = slave_sequencer::type_id::create("sqr", this);
                driver = slave_driver::type_id::create("driver", this);
            end

            agt_ap = new("agt_ap",this);
            monitor = slave_monitor::type_id::create("monitor", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(slave_cfg.is_active == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sqr.seq_item_export);
                driver.vif = slave_cfg.vif;
            end

            monitor.mon_ap.connect(agt_ap);
            monitor.vif = slave_cfg.vif;
        endfunction
    endclass
endpackage
