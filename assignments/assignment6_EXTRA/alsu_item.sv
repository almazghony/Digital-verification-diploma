package item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh";

    class alsu_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_item);
        
        randc opcode_e           opcode_array[6];
        rand logic signed [2:0]  A;
        rand logic signed [2:0]  B;
        rand logic               cin;
        rand logic               serial_in;
        rand logic               red_op_A;
        rand logic               red_op_B;
        rand opcode_e               opcode;
        rand logic               bypass_A;
        rand logic               bypass_B;
        rand logic               rst;
        rand logic               direction;
        logic             [15:0] leds;
        logic signed      [5:0]  out;

        function new(string name = "alsu_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s, A, = %0d B, = %0d cin, = %0d serial_in, = %0d red_op_A, = %0d red_op_B, = %0d, opcode, = %0d bypass_A, = %0d bypass_B, = %0d rst, = %0d direction, = %0d leds, = %0d out = %0d", 
                super.convert2string(), A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, rst, direction, leds, out);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("%s, A, = %0d B, = %0d cin, = %0d serial_in, = %0d red_op_A, = %0d red_op_B, = %0d, opcode, = %0d bypass_A, = %0d bypass_B, = %0d rst, = %0d direction, = %0d", 
                super.convert2string(), A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, rst, direction);
        endfunction

        constraint reset_c {
            rst dist {0 := 9, 1 := 1};
        }
        
        constraint invalid_c {
            opcode dist {[OR:ROTATE] := 5, [INVALID_6:INVALID_7] := 1};
        }

        constraint bypass_c {
            bypass_A dist {1 := 1, 0 := 7};
            bypass_B dist {1 := 1, 0 := 7};
        }

        constraint OR_XOR {
            if(opcode == OR || opcode == XOR) {
                if(red_op_A) { //priority for A so red_op_B here doesn't matter
                    A dist {
                        [3'b000:3'b111] := 1,
                        3'b001 := 2,
                        3'b010 := 2,
                        3'b100 := 2
                        };
                    B == 3'b000;
                }

                else if(red_op_B){
                    A == 3'b000;
                    B dist {
                        [3'b000:3'b111] := 1,
                        3'b001 := 2,
                        3'b010 := 2,
                        3'b100 := 2
                    };    
                }
            }
            
            else {
                red_op_A dist {0 := 7, 1 := 3};
                red_op_B dist {0 := 7, 1 := 3};
            }
        }
        constraint add_mult_c {   
            if(opcode == ADD || opcode == MULT) {
                A dist {[3'b001:3'b110] := 1, MAXPOS := 2, ZERO := 2, MAXNEG := 2};
                B dist {[3'b001:3'b110] := 1, MAXPOS := 2, ZERO := 2, MAXNEG := 2};
            }
        }

        constraint opcode_array_c {        
            foreach (opcode_array[i])
                opcode_array[i] inside {SHIFT, ROTATE, ADD, MULT, OR, XOR};
        }
    endclass
endpackage

