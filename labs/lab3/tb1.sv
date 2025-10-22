import img::*;

module print();
    screen obj;

    initial begin
        obj = new();
        obj.randomize();

        obj.print_screen();
    end
endmodule