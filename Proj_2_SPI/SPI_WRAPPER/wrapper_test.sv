package wrapper_test_pkg;

    import uvm_pkg::*;
    import wrapper_seq_item_pkg::*;
    import wrapper_sequence_pkg::*;
    import wrapper_config_pkg::*;
    import slave_config_pkg::*;
    import ram_config_pkg::*;
    import wrapper_env_pkg::*;
    import slave_env_pkg::*;
    import ram_env_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test)

        wrapper_env wrapperenv;
        slave_env slaveenv;
        ram_env ramenv;

        wrapper_config wrapper_cfg;
        slave_config slave_cfg;
        ram_config ram_cfg;

        wrapper_rst_seq rst_seq;
        wrapper_wr_seq wr_seq;
        wrapper_rd_seq rd_seq;
        wrapper_rd_wr_seq wr_rd_seq;

        function new(string name = "wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            wrapperenv = wrapper_env::type_id::create("wrapperenv", this);
            slaveenv = slave_env::type_id::create("slaveenv", this);
            ramenv = ram_env::type_id::create("ramenv", this);

            wrapper_cfg = wrapper_config::type_id::create("wrapper_cfg");
            slave_cfg = slave_config::type_id::create("slave_cfg");
            ram_cfg = ram_config::type_id::create("ram_cfg");
            
            rst_seq = wrapper_rst_seq::type_id::create("rst_seq");
            wr_seq = wrapper_wr_seq::type_id::create("wr_seq");
            rd_seq = wrapper_rd_seq::type_id::create("rd_seq");
            wr_rd_seq = wrapper_rd_wr_seq::type_id::create("wr_rd_seq");

            if(!uvm_config_db #(virtual wrapper_if)::get(this, "", "WRAPPER VIF", wrapper_cfg.vif))
                `uvm_fatal("build_phase", "Test - Unable to get the virtual interface fo the SPI_wrapper form the uvm_config_db");

            if(!uvm_config_db #(virtual slave_if)::get(this, "", "SLAVE VIF", slave_cfg.vif))
                `uvm_fatal("build_phase", "Test - Unable to get the virtual interface fo the SPI_wrapper form the uvm_config_db");

            if(!uvm_config_db #(virtual ram_if)::get(this, "", "RAM VIF", ram_cfg.vif))
                `uvm_fatal("build_phase", "Test - Unable to get the virtual interface fo the SPI_wrapper form the uvm_config_db");

            uvm_config_db #(wrapper_config)::set(this, "*", "WRAPPER CFG", wrapper_cfg);
            uvm_config_db #(slave_config)::set(this, "*", "SLAVE CFG", slave_cfg);
            uvm_config_db #(ram_config)::set(this, "*", "RAM CFG", ram_cfg);

            wrapper_cfg.is_active = UVM_ACTIVE;
            slave_cfg.is_active = UVM_PASSIVE;
            ram_cfg.is_active = UVM_PASSIVE;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase_test", "Rest Asserted", UVM_LOW);
            rst_seq.start(wrapperenv.agent.sqr);
            `uvm_info("run_phase_test", "Rest Deasserted", UVM_LOW);

            `uvm_info("run_phase_test", "Write only operation is started", UVM_LOW);
            wr_seq.start(wrapperenv.agent.sqr);
            `uvm_info("run_phase_test", "Write only operation is ended", UVM_LOW);

            `uvm_info("run_phase_test", "read only operation is started", UVM_LOW);
            rd_seq.start(wrapperenv.agent.sqr);
            `uvm_info("run_phase_test", "read only operation is ended", UVM_LOW);

            `uvm_info("run_phase_test", "write and read operation is started", UVM_LOW);
            wr_rd_seq.start(wrapperenv.agent.sqr);
            `uvm_info("run_phase_test", "write and read operation is ended", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage