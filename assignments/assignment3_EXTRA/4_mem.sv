module mem();
    logic [23:0] mem [bit[19:0]];

    initial begin
        mem[20'h00000] = 24'hA50400; // reset
        mem[20'h00400] = 24'h123456; // instruction1
        mem[20'h00401] = 24'h789ABC; // instruction2
        mem[20'hFFFFF] = 24'h0F1E2D; //isr

        $display("Number of elements in memory = %0d", mem.num());
        foreach(mem[i]) begin
            $display("mem[%0h] = %0h", i, mem[i]);
        end
    end
endmodule