package slave_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class slave_config extends uvm_object;
        `uvm_object_utils(slave_config)
        uvm_active_passive_enum is_active;
        virtual slave_if vif;

        function new(string name ="slave_config");
            super.new(name);
        endfunction
    endclass
endpackage
