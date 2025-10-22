class EX1;
    logic [7:0] data;
    rand logic [3:0] address;
    function new();
        this.data = 5;
        this.address = 0;
    endfunction

    constraint c {
        address dist {0:=10, [1:14]:/80, 15:=10}; 
    }
endclass



module lab22();
    logic [7:0] data_tb;
    logic [3:0] address_tb;

    integer i;
    initial begin
        EX1 obj1 = new;
        for(i = 0; i < 20; i++) begin
            assert(obj1.randomize());
            data_tb = obj1.data;
            address_tb = obj1.address;
            #10;
        end
    end

endmodule