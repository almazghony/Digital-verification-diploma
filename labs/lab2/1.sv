import pkg::*;

module lab21();
    MemTrans obj1;
    MemTrans obj2;

    initial begin
        obj1 = new(,2);
        obj2 = new(3, 4);
        obj1.print();
        obj2.print();
    end
endmodule


