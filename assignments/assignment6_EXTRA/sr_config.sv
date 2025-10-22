package sr_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh";

    class sr_config extends uvm_object;
        `uvm_object_utils(sr_config);
        virtual sr_if vif;
        uvm_active_passive_enum is_active;

        function new(string name = "sr_config");
            super.new(name);
        endfunction
    endclass
endpackage

