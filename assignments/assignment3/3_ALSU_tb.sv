import ALSU_pkg::*;

module ALSU_tb();
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    bit signed [2:0]  A;
    bit signed [2:0]  B;
    bit               cin;
    bit               serial_in;
    bit               red_op_A;
    bit               red_op_B;
    opcode_e          opcode;
    bit               bypass_A;
    bit               bypass_B;
    bit               clk;
    bit               rst;
    bit               direction;
    bit        [15:0] leds;
    bit signed [5:0]  out;

    reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    reg         [2:0] opcode_reg;
    reg signed  [1:0] cin_reg;
    reg signed  [2:0] A_reg, B_reg;

    bit               invalid;

    rand_stimuls my_inputs; //handle

    bit [15:0]  leds_exp;
    bit [5:0]   out_exp;

    integer correct_count, error_count;

    ALSU dut(.*);

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end


    initial begin
        correct_count = 0;
        error_count   = 0;
        A = 0;
        B = 0;
        cin = 0;
        serial_in = 0;
        red_op_A = 0;
        red_op_B = 0;
        bypass_A = 0;
        bypass_B = 0;
        direction = 0;

       //reset test
        rst = 1;
        check_result();

        my_inputs = new(opcode);
        //////random test ///////
        //loop1
        my_inputs.c2.constraint_mode(0); //disable
        for(int i = 0; i<10000; i++) begin
            assert(my_inputs.randomize());

            A = my_inputs.A;
            rst = my_inputs.rst;
            B = my_inputs.B;
            cin = my_inputs.cin;
            serial_in = my_inputs.serial_in;
            red_op_A = my_inputs.red_op_A;
            red_op_B = my_inputs.red_op_B;
            opcode = my_inputs.opcode;
            bypass_A = my_inputs.bypass_A;
            bypass_B = my_inputs.bypass_B;
            direction = my_inputs.direction;

            check_result();
        end

        //loop2
        my_inputs.constraint_mode(0); //disable
        rst = 0;
        bypass_A = 0;
        bypass_B = 0;
        red_op_A = 0;
        red_op_B = 0;
        my_inputs.c2.constraint_mode(1); //enable
        for(int i = 0; i<10000; i++) begin
            assert(my_inputs.randomize());

            A = my_inputs.A;
            B = my_inputs.B;
            cin = my_inputs.cin;
            serial_in = my_inputs.serial_in;
            direction = my_inputs.direction;
            
            foreach(my_inputs.opcode_array[j]) begin //this will loop 6 times
                opcode = my_inputs.opcode_array[j];
                check_result();        
            end
        end

        $display("*** ERROR count: %0d, CORRECT count: %0d", error_count, correct_count);
        $stop;        
    end

    //golden model
    assign invalid = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2])
        ||(opcode_reg[1] & opcode_reg[2]);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cin_reg <= 0;
            red_op_B_reg <= 0;
            red_op_A_reg <= 0;
            bypass_B_reg <= 0;
            bypass_A_reg <= 0;
            direction_reg <= 0;
            serial_in_reg <= 0;
            opcode_reg <= 0;
            A_reg <= 0;
            B_reg <= 0;
        end else begin
            cin_reg <= cin;
            red_op_B_reg <= red_op_B;
            red_op_A_reg <= red_op_A;
            bypass_B_reg <= bypass_B;
            bypass_A_reg <= bypass_A;
            direction_reg <= direction;
            serial_in_reg <= serial_in;
            opcode_reg <= opcode;
            A_reg <= A;
            B_reg <= B;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            leds_exp <= 0;
        end else begin
            if (invalid)
                leds_exp <= ~leds_exp;
            else
                leds_exp <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            out_exp <= 0;
        else begin
            if (bypass_A_reg && bypass_B_reg)
                out_exp <= A_reg;
            else if (bypass_A_reg)
                out_exp <= A_reg;
            else if (bypass_B_reg)
                out_exp <= B_reg;
            else if (invalid) 
                out_exp <= 0;
            else begin
                case (opcode_reg)
                3'h0: begin 
                    if (red_op_A_reg && red_op_B_reg)
                        out_exp <= |A_reg;
                    else if (red_op_A_reg) 
                        out_exp <= |A_reg;
                    else if (red_op_B_reg)
                        out_exp <= |B_reg;
                    else 
                        out_exp <= A_reg | B_reg;
                end
                3'h1: begin
                    if (red_op_A_reg && red_op_B_reg)
                        out_exp <= ^A_reg;
                    else if (red_op_A_reg) 
                        out_exp <= ^A_reg;
                    else if (red_op_B_reg)
                        out_exp <= ^B_reg;
                    else 
                        out_exp <= A_reg ^ B_reg;
                end

                3'h2: out_exp <= A_reg + B_reg + cin_reg;
                3'h3: out_exp <= A_reg * B_reg;
                3'h4: begin
                    if (direction_reg)
                        out_exp <= {out_exp[4:0], serial_in_reg};
                    else
                        out_exp <= {serial_in_reg, out_exp[5:1]};
                end
                3'h5: begin
                    if (direction_reg)
                        out_exp <= {out_exp[4:0], out_exp[5]};
                    else
                        out_exp <= {out_exp[0], out_exp[5:1]};
                end
                endcase
            end 
        end
    end

    task check_result();
        @(negedge clk);
        @(negedge clk);
        if(out != out_exp || leds != leds_exp) begin
            $display("*** ERROR! at time %0t, out = %0d, Expected : %0d, leds = %0d, Expected : %0d ***"
                , $time, out, out_exp, leds, leds_exp);
            error_count++;
        end
        else
            correct_count++;
            
    endtask

    always @(posedge clk) @(posedge clk)
        if (!rst && !(bypass_A || bypass_B))
            my_inputs.cvr_gp.sample();

endmodule