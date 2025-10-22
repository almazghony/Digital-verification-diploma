package alsu_env_pkg;
    import agent_pkg::*;
    import scoreboard_pkg::*;
    import cov_pkg::*;
    import alsu_driver_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_env extends uvm_env;
        `uvm_component_utils(alsu_env);
        alsu_agent agent;
        alsu_scoreboard sb;
        alsu_cov cov;
        function new(string name = "alsu_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = alsu_agent::type_id::create("agent", this);
            sb = alsu_scoreboard::type_id::create("sb", this);
            cov = alsu_cov::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agt_ap.connect(sb.sb_export);
            agent.agt_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage

