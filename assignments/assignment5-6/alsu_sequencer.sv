package sequencer_pkg;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_sequencer extends uvm_sequencer #(alsu_item);
        `uvm_component_utils(alsu_sequencer);

        function new(string name = "alsu_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage

