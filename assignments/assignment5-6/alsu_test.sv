package alsu_test_pkg;
    import alsu_env_pkg::*;
    import sequence_pkg::*;
    import alsu_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test);
        alsu_env env;
        alsu_config cfg;
        reset_sequence reset_seq;
        main_sequence main_seq;
        function new(string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cfg = alsu_config::type_id::create("cfg", this);
            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_VIF", cfg.vif))
                `uvm_fatal("ALSU_TEST", "Virtual interface not exist");
            uvm_config_db#(alsu_config)::set(this, "*", "CFG", cfg);

            env = alsu_env::type_id::create("env", this);
            reset_seq = reset_sequence::type_id::create("reset_seq");
            main_seq = main_sequence::type_id::create("main_seq");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("ALSU_TEST", "Starting reset test", UVM_LOW);
            reset_seq.start(env.agent.sqr);
            `uvm_info("ALSU_TEST", "Starting main test", UVM_LOW);
            main_seq.start(env.agent.sqr);
            #10ns;
            `uvm_info("ALSU_TEST", "Test completed", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage

