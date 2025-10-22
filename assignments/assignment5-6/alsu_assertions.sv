import shared_pkg::*;

module SVA (alsu_if alsuif);

    always_comb begin
        if(alsuif.rst)
            a_rst: assert final(alsuif.out == 0 && alsuif.leds == 0);
    end

    
    property p1;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B)
        (alsuif.opcode == OR && alsuif.red_op_A)
        |-> ##2 (alsuif.out == (|$past(alsuif.A, 2)));
    endproperty

    property p2;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_A)
        (alsuif.opcode == OR && alsuif.red_op_B)
        |-> ##2 (alsuif.out == (|$past(alsuif.B, 2)));
    endproperty

    property p3;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        (alsuif.opcode == OR)
        |-> ##2 (alsuif.out == ($past(alsuif.B,2)) | ($past(alsuif.A,2)));
    endproperty

    property p4;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B)
        (alsuif.opcode == XOR && alsuif.red_op_A)
        |-> ##2 (alsuif.out == (^$past(alsuif.A, 2)));
    endproperty

    property p5;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_A)
        (alsuif.opcode == XOR && alsuif.red_op_B)
        |-> ##2 (alsuif.out == (^$past(alsuif.B, 2)));
    endproperty

    property p6;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        (alsuif.opcode == XOR)
        |-> ##2 (alsuif.out == ($past(alsuif.A,2)) ^ ($past(alsuif.B,2)));
    endproperty

    property p7;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        (alsuif.opcode == ADD)
        |-> ##2 (alsuif.out == $past(alsuif.B, 2) + $past(alsuif.A, 2) + $past($signed({0, alsuif.cin}), 2));
    endproperty

    property p8;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        (alsuif.opcode == MULT)
        |-> ##2 (alsuif.out == (($past(alsuif.A, 2)) * ($past(alsuif.B, 2))));
    endproperty

    property p9;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        ((alsuif.opcode == SHIFT) && alsuif.direction )
        |-> ##2 (alsuif.out == ({$past(alsuif.out[4:0]), $past(alsuif.serial_in,2)}));
    endproperty

    property p10;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        ((alsuif.opcode == SHIFT) && !alsuif.direction)
        |-> ##2 (alsuif.out == ({$past(alsuif.serial_in,2), $past(alsuif.out[5:1])}));
    endproperty

    property p11;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        ((alsuif.opcode == ROTATE) && alsuif.direction)
        |-> ##2 (alsuif.out == {$past(alsuif.out[4:0]), $past(alsuif.out[5])});
    endproperty

    property p12;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B || alsuif.red_op_B || alsuif.red_op_A)
        ((alsuif.opcode == ROTATE) && !alsuif.direction)
        |-> ##2 (alsuif.out == {$past(alsuif.out[0]), $past(alsuif.out[5:1])});
    endproperty

    property p13;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B)
        ((alsuif.opcode != INVALID_6 && alsuif.opcode != INVALID_7 && alsuif.opcode != OR && alsuif.opcode != XOR) 
        && (alsuif.red_op_B || alsuif.red_op_A))
        |-> ##2 (alsuif.out == 0);
    endproperty

    property p14;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A || alsuif.bypass_B)
        (alsuif.opcode == INVALID_6 || alsuif.opcode == INVALID_7)
        |-> ##2 (alsuif.out == 0);
    endproperty

    property p15;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.bypass_A) |-> ##2 (alsuif.out == $past(alsuif.A, 2));
    endproperty

    property p16;
        @(posedge alsuif.clk) disable iff(alsuif.rst || alsuif.bypass_A)
        (alsuif.bypass_B) |-> ##2 (alsuif.out == $past(alsuif.B, 2));
    endproperty

    property p17;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        ((alsuif.opcode != INVALID_6 && alsuif.opcode != INVALID_7 && alsuif.opcode != OR && alsuif.opcode != XOR) 
        && (alsuif.red_op_B || alsuif.red_op_A))
        |-> ##2 (alsuif.leds == ~$past(alsuif.leds));
    endproperty


    property p18;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == INVALID_6 || alsuif.opcode == INVALID_7)
        |-> ##2 (alsuif.leds == ~$past(alsuif.leds));
    endproperty
 
    property p19;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode != INVALID_6 && alsuif.opcode != INVALID_7 && !(alsuif.opcode != OR && alsuif.opcode != XOR && (alsuif.red_op_A || alsuif.red_op_B)))
        |-> ##2 (alsuif.leds == 0);
    endproperty

    a1:  assert property (p1)  else $display("ERROR1");
    a2:  assert property (p2)  else $display("ERROR2");
    a3:  assert property (p3)  else $display("ERROR3");
    a4:  assert property (p4)  else $display("ERROR4");
    a5:  assert property (p5)  else $display("ERROR5");
    a6:  assert property (p6)  else $display("ERROR6");
    a7:  assert property (p7)  else $display("ERROR7");
    a8:  assert property (p8)  else $display("ERROR8");
    a9:  assert property (p9)  else $display("ERROR9");
    a10: assert property (p10) else $display("ERROR10");
    a11: assert property (p11) else $display("ERROR11");
    a12: assert property (p12) else $display("ERROR12");
    a13: assert property (p13) else $display("ERROR13");
    a14: assert property (p14) else $display("ERROR14");
    a15: assert property (p15) else $display("ERROR15");
    a16: assert property (p16) else $display("ERROR16");
    a17: assert property (p17) else $display("ERROR17");
    a18: assert property (p18) else $display("ERROR18");
    a19: assert property (p19) else $display("ERROR19");
    

    c1:  cover property (p1);
    c2:  cover property (p2);
    c3:  cover property (p3);
    c4:  cover property (p4);
    c5:  cover property (p5);
    c6:  cover property (p6);
    c7:  cover property (p7);
    c8:  cover property (p8);
    c9:  cover property (p9);
    c10: cover property (p10);
    c11: cover property (p11);
    c12: cover property (p12);
    c13: cover property (p13);
    c14: cover property (p14);
    c15: cover property (p15);
    c16: cover property (p16);
    c17: cover property (p17);
    c18: cover property (p18);
    c19: cover property (p19);
endmodule
