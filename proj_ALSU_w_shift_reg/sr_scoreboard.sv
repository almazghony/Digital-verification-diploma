package sr_scoreboard_pkg;

    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class sr_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(sr_scoreboard);

        uvm_analysis_export #(sr_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(sr_seq_item) sb_fifo;
        sr_seq_item sb_item;
        logic [5:0] expected_data;

        int error_count = 0;
        int correct_count = 0;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_item);
                ref_model(sb_item);
                if (sb_item.dataout !== expected_data) begin
                    `uvm_error("SR_SCB", $sformatf("Mismatch! Expected: %0h, Got: %0h", expected_data, sb_item.dataout))
                    error_count++;
                end else begin
                    `uvm_info("SR_SCB", $sformatf("Match! Expected: %0h, Got: %0h", expected_data, sb_item.dataout), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask

        task ref_model(sr_seq_item item);
            if (item.reset)
                expected_data = 0;
            else
                if (item.mode)
                    if (item.direction)
                        expected_data = {item.datain[4:0], item.datain[5]};
                    else
                        expected_data = {item.datain[0], item.datain[5:1]};
                else
                    if (item.direction)
                        expected_data = {item.datain[4:0], item.serial_in};
                    else
                        expected_data = {item.serial_in, item.datain[5:1]};
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SR_SCB", $sformatf("total correct: %0d\ntotal errors: %0d", correct_count, error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage

