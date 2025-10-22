module ALU_SVA(
    input        clk,
    input        reset,
    input  [1:0] Opcode,  
    input  signed [3:0] A,
    input  signed [3:0] B,
    input  signed [4:0] C
);

    localparam Add           = 2'b00;
    localparam Sub           = 2'b01;
    localparam Not_A         = 2'b10;
    localparam ReductionOR_B = 2'b11;



    property p_reset;
        @(posedge clk) reset |-> (!C);
    endproperty

    property p_add;
        @(posedge clk) (!reset && Opcode == Add) |=> (C == $past(A) + $past(B));
    endproperty

    property p_sub;
        @(posedge clk) (!reset && Opcode == Sub) |=> (C == $past(A) - $past(B));
    endproperty

    property p_not_a;
        @(posedge clk) (!reset && Opcode == Not_A) |=> (C == ~$past(A));
    endproperty

    property p_red_or;
        @(posedge clk) disable iff (reset) (Opcode == 3'b11) |=> (C == |$past(B));
    endproperty

    a1: assert property (p_reset);
    a2: assert property (p_add);
    a3: assert property (p_sub);
    a4: assert property (p_not_a);
    a5: assert property (p_red_or);

    c1: cover  property (p_reset);
    c2: cover  property (p_add);
    c3: cover  property (p_sub);
    c4: cover  property (p_not_a);
    c5: cover  property (p_red_or);
    
endmodule