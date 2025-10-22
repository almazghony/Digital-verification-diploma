module my_mem_tb();
    logic clk;
    logic write;
    logic read;
    logic [7:0] data_in;
    logic [15:0] address;
    bit   [7:0] data_out;
    
    localparam TESTS = 100;
    logic [15:0] address_array[];
    logic [8:0]  data_to_write_array[];
    logic [8:0]  data_read_expect_assoc[int];
    logic [8:0]  data_read_queue[$];

    my_mem dut (.*);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end
    integer error_count, correct_count;

    task stimulus_gen();
        address_array = new[TESTS];
        data_to_write_array = new[TESTS];
        for(int i = 0; i < TESTS; i++) begin
            address_array[i] = $urandom_range(0, 65535);
            data_to_write_array[i] = $urandom_range(0, 255);
            data_to_write_array[i] = {~^data_to_write_array[i], data_to_write_array[i]};
        end
    endtask

    task golden_model();
        for(int i = 0; i<TESTS; i++) begin
            data_read_expect_assoc[address_array[i]] = data_to_write_array[i];
        end
    endtask

    task check9bits();
        if(data_out !== data_read_expect_assoc[address]) begin
            $display("*** Mismatch at address %0d: expected %0d, got %0d ***", address, data_read_expect_assoc[address], data_out);
            error_count++;
        end else
            correct_count++;
    endtask


    initial begin
        error_count = 0; 
        correct_count = 0;
        write = 0;
        read = 0;
        data_in = 0;
        stimulus_gen();
        golden_model();

        write = 1;
        for(int i = 0; i < TESTS; i++) begin
            address = address_array[i];
            data_in = data_to_write_array[i];
            @(negedge clk);
        end
        write = 0;
        read = 1;
        for(int i = 0; i < TESTS; i++) begin
            address = address_array[i];
            @(negedge clk);
            check9bits();
            data_read_queue.push_back(data_out);
        end

        $display("Correct reads: %0d, Incorrect reads: %0d", correct_count, error_count);
        $stop;
    end
endmodule

