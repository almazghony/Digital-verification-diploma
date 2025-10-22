package wrapper_env_pkg;
    import wrapper_agent_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_env extends uvm_env;
        `uvm_component_utils(wrapper_env)

        wrapper_agent agent;


        function new(string name = "wrapper_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = wrapper_agent::type_id::create("agent", this);
        endfunction
    endclass
endpackage