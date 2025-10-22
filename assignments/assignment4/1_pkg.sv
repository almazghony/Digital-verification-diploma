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
        randc opcode_e   opcode_array[6];

        //no need for constructor, they will be initialized to 0

        constraint c1 {
            rst dist {0 := 9, 1 := 1};
            

            opcode dist {[OR:ROTATE] := 5, [INVALID_6:INVALID_7] := 1};

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




covergroup cvr_gp(ref opcode_e opcode_tb);

  A_cp : coverpoint A {
    option.comment = "If only the red_op_A is high"; 
    bins A_data_0        = {0};
    bins A_data_max      = {MAXPOS};
    bins A_data_min      = {MAXNEG};
    bins A_data_default  = default;
    bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100}
      iff (red_op_A); 

  }

  B_cp : coverpoint B {
    option.comment = "If only red_op_B is high and red_op_A is low";
    bins B_data_0        = {0};
    bins B_data_max      = {MAXPOS};
    bins B_data_min      = {MAXNEG};
    bins B_data_default  = default;
    bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100}
      iff (red_op_B && !red_op_A);
  }

    ALU_cp : coverpoint opcode_tb {
        bins Bins_shift[]   = {SHIFT, ROTATE};      
        bins Bins_arith[]   = {ADD, MULT};      
        bins Bins_bitwise[] = {OR, XOR};      
        illegal_bins Bins_invalid   = {6, 7};       
        bins Bins_trans     = (OR => XOR => ADD => MULT => SHIFT => ROTATE); 
    }
    op_arth : coverpoint opcode_tb {
        option.weight = 0;
        bins ADD_b = {ADD};
        bins MULT_b = {MULT};
        bins shift = {SHIFT};
    }
    c_B : coverpoint B {
        option.weight = 0;
        bins B_0        = {0};
        bins B_max      = {MAXPOS};
        bins B_min      = {MAXNEG};
        bins walkingones1 = {3'b001};
        bins walkingones2 = {3'b010};
        bins walkingones3 = {3'b100};

    }
    c_A : coverpoint A {
        option.weight = 0;
        bins A_0        = {0};
        bins A_max      = {MAXPOS};
        bins A_min      = {MAXNEG};
        bins walkingones1 = {3'b001};
        bins walkingones2 = {3'b010};
        bins walkingones3 = {3'b100};
    }

    red_A: coverpoint red_op_A;
    red_B: coverpoint red_op_B;
    op: coverpoint opcode_tb;


    c1: cross op_arth, c_B, c_A{
        ignore_bins b1 = binsof(op_arth) intersect {SHIFT};
        ignore_bins b2 = binsof(c_A.walkingones1);
        ignore_bins b3 = binsof(c_A.walkingones2);
        ignore_bins b4 = binsof(c_A.walkingones3);
        ignore_bins b5 = binsof(c_B.walkingones1);
        ignore_bins b6 = binsof(c_B.walkingones2);
        ignore_bins b7 = binsof(c_B.walkingones3);
    }

    c2: cross op_arth, cin {
        ignore_bins b1 = binsof(op_arth) intersect {MULT, SHIFT};

    }
    c3: cross op_arth, direction {
        ignore_bins b1 = binsof(op_arth) intersect {MULT, SHIFT};

    }

    c4: cross op_arth, serial_in {
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

        function new (ref opcode_e opcode_tb);
            cvr_gp = new(opcode_tb);
        endfunction
    endclass
endpackage

