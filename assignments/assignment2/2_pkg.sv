package counter_pkg;
    parameter WIDTH = 4;
    class rand_stimuls;
        rand bit             rst_n;
        rand bit             load_n;
        rand bit             up_down;
        rand bit             ce;
        rand bit [WIDTH-1:0] data_load;

        //no need for constructor, they will be initialized to 0

        constraint c1 {
            rst_n dist {1 := 9, 0 := 1};
            ce dist {1 := 9, 0 := 1};
            load_n dist {0 := 7, 1 := 3}; //load_n active 70%
        }
    endclass
endpackage

