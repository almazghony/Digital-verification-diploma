package ALSU_pkg;

    typedef enum bit[2:0] {
        OR, 
        XOR, 
        ADD, 
        MULT, 
        SHIFT, 
        ROTATE, 
        INVALID_6, 
        INVALID_7
    } opcode_e;

    parameter MAXPOS = 3'b011;
    parameter ZERO = 3'b000;
    parameter MAXNEG = 3'b100;

    class rand_stimuls;
        rand bit  [2:0] A;
        rand bit  [2:0] B;
        rand bit        rst;
        rand bit        red_op_A;
        rand bit        red_op_B;
        rand bit        bypass_A;
        rand bit        bypass_B;
        rand bit        cin;
        rand bit        serial_in;
        rand bit        direction;
        rand opcode_e   opcode;

        //no need for constructor, they will be initialized to 0

        constraint c1 {
            rst dist {0 := 9, 1 := 1};
            

            opcode dist {[OR:ROTATE] := 3, [INVALID_6:INVALID_7] := 1};

            bypass_A dist {1 := 3, 0 := 7};
            bypass_B dist {1 := 3, 0 := 7};

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
            
            if(opcode == ADD || opcode == MULT) {
                A dist {[3'b001:3'b110] := 1, MAXPOS := 2, ZERO := 2, MAXNEG := 2};
                B dist {[3'b001:3'b110] := 1, MAXPOS := 2, ZERO := 2, MAXNEG := 2};
            }
        }
    endclass
endpackage

