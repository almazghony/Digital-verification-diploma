package sr_cov_collector_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class sr_cov_collector extends uvm_component;
        `uvm_component_utils(sr_cov_collector);
        uvm_analysis_export #(shift_reg_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
        shift_reg_seq_item cov_item;

        covergroup sr_cg;
            direction_cp : coverpoint cov_item.direction;
            
            mode_cp : coverpoint cov_item.mode; 
            
            reset_cp : coverpoint cov_item.reset; 
            
            datain_cp : coverpoint cov_item.datain; 
        
            serial_in_cp : coverpoint cov_item.serial_in; 

            dataout_cp : coverpoint cov_item.dataout; 
        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            sr_cg = new;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_item);
                sr_cg.sample();
            end
        endtask

    endclass
endpackage