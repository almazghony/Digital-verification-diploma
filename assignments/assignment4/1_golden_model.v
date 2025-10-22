module mod1_alsu#(
    parameter FULL_ADDER = "ON", 
    parameter INPUT_PRIORITY = "A"
)(
    input [2:0] a, b, op, 
    input cin, serial_in, dir, red_op_a,
    input red_op_b, bypass_a, bypass_b,
    input clk, rst,
    output reg [15:0] leds,
);

    reg [2:0] a_reg, b_reg, op_reg;
    reg cin_reg, serial_in_reg, dir_reg;
    reg red_op_a_reg, red_op_b_reg, bypass_a_reg, bypass_b_reg;

    wire [5:0] mult_out;
    wire [3:0] adder_out;



    mult_gen_0 mult_inst (
        .A(a),
        .B(b),
        .P(mult_out)
    );

    generate
        if(FULL_ADDER == "ON")
            c_addsub_0 add_inst (
                .A(a),
                .B(b),
                .C_IN(cin),
                .S(adder_out)
            );
        else
            c_addsub_0 add_inst (
                .A(a),
                .B(b),
                .C_IN(1'b0),
                .S(adder_out)
            );
    endgenerate

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            a_reg <= 0;
            b_reg <= 0;
            op_reg <= 0;
            cin_reg <= 0; 
            serial_in_reg <= 0;
            dir_reg <= 0;
            red_op_a_reg <= 0;
            red_op_b_reg <= 0;
            bypass_a_reg <= 0;
            bypass_b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            op_reg <= op;
            cin_reg <= cin; 
            serial_in_reg <= serial_in;
            dir_reg <= dir;
            red_op_a_reg <= red_op_a;
            red_op_b_reg <= red_op_b;
            bypass_a_reg <= bypass_a;
            bypass_b_reg <= bypass_b;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            out_reg <= 0;
            leds <= 0;
            error_flag <= 0;
        end else begin
            error_flag <= 0;
            if(bypass_a_reg) begin
                if(bypass_b_reg) begin
                    out_reg <= (INPUT_PRIORITY == "A") ? a_reg : b_reg;
                end else
                    out_reg <= a_reg;
            end else if(bypass_b_reg) begin
                out_reg <= b;
            end else begin
                if(red_op_a_reg) begin
                    if(red_op_b_reg) begin
                        if(INPUT_PRIORITY == "A") begin
                            case (op)
                                3'b000 : out_reg <= &a_reg;
                                3'b001 : out_reg <= ^a_reg;
                                default : begin 
                                    out_reg <= 0;
                                    leds <= ~leds;
                                    error_flag <= 1;
                                end
                            endcase
                        end else begin
                            case (op)
                                3'b000 : out_reg <= &b_reg;
                                3'b001 : out_reg <= ^b_reg;
                                default : begin 
                                    out_reg <= 0;
                                    leds <= ~leds;
                                    error_flag <= 1;
                                end
                            endcase
                        end
                    end else begin
                        case (op)
                            3'b000 : out_reg <= &a_reg;
                            3'b001 : out_reg <= ^a_reg;
                            default : begin 
                                out_reg <= 0;
                                leds <= ~leds;
                                error_flag <= 1;
                            end
                        endcase
                    end
                end else begin
                    if(red_op_b_reg) begin
                        case (op)
                            3'b000 : out_reg <= &b_reg;
                            3'b001 : out_reg <= ^b_reg;
                            default : begin 
                                out_reg <= 0;
                                leds <= ~leds;
                                error_flag <= 1;
                            end
                        endcase
                    end else begin
                        case (op)
                            3'b000 : out_reg <= a_reg & b_reg;
                            3'b001 : out_reg <= a_reg ^ b_reg;
                            3'b010 : out_reg <= adder_out;
                            3'b011 : out_reg <= mult_out;
                            3'b100 : begin
                                out_reg <= dir_reg ? {out[4:0], serial_in_reg} : {serial_in_reg, out[5:1]};
                            end
                            3'b101 : begin
                                out_reg <= dir_reg ? {out[4:0], out_reg[5]} : {out[0], out[5:1]};
                            end
                            default : begin 
                                out <= 0;
                                leds <= ~leds;
                            end
                        endcase
                    end
                end
            end
        end
    end
endmodule