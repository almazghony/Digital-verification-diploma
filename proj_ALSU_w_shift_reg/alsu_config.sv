package alsu_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_config extends uvm_object;
        `uvm_object_utils(alsu_config);
        virtual alsu_if vif;
        uvm_active_passive_enum is_active;

        function new(string name = "alsu_config");
            super.new(name);
        endfunction
    endclass
endpackage

