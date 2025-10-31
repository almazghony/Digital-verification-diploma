package alsu_test_pkg;
    import alsu_env_pkg::*;
    import sr_env_pkg::*;
    import sr_config_pkg::*;
    import sequence_pkg::*;
    import alsu_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test);
        alsu_env alsuEnv;
        sr_env srEnv;

        alsu_config alsu_cfg;
        sr_config sr_cfg;
        
        reset_sequence reset_seq;
        main_sequence main_seq;
        function new(string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            alsuEnv = alsu_env::type_id::create("alsEenv", this);
            srEnv = sr_env::type_id::create("srEnv", this);
            alsu_cfg = alsu_config::type_id::create("alsu_cfg", this);
            sr_cfg = sr_config::type_id::create("sr_cfg", this);
            reset_seq = reset_sequence::type_id::create("reset_seq");
            main_seq = main_sequence::type_id::create("main_seq");


            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_VIF", alsu_cfg.vif))
                `uvm_fatal("ALSU_TEST", "Virtual interface not exist");
            
            if(!uvm_config_db#(virtual sr_if)::get(this, "", "SR_VIF", sr_cfg.vif))
                `uvm_fatal("ALSU_TEST", "Virtual interface not exist");
            
            uvm_config_db#(alsu_config)::set(this, "*", "ALSU_CFG", alsu_cfg);
            uvm_config_db#(sr_config)::set(this, "*", "SR_CFG", sr_cfg);

            alsu_cfg.is_active = UVM_ACTIVE;
            sr_cfg.is_active = UVM_PASSIVE;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("ALSU_TEST", "Starting reset test", UVM_LOW);
            reset_seq.start(alsuEnv.agent.sqr);
            `uvm_info("ALSU_TEST", "Starting main test", UVM_LOW);
            main_seq.start(alsuEnv.agent.sqr);
            #10ns;
            `uvm_info("ALSU_TEST", "Test completed", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage

