package slave_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_seq_item_pkg::*;

    class slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(slave_scoreboard)
        slave_seq_item seq_item;
        uvm_analysis_export #(slave_seq_item) sb_exp;
        uvm_tlm_analysis_fifo #(slave_seq_item) fifo_export;

        int correct_count,error_count;

        function new(string name = "slave_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            sb_exp = new("sb_exp",this);
            fifo_export = new("fifo_export",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_exp.connect(fifo_export.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo_export.get(seq_item);
                if(seq_item.rx_data != seq_item.rx_data_ref || seq_item.rx_valid != seq_item.rx_valid_ref || seq_item.MISO != seq_item.MISO_ref)begin
                    `uvm_error("SB RUN", $sformatf("Mismatch!\nMISO: %d Expected: %d, rx_data: %0d Expected: %0d\nrx_valid: %0d Expected: %0d",
                                seq_item.MISO, seq_item.MISO_ref, seq_item.rx_data, seq_item.rx_data_ref, seq_item.rx_valid, seq_item.rx_valid_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("SB RUN", $sformatf("Match!\nMISO: %d Expected: %d, rx_data: %0d Expected: %0d\nrx_valid: %0d Expected: %0d",
                                seq_item.MISO, seq_item.MISO_ref, seq_item.rx_data, seq_item.rx_data_ref, seq_item.rx_valid, seq_item.rx_valid_ref), UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SB REPORT", $sformatf("errors: %0d", error_count), UVM_MEDIUM);
            `uvm_info("SB REPORT", $sformatf("correct: %0d", correct_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage