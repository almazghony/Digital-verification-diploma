module array();

    bit [11:0] my_array[4];

    initial begin
        my_array[0] = 12'h012;
        my_array[1] = 12'h345;
        my_array[2] = 12'h678;
        my_array[3] = 12'h9AB;

        $display("*** a. using for loop: ***");
        for(int i = 0; i < 4; i++)
            $display(">>> my_array[%0d][5:4] = %0d <<<", i, my_array[i][5:4]);

        $display("*** b. using foreach: ***");
        foreach(my_array[j])
            $display(">>> my_array[%0d][5:4] = %0d <<<", j, my_array[j][5:4]);
    end
endmodule

