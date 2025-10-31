package slave_test_pkg;
    import uvm_pkg::*;
    import slave_env_pkg::*;
    import slave_config_pkg::*;
    import slave_sequence_pkg::*;
    `include "uvm_macros.svh"

    class slave_test extends uvm_test;
        `uvm_component_utils(slave_test)

        slave_env env;
        slave_config slave_cfg;
        reset_seq rst_seq;
        main_seq mn_seq;



        function new(string name = "slave_test" ,uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            slave_cfg = slave_config::type_id::create("slave_cfg");
            slave_cfg.is_active = UVM_ACTIVE;

            if(!uvm_config_db#(virtual slave_if)::get(this, "", "SLAVE_VIF", slave_cfg.vif))
            `uvm_fatal("build phase","unable to get v_if");
            
            uvm_config_db#(slave_config)::set(this, "*", "CFG", slave_cfg);

            env = slave_env::type_id::create("env", this);
            rst_seq = reset_seq::type_id::create("rst_seq", this);
            mn_seq = main_seq::type_id::create("mn_seq", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            `uvm_info("TEST RUN", "Starting reset test.", UVM_LOW);
            rst_seq.start(env.agent.sqr);

            `uvm_info("TEST RUN", "Starting main test.", UVM_LOW);
            mn_seq.start(env.agent.sqr);

            `uvm_info("TEST RUN", "Test done.", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage