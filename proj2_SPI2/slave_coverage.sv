package slave_coverage_pkg;
    import uvm_pkg::*;
    import slave_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class slave_cov extends uvm_component;
        `uvm_component_utils(slave_cov)
        slave_seq_item seq_item;

        uvm_analysis_export #(slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) fifo_export;


        covergroup g1;
        rx_data : coverpoint seq_item.rx_data[9:8];
        ss_n: coverpoint seq_item.SS_n {
            bins normal=(1 => 0[*13] => 1);
            bins Rd_dt=(1 => 0[*23] => 1);
        }
        mosi_cp: coverpoint seq_item.MOSI {
            bins write_add = (0 => 0 => 0);
            bins write_data = (0 => 0 => 1);
            bins READ_ADD = (1 => 1 => 0);
            bins READ_DATA = (1 => 1 => 1);
        }
        sceniario: cross ss_n,mosi_cp {
            ignore_bins illegal1 = binsof(ss_n.normal) && binsof(mosi_cp.READ_DATA);
            ignore_bins illegal2 = binsof(ss_n.Rd_dt) && binsof(mosi_cp.READ_ADD);
            ignore_bins illegal3 = binsof(ss_n.Rd_dt) && binsof(mosi_cp.write_add);
            ignore_bins illegal4 = binsof(ss_n.Rd_dt) && binsof(mosi_cp.write_data);
        } 
        endgroup

        function new(string name ="slave_cov",uvm_component parent=null);
            super.new(name,parent);
            g1 = new;
        endfunction

        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            cov_export = new("cov_export",this);
            fifo_export = new("fifo_export",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(fifo_export.analysis_export);
        endfunction


        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo_export.get(seq_item);
                g1.sample();
            end
        endtask
    endclass
endpackage