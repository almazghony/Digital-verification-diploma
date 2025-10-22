package counter_pkg;
    parameter WIDTH = 4;
    parameter MAX_VALUE = 2**WIDTH - 1;
    class rand_stimuls;
        rand logic             rst_n;
        rand logic             load_n;
        rand logic             up_down;
        rand logic             ce;
        rand logic [WIDTH-1:0] data_load;

        //no need for constructor, they will be initialized to 0 by default
        constraint c1 {
            rst_n dist {1 := 9, 0 := 1};
            ce dist {1 := 9, 0 := 1};
            load_n dist {0 := 7, 1 := 3}; 
        }

        covergroup cg1(ref logic [WIDTH-1:0]count_out, ref logic clk) @(posedge clk);
            data_load_cp : coverpoint data_load iff(rst_n && !load_n);
            count_out_cp : coverpoint count_out iff(rst_n && up_down && ce);
            count_out_cp2 : coverpoint count_out iff(rst_n && up_down && ce) {
                bins ovrflow = (MAX_VALUE => 0);
            }
            count_out_cp3 : coverpoint count_out iff(rst_n && !up_down && ce);
            count_out_cp4 : coverpoint count_out iff(rst_n && up_down && ce) {
                bins ovrflow = (MAX_VALUE => 0);
            }
        endgroup
  
        function new (ref logic [WIDTH-1:0]count_out, ref logic clk);
            cg1 = new(count_out, clk);
        endfunction
    endclass
endpackage

