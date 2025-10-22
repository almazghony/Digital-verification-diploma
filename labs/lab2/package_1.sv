package pkg;
    class MemTrans;
        logic [7:0] data_in;
        logic [3:0] addr;
        function new(logic [7:0] data_in = 0, logic [3:0] addr = 0);
            this.data_in = data_in;
            this.addr = addr;
        endfunction

        function print();
            $display("******* data_in: %0d, addr: %0d *******", this.data_in, this.addr);
        endfunction
    endclass
endpackage