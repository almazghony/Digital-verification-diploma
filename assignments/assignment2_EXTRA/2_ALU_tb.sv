import ALU_pkg::*;

module ALU_tb();
    logic               clk;
    logic               reset;
    opcode_e            Opcode;
    logic signed  [3:0] A;
    logic signed  [3:0] B;
    logic signed  [4:0] C;
    logic signed  [4:0] C_exp;

    integer correct_count, error_count;

    alu_input my_input;

    ALU_4_bit dut(.*);

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        correct_count = 0;
        error_count = 0;
        Opcode  = Add;
        A       = 0;
        B       = 0;

        //reset_test
        reset   = 0;
        check_result();

        //randomize test
        my_input = new();
        repeat(20) begin
            assert(my_input.randomize());
            reset = my_input.reset;
            Opcode = my_input.Opcode;
            A = my_input.A;
            B = my_input.B;
            check_result();
        end

        $display("*** ERROR count: %0d, CORRECT count: %0d", error_count, correct_count);
        $stop;    
    end

   always @(posedge clk, posedge reset) begin
        if (reset)
	        C_exp <= 5'b0;
        else
            case (Opcode)
                Add:            C_exp <= A + B;
                Sub:            C_exp <= A - B;
                Not_A:          C_exp <= ~A;
                ReductionOR_B:  C_exp <= |B;
            endcase
   end


    task check_result();
        @(negedge clk);
        if(C != C_exp) begin
            $display("*** ERROR! at time %0t, C = %0d, Expected = %0d***",
                $time, C, C_exp);
            error_count++;
        end
        else
            correct_count++;
    
    endtask
endmodule