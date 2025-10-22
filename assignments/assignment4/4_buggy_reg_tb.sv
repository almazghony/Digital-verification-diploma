module config_reg_tb();

    typedef enum {
        adc0_reg,
        adc1_reg,
        temp_sensor0_reg,
        temp_sensor1_reg,
        analog_test,
        digital_test,
        amp_gain,
        digital_config,
        break_loop
    } bank_reg;

    logic clk;
    logic reset;
    logic write;
    logic [15:0] data_in;
    bank_reg address;
    logic [15:0] data_out;
    config_reg dut( clk, reset, write, data_in, address, data_out);

    integer correct_count, error_count;

    logic [15:0] reset_assoc[string] = '{
        "adc0_reg" : 16'hFFFF,
        "adc1_reg" : 16'h0,
        "temp_sensor0_reg" : 16'h0,
        "temp_sensor1_reg" : 16'h0,
        "analog_test" : 16'hABCD,
        "digital_test" : 16'h0,
        "amp_gain" : 16'h0,
        "digital_config" : 16'h1
    };

    logic [15:0] data_out_exp;

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        correct_count = 0;
        error_count = 0;
        write = 0;
        data_in = 0;

        assert_reset();

        //write / read test
        write = 1;

        reset = 1;
        data_in = 16'h4000;
        data_out_exp = 16'h4000;
        for(address = address.first; address < address.last; address = address.next) 
            @(negedge clk);
        check_result();


        reset = 0;
        for(address = address.first; address < address.last; address = address.next) begin
            data_in = 16'h0000;
            data_out_exp = 16'h0000;
            @(negedge clk);
            check_result();

            data_in = 16'hffff;
            data_out_exp = 16'hffff;
            @(negedge clk);
            check_result();

            data_in = 16'h8000;
            data_out_exp = 16'h8000;
            @(negedge clk);

            check_result();
            data_in = 16'h4000;
            data_out_exp = 16'h4000;
            @(negedge clk);
            check_result();

            data_in = 16'h0001;
            data_out_exp = 16'h0001;
            @(negedge clk);
            check_result();

            data_in = 16'h0010;
            data_out_exp = 16'h0010;
            @(negedge clk);
            check_result();

            $display("/////////////////////////////////");
        end

        $display("Correct: %d, Error: %d", correct_count, error_count);
        $stop;
    end


    task assert_reset();
        reset = 1;
        @(negedge clk);
        check_reset();
        reset = 0;
    endtask

    task check_reset();
        $display("////////////////////RESET////////////////////");
        for (address = address.first(); address < address.last(); address = address.next()) begin
            @(negedge clk);
            if(data_out != reset_assoc[$sformatf("%s", address.name())]) begin
                $display("RESET ERROR: Address %s, expected %b, got %b", address, reset_assoc[$sformatf("%s", address.name())], data_out);
                error_count++;
            end
            else begin
                correct_count++;
            end
        end
        $display("////////////////////////////////////////");

    endtask

    task check_result();
            if(data_out != data_out_exp) begin
                $display("ERROR: Address %s, expected %b, got %b", address, data_out_exp, data_out);
                error_count++;
            end
            else begin
                correct_count++;
                $display("ERROR: Address %s, expected %b, got %b", address, data_out_exp, data_out);
            end

    endtask

endmodule
