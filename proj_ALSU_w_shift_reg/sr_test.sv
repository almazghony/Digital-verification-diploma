////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package sr_test_pkg;
    import sr_env_pkg::*;
    import sr_config_pkg::*;
    import sr_seq_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class sr_test extends uvm_test;
        sr_env env;
        sr_config sr_cfg;
        main_seq main_sequence;

        `uvm_component_utils(sr_test);
        function new(string name = "sr_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = sr_env::type_id::create("env", this);
            sr_cfg = sr_config::type_id::create("sr_cfg");

            uvm_config_db #(virtual sr_if)::get(this, "", "SHIFT_IF", sr_cfg.vif);
            main_sequence = main_seq::type_id::create("main_sequence");
        
            uvm_config_db #(sr_config)::set(this, "*", "CFG", sr_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            main_sequence.start(env.agent.sqr);
            phase.drop_objection(this);
        endtask 
    endclass
endpackage