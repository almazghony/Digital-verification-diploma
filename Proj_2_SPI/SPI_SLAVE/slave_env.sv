package slave_env_pkg;
    import slave_agent_pkg::*;
    import uvm_pkg::*;
    import slave_scoreboard_pkg::*;
    import slave_coverage_pkg::*;
    `include "uvm_macros.svh"

    class slave_env extends uvm_env;
        `uvm_component_utils(slave_env)

        slave_agent agent;
        slave_scoreboard sb;
        slave_cov cov;

        function new(string name = "slave_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = slave_agent::type_id::create("agent", this);
            sb = slave_scoreboard::type_id::create("sb",this);
            cov = slave_cov::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agt_ap.connect(sb.sb_exp);
            agent.agt_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage