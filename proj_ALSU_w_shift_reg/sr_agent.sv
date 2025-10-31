package sr_agent_pkg;
    import uvm_pkg::*;
    import seq_item_pkg::*;
    import sr_monitor_pkg::*;
    import sr_driver_pkg::*;
    import sr_config_pkg::*;
    import sr_sequencer_pkg::*;
    `include "uvm_macros.svh"

    class sr_agent extends uvm_agent;
        `uvm_component_utils(sr_agent);
        sr_sequencer sqr;
        sr_driver drv;
        sr_monitor mon;
        sr_config sr_cfg;
        uvm_analysis_port #(sr_seq_item) agent_ap;

        function new(string name = "sr_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(sr_config)::get(this, "", "SR_CFG", sr_cfg))
                `uvm_fatal("build_phase", "welcome to my error");
            if(sr_cfg.is_active == UVM_ACTIVE) begin
                sqr = sr_sequencer::type_id::create("sqr", this);
                drv = sr_driver::type_id::create("drv", this);
            end
            mon = sr_monitor::type_id::create("mon", this);
            agent_ap = new("agent_ap", this);        
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            if(sr_cfg.is_active == UVM_ACTIVE) begin
                drv.vif= sr_cfg.vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end

            mon.vif = sr_cfg.vif;
            mon.mon_ap.connect(agent_ap);
        endfunction
    endclass
endpackage
