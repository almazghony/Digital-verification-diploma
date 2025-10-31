package sr_sequencer_pkg;
    import uvm_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"
    class sr_sequencer extends uvm_sequencer #(sr_seq_item);
        `uvm_component_utils(sr_sequencer);
        function new(string name = "sr_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage