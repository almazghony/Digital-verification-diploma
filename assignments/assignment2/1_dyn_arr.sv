module dyn_arr();
    int dyn_array1[];
    int dyn_array2[];


    initial begin
        dyn_array2 = '{9, 1, 8, 3, 4, 4};
        dyn_array1 = new[6];

        foreach (dyn_array1[j]) dyn_array1[j] = j;

        $display("*** Array 1 : %p, size = %0d ***", dyn_array1, $size(dyn_array1));

        dyn_array1.delete();


        dyn_array2.reverse();
        $display("*** Reversed Array 2 %p ***", dyn_array2);
        dyn_array2.sort();
        $display("*** Sorted Array 2 : %p ***", dyn_array2);
        dyn_array2.rsort();
        $display("*** Reverse sorted Array 2 : %p ***", dyn_array2);
        dyn_array2.shuffle();
        $display("*** shuffled  Array 2 : %p ***", dyn_array2);
        
    end
endmodule

