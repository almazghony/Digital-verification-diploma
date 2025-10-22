package agent_pkg;
    import alsu_driver_pkg::*;
    import alsu_monitor_pkg::*;
    import sequencer_pkg::*;
    import alsu_config_pkg::*;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_agent extends uvm_agent;
        `uvm_component_utils(alsu_agent);
        alsu_driver drv;
        alsu_monitor mon;
        alsu_sequencer sqr;
        alsu_config cfg;
        uvm_analysis_port #(alsu_item) agt_ap;

        function new(string name = "alsu_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(alsu_config)::get(this, "", "CFG", cfg))
                `uvm_fatal("agent_build", "Unable to get configuration object!");
            drv = alsu_driver::type_id::create("drv", this);
            mon = alsu_monitor::type_id::create("mon", this);
            sqr = alsu_sequencer::type_id::create("sqr", this);
            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            mon.mon_ap.connect(agt_ap);
            drv.seq_item_port.connect(sqr.seq_item_export);
            drv.vif = cfg.vif;
            mon.vif = cfg.vif;
        endfunction
    endclass
endpackage

