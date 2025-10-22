////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;
    import shift_reg_env_pkg::*;
    import shift_reg_config_pkg::*;
    import sr_seq_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class shift_reg_test extends uvm_test;
        shift_reg_env env;
        shift_reg_config shift_reg_cfg;
        main_seq main_sequence;
        reset_seq reset_sequence;

        `uvm_component_utils(shift_reg_test);
        function new(string name = "shift_reg_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = shift_reg_env::type_id::create("env", this);
            shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg");

            uvm_config_db #(virtual shift_reg_if)::get(this, "", "SHIFT_IF", shift_reg_cfg.vif);
        main_sequence = main_seq::type_id::create("main_sequence");
        reset_sequence = reset_seq::type_id::create("reset_sequence");
        
            uvm_config_db #(shift_reg_config)::set(this, "*", "CFG", shift_reg_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            reset_sequence.start(env.agent.sqr);
            main_sequence.start(env.agent.sqr);
            phase.drop_objection(this);
        endtask 
    endclass: shift_reg_test
endpackage