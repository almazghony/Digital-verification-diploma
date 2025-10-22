module ALU_tb();
    logic clk;
    logic reset;
    logic [1:0] Opcode;
    logic signed [3:0] A;
    logic signed [3:0] B;
    logic signed [4:0] C;

    localparam MAXPOS = 4'b0111;
    localparam MAXNEG = 4'b1000;

    ALU_4_bit dut(clk, reset, Opcode, A, B, C);

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    integer i;
    initial begin
        Opcode = 0;
        A = 0;
        B = 0;

        // reset test
        assert_reset();

        Opcode = 0;

        A = MAXPOS; 
        B = MAXPOS;
        @(negedge clk);

        A = MAXPOS; 
        B = MAXNEG;
        @(negedge clk);

        A = MAXPOS; 
        B = 0;     
        @(negedge clk);

        A = MAXNEG; 
        B = MAXPOS;
        @(negedge clk);

        A = MAXNEG; 
        B = MAXNEG;
        @(negedge clk);

        A = MAXNEG; 
        B = 0;     
        @(negedge clk);

        A = 0;      
        B = MAXPOS;
        @(negedge clk);

        A = 0;      
        B = MAXNEG;
        @(negedge clk);

        A = 0;      
        B = 0;     
        @(negedge clk);

        Opcode = 1;

        A = MAXPOS; 
        B = MAXPOS;
        @(negedge clk);

        A = MAXPOS; 
        B = MAXNEG;
        @(negedge clk);

        A = MAXPOS; 
        B = 0;     
        @(negedge clk);

        A = MAXNEG; 
        B = MAXPOS;
        @(negedge clk);

        A = MAXNEG; 
        B = MAXNEG;
        @(negedge clk);

        A = MAXNEG; 
        B = 0;     
        @(negedge clk);

        A = 0;      
        B = MAXPOS;
        @(negedge clk);

        A = 0;      
        B = MAXNEG;
        @(negedge clk);

        A = 0;      
        B = 0;     
        @(negedge clk);

        Opcode = 2;
        
        A = 4'b1111;
        @(negedge clk);
        
        A = 4'b0000;
        @(negedge clk);

        for(i = 0; i < 4; i = i + 1) begin
            A = 0;
            A[i] = 1;
            @(negedge clk);
        end

        Opcode = 3;
        B = 4'b1111;
        B = 4'b0000;
        for(i = 0; i < 4; i = i + 1) begin
            B = 0;
            B[i] = 1;
            @(negedge clk);
        end

        Opcode = 0;
        assert_reset();

        A = $random;
        B = $random;
        @(negedge clk);

        $stop;
    end

    task assert_reset();
        reset = 1;
        @(negedge clk);
        reset = 0;
    endtask

    bind ALU_4_bit ALU_SVA SVA(clk, reset, Opcode, A, B, C);

endmodule