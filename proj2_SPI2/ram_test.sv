package ram_test_pkg;
    import ram_env_pkg::*;
    import ram_config_pkg::*;
    import ram_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_test extends uvm_test;
        `uvm_component_utils(ram_test);
        ram_env env;
        ram_config cfg;
        ram_reset_seq rst_seq;
        ram_wr_seq wr_seq;
        ram_rd_seq rd_seq;
        ram_rd_wr_seq rd_wr_seq;
        function new(string name = "ram_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cfg = ram_config::type_id::create("cfg");
            if(!uvm_config_db #(virtual ram_if)::get(this, "", "RAM_VIF", cfg.vif))
                `uvm_fatal("TEST BUilD", "Failure in getting the interface");
            cfg.is_active = UVM_ACTIVE;
            uvm_config_db #(ram_config)::set(this, "*", "RAM_CFG", cfg);

            rst_seq = ram_reset_seq::type_id::create("rst_seq");
            wr_seq = ram_wr_seq::type_id::create("wr_seq");
            rd_seq = ram_rd_seq::type_id::create("rd_seq");
            rd_wr_seq = ram_rd_wr_seq::type_id::create("rd_wr_seq");
            env = ram_env::type_id::create("env", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("TEST_RUN", "starting reset test", UVM_LOW);
            rst_seq.start(env.agt.sqr);
            `uvm_info("TEST_RUN", "starting WRITE test", UVM_LOW);
            wr_seq.start(env.agt.sqr);
            `uvm_info("TEST_RUN", "starting READ test", UVM_LOW);
            rd_seq.start(env.agt.sqr);
            `uvm_info("TEST_RUN", "starting READ WRITE test", UVM_LOW);
            rd_wr_seq.start(env.agt.sqr);
            `uvm_info("TEST_RUN", "test done", UVM_LOW);
            #5;
            phase.drop_objection(this);
        endtask

    endclass

endpackage