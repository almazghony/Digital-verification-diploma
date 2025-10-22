module priority_enc_SVA(
    input clk,
    input rst,
    input [3:0] D,
    input [1:0] Y,
    input valid);

    property reset;
        @(posedge clk) rst |=> (!Y && !valid);
    endproperty

    property p1;
        @(posedge clk) disable iff(rst) !D |=> (!valid);
    endproperty

    property p2;
        @(posedge clk) disable iff(rst) D == 4'b1000 |=> (!Y &&valid);
    endproperty

    property p3;
        @(posedge clk) disable iff(rst) D[2:0] == 3'b100 |=> ((Y==1) && valid);
    endproperty

    property p4;
        @(posedge clk) disable iff(rst) D[1:0] == 2'b10 |=> ((Y==2) && valid);
    endproperty

    property p5;
        @(posedge clk) disable iff(rst) D[0] == 1'b1 |=> ((Y==3) && valid);
    endproperty

    a1: assert property (reset);
    a2: assert property (p1);
    a3: assert property (p2);
    a4: assert property (p3);
    a5: assert property (p4);
    a6: assert property (p5);

    c1: cover property (reset);
    c2: cover property (p1);
    c3: cover property (p2);
    c4: cover property (p3);
    c5: cover property (p4);
    c6: cover property (p5);
endmodule

