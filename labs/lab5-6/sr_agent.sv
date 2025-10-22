package sr_agent_pkg;
    import uvm_pkg::*;
    import seq_item_pkg::*;
    import sr_monitor_pkg::*;
    import shift_reg_driver_pkg::*;
    import shift_reg_config_pkg::*;
    import sr_sequencer_pkg::*;
    `include "uvm_macros.svh"

    class sr_agent extends uvm_agent;
        `uvm_component_utils(sr_agent);
        sr_sequencer sqr;
        shift_reg_driver drv;
        sr_monitor mon;
        shift_reg_config cfg;
        uvm_analysis_port #(shift_reg_seq_item) agent_ap;

        function new(string name = "sr_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(shift_reg_config)::get(this, "", "CFG", cfg))
                `uvm_fatal("build_phase", "welcome to my error");

            sqr = sr_sequencer::type_id::create("sqr", this);
            drv = shift_reg_driver::type_id::create("drv", this);
            mon = sr_monitor::type_id::create("mon", this);
            agent_ap = new("agent_ap", this);        
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.vif= cfg.vif;
            mon.vif = cfg.vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agent_ap);
        endfunction
    endclass
endpackage  