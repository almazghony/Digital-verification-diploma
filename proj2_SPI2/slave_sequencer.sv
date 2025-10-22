package slave_sequencer_pkg;
    import slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_sequencer extends uvm_sequencer #(slave_seq_item);
    `uvm_component_utils(slave_sequencer)

    function new(string name = "slave_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    endclass
endpackage
