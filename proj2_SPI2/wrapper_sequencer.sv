package wrapper_sequencer_pkg;
    import uvm_pkg::*;
    import wrapper_seq_item_pkg::*;
    `include"uvm_macros.svh"

    class wrapper_sequencer extends uvm_sequencer #(wrapper_seq_item);
        `uvm_component_utils(wrapper_sequencer)

        function new(string name = "wrapper_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction

    endclass
endpackage