package ram_scoreboard_pkg;
    import ram_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ram_scoreboard);
        uvm_analysis_export #(ram_seq_item) sb_exp;
        uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
        ram_seq_item sb_item;

        int error_count, correct_count;

        function new(string name = "ram_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_exp = new("sb_exp", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_exp.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_item);
                if(sb_item.dout !== sb_item.dout_ref || sb_item.tx_valid !== sb_item.tx_valid_ref) begin
                    `uvm_error("SR_SCB", $sformatf("Mismatch!\ndout: %0d Expected: %0d\ntx_valid: %0d Expected: %0d",
                        sb_item.dout, sb_item.dout_ref, sb_item.tx_valid, sb_item.tx_valid_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("SR_SCB", $sformatf("Mmatch!\ndout: %0d Expected: %0d\ntx_valid: %0d Expected: %0d",
                        sb_item.dout, sb_item.dout_ref, sb_item.tx_valid, sb_item.tx_valid_ref), UVM_HIGH);
                    correct_count++;
                end
            end

 
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCB_REPORT", $sformatf("\ntotal correct: %0d\ntotal errors: %0d", correct_count, error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage