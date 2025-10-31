package wrapper_agent_pkg;
    import wrapper_sequencer_pkg::*;
    import wrapper_driver_pkg::*;
    import wrapper_monitor_pkg::*;
    import wrapper_seq_item_pkg::*;
    import wrapper_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_agent extends uvm_agent;
        `uvm_component_utils(wrapper_agent)

        wrapper_driver driver;
        wrapper_monitor monitor;
        wrapper_sequencer sqr;
        wrapper_config cfg;

        uvm_analysis_port #(wrapper_seq_item) agt_ap;

        function new(string name ="wrapper_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(wrapper_config)::get(this, "", "WRAPPER CFG", cfg))
                `uvm_fatal("AGENT BUILD", "Failed to get CFG");

                if(cfg.is_active == UVM_ACTIVE) begin
                    sqr    = wrapper_sequencer::type_id::create("sqr", this);
                    driver = wrapper_driver::type_id::create("driver", this);
                end
                monitor = wrapper_monitor::type_id::create("monitor", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

                if(cfg.is_active == UVM_ACTIVE) begin
                    driver.seq_item_port.connect(sqr.seq_item_export);
                    driver.vif = cfg.vif;
                end
                monitor.vif = cfg.vif;
        endfunction
    endclass
endpackage