module priority_enc_tb();
  logic [3:0] D;
  logic       clk;
  logic       rst;
  logic [1:0] Y;
  logic       valid;

  priority_enc dut(clk, rst, D, Y, valid);

  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  integer i;
  initial begin
    //RESET test
    rst = 1;
    @(negedge clk);
    rst = 0;
    
    //TEST_1
    for(i = 0; i < 16; i = i + 1) begin
      D = i;
      @(negedge clk);
    end
    D = 0;
    @(negedge clk);

    rst = 1;
    @(negedge clk);
    rst = 0;
    $stop;
  end


    bind priority_enc priority_enc_SVA priority_enc_SVA_inst(clk, rst, D, Y, valid);

endmodule
