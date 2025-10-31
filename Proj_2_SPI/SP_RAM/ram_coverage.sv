package ram_coverage_pkg;
    import ram_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_coverage extends uvm_component;
        `uvm_component_utils(ram_coverage);
        uvm_analysis_export #(ram_seq_item) cov_exp;
        uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
        ram_seq_item cov_item;

        covergroup cov_gp;
            rx_valid_p: coverpoint cov_item.rx_valid{
                option.weight = 0;
            }

            din_p_all: coverpoint cov_item.din[9:8];

            all_transition: coverpoint cov_item.din[9:8] {
                bins wr_data_after_wr_address = (2'b00 => 2'b01);
                bins rd_data_after_rd_address = (2'b10 => 2'b11);
                bins all_transition = (2'b00 => 2'b01 => 2'b10 => 2'b11);
            }
            c1: cross din_p_all, rx_valid_p {
                ignore_bins b1 = binsof(rx_valid_p) intersect {0};
            }

            c2: cross din_p_all , rx_valid_p {
                option.cross_auto_bin_max = 0;
                bins b2 = binsof(rx_valid_p) intersect {1} 
                    && binsof(din_p_all) intersect {2'b11};
           }
            
        endgroup

        function new(string name = "ram_coverage", uvm_component parent = null);
            super.new(name, parent);
            cov_gp = new;
        endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_exp = new("cov_exp", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_exp.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(cov_item);
            cov_gp.sample();
        end
    endtask
    endclass
endpackage