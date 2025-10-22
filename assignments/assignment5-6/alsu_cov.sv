package cov_pkg;
    import shared_pkg::*;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_cov extends uvm_component;
        `uvm_component_utils(alsu_cov);
        uvm_analysis_export #(alsu_item) cov_export;
        uvm_tlm_analysis_fifo #(alsu_item) cov_fifo;
        alsu_item cov_item;

covergroup cvr_gp;

  A_cp : coverpoint cov_item.A {
    option.comment = "If only the red_op_A is high"; 
    bins A_data_0        = {0};
    bins A_data_max      = {MAXPOS};
    bins A_data_min      = {MAXNEG};
    bins A_data_default  = default;
    bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100}
      iff (cov_item.red_op_A); 

  }

  B_cp : coverpoint cov_item.B {
    option.comment = "If only red_op_B is high and red_op_A is low";
    bins B_data_0        = {0};
    bins B_data_max      = {MAXPOS};
    bins B_data_min      = {MAXNEG};
    bins B_data_default  = default;
    bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100}
      iff (cov_item.red_op_B && !cov_item.red_op_A);
  }

    opcode_transition : coverpoint cov_item.opcode {
        bins Bins_trans = (OR [*2] => XOR[*2] => ADD[*2] => MULT[*2] => SHIFT[*2] => ROTATE[*2]);

    }
    ALU_cp : coverpoint cov_item.opcode {
        bins Bins_shift[]   = {SHIFT, ROTATE};      
        bins Bins_arith[]   = {ADD, MULT};      
        bins Bins_bitwise[] = {OR, XOR};      
        illegal_bins Bins_invalid   = {6, 7};       
    }
    op_arth : coverpoint cov_item.opcode {
        option.weight = 0;
        bins ADD_b = {ADD};
        bins MULT_b = {MULT};
        bins shift = {SHIFT};
    }
    c_B : coverpoint cov_item.B {
        option.weight = 0;
        bins B_0        = {0};
        bins B_max      = {MAXPOS};
        bins B_min      = {MAXNEG};
        bins walkingones1 = {3'b001};
        bins walkingones2 = {3'b010};
        bins walkingones3 = {3'b100};
    }
    c_A : coverpoint cov_item.A {
        option.weight = 0;
        bins A_0        = {0};
        bins A_max      = {MAXPOS};
        bins A_min      = {MAXNEG};
        bins walkingones1 = {3'b001};
        bins walkingones2 = {3'b010};
        bins walkingones3 = {3'b100};
    }

    red_A: coverpoint cov_item.red_op_A;
    red_B: coverpoint cov_item.red_op_B;
    op: coverpoint cov_item.opcode;


    c1: cross op_arth, c_B, c_A{
        ignore_bins b1 = binsof(op_arth) intersect {SHIFT};
        ignore_bins b2 = binsof(c_A.walkingones1);
        ignore_bins b3 = binsof(c_A.walkingones2);
        ignore_bins b4 = binsof(c_A.walkingones3);
        ignore_bins b5 = binsof(c_B.walkingones1);
        ignore_bins b6 = binsof(c_B.walkingones2);
        ignore_bins b7 = binsof(c_B.walkingones3);
    }

    c2: cross op_arth, cov_item.cin {
        ignore_bins b1 = binsof(op_arth) intersect {MULT, SHIFT};

    }
    c3: cross op_arth, cov_item.direction {
        ignore_bins b1 = binsof(op_arth) intersect {MULT, SHIFT};

    }

    c4: cross op_arth, cov_item.serial_in {
        ignore_bins b1 = binsof(op_arth) intersect {MULT, SHIFT};
    }

    c5: cross ALU_cp, red_A, c_A, c_B{
        option.cross_auto_bin_max = 0;
        bins b1 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones1);
        bins b2 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones2);
        bins b3 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones3);
        bins b4 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones1);
        bins b5 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones2);
        bins b6 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_A) intersect {1} &&
                            binsof(c_B) intersect {0} &&
                            binsof(c_A.walkingones3);
    }


    c6: cross ALU_cp, red_B, c_A, c_B{
        option.cross_auto_bin_max = 0;

        bins b1 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones1);

        bins b2 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones2);

        bins b3 = binsof(ALU_cp.Bins_bitwise) intersect {OR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones3);

        bins b4 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones1);

        bins b5 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones2);

        bins b6 = binsof(ALU_cp.Bins_bitwise) intersect {XOR} &&
                            binsof(red_B) intersect {1} &&
                            binsof(c_A) intersect {0} &&
                            binsof(c_B.walkingones3);
    }


    c7: cross red_A, red_B, op {
        ignore_bins b1 = binsof(red_A) intersect {0};
        ignore_bins b2 = binsof(red_B) intersect {0};
        ignore_bins b3 = binsof(op) intersect {OR, XOR};
        
    }
    endgroup


        function new(string name = "alsu_cov", uvm_component parent = null);
            super.new(name, parent);
            cvr_gp = new;
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
                `uvm_info("COVERAGE", $sformatf("OPCODE: %S", cov_item.opcode), UVM_LOW);
                cvr_gp.sample(); 
            end
        endtask
    endclass
endpackage


