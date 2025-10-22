package ALU_pkg;
    typedef enum logic [1:0] {
        Add,
        Sub,
        Not_A,
        ReductionOR_B
    } opcode_e;


    class alu_input;
        rand logic        clk;
        rand logic        reset;
        rand opcode_e     Opcode;	
        rand logic [3:0]  A;
        rand logic [3:0]  B;

        // no need for constructor

        constraint c1 {
            reset dist {0 := 9, 1 := 1};
        }
    endclass
endpackage