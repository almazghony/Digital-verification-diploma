package scoreboard_pkg;
    import shared_pkg::*;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard);
        uvm_analysis_export #(alsu_item) sb_export;
        uvm_tlm_analysis_fifo #(alsu_item) sb_fifo;
        alsu_item sb_item;
        bit signed [2:0]  A_reg, B_reg;
        logic [2:0]       opcode_reg;
        bit               red_op_A_reg, red_op_B_reg;
        bit               bypass_A_reg, bypass_B_reg;
        bit               direction_reg, serial_in_reg;
        bit signed [1:0]  cin_reg;
        bit signed [5:0]  expected_out;    // holds previous out
        logic [15:0]      expected_leds;

        int error_count, correct_count;

        function new(string name = "alsu_scoreboard", uvm_component parent = null);
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
                if (sb_item.out != expected_out || sb_item.leds != expected_leds) begin
                    `uvm_error("SCOREBOARD", $sformatf("Mismatch! out = %0h, leds = %0h, expected_out = %0h, expected_leds = %0h",
                     sb_item.out, sb_item.leds, expected_out, expected_leds));
                    error_count++;
                end
                else begin
                    `uvm_info("SCOREBOARD", $sformatf("Match! out = %0h, leds = %0h, expected_out = %0h, expected_leds = %0h",
                     sb_item.out, sb_item.leds, expected_out, expected_leds), UVM_LOW);
                    correct_count++;
                end
            end
        endtask

        task ref_model(alsu_item item);
            bit invalid_red_op, invalid_opcode, invalid;

            if (item.rst) begin
                A_reg         = 0;
                B_reg         = 0;
                opcode_reg    = 0;
                red_op_A_reg  = 0;
                red_op_B_reg  = 0;
                bypass_A_reg  = 0;
                bypass_B_reg  = 0;
                direction_reg = 0;
                serial_in_reg = 0;
                cin_reg       = 0;
                expected_leds = 0;
                expected_out  = 0;
                return;
            end

            invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
            invalid_opcode = opcode_reg[1] & opcode_reg[2];
            invalid        = invalid_red_op | invalid_opcode;

            if (invalid)
                expected_leds = ~expected_leds;
            else
                expected_leds = 0;


            if (bypass_A_reg)
                expected_out = A_reg;
            else if (bypass_B_reg)
                expected_out = B_reg;
            else if (invalid)
                expected_out = 0;
            else begin
                case (opcode_reg)
                    3'h0: begin 

                        if (red_op_A_reg)
                            expected_out = {5'b0, |A_reg};
                        else if (red_op_B_reg)
                            expected_out = {5'b0, |B_reg};
                        else
                            expected_out = A_reg | B_reg;
                    end
                    3'h1: begin
        
                        if (red_op_A_reg)
                            expected_out = {5'b0, ^A_reg};
                        else if (red_op_B_reg)
                            expected_out = {5'b0, ^B_reg};
                        else
                            expected_out = A_reg ^ B_reg;
                    end
                    3'h2: expected_out =(A_reg + B_reg + cin_reg);
                    3'h3: expected_out = A_reg * B_reg;
                    3'h4: begin
                        if (direction_reg)
                            expected_out = {expected_out[4:0], serial_in_reg};
                        else
                            expected_out = {serial_in_reg, expected_out[5:1]};
                    end
                    3'h5: begin
                        if (direction_reg)
                            expected_out = {expected_out[4:0], expected_out[5]};
                        else
                            expected_out = {expected_out[0], expected_out[5:1]};
                    end
                    default: expected_out = 0;
                endcase
            end

            A_reg         = item.A;
            B_reg         = item.B;
            opcode_reg    = item.opcode;
            red_op_A_reg  = item.red_op_A;
            red_op_B_reg  = item.red_op_B;
            bypass_A_reg  = item.bypass_A;
            bypass_B_reg  = item.bypass_B;
            direction_reg = item.direction;
            serial_in_reg = item.serial_in;
            cin_reg       = item.cin;
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCOREBOARD", $sformatf("Total Errors: %0d", error_count), UVM_LOW);
            `uvm_info("SCOREBOARD", $sformatf("Total Correct: %0d", correct_count), UVM_LOW);
        endfunction
    endclass
endpackage