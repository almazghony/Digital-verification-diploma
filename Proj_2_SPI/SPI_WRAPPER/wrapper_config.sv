package wrapper_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class wrapper_config extends uvm_object;
    `uvm_object_utils(wrapper_config)

    virtual wrapper_if vif;

    uvm_active_passive_enum is_active;


    function new(string name = "wrapper_config");
        super.new(name);
    endfunction
endclass
endpackage