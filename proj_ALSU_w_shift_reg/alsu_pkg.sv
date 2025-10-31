package shared_pkg;
    typedef enum {
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
endpackage

