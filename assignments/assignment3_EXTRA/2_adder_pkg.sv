package adder_pkg;
    typedef enum {ZERO = 0, MAXPOS = 7, MAXNEG = -8} corner_e;

    class rand_input;
        rand bit signed [3:0] A;
        rand bit signed [3:0] B;
        rand bit rst;

        constraint c1 {
            rst dist {0 := 9, 1 := 1};

            A dist {
                ZERO := 9,
                MAXPOS := 9,
                MAXNEG := 9,
                [MAXNEG:MAXPOS] := 1
            };

            B dist {
                ZERO := 5,
                MAXPOS := 5,
                MAXNEG := 5,
                [MAXNEG:MAXPOS] := 1
            };   
        }

        covergroup cg_A (ref bit clk);
            a1: coverpoint A {
                bins zero = {ZERO};
                bins maxpos = {MAXPOS};
                bins maxneg = {MAXNEG};
                bins range = default;
            }
            a2: coverpoint A {
                bins data0_max = (0 => MAXPOS);
                bins data_max_min = (MAXPOS => MAXNEG);
                bins data_min_max = (MAXNEG => MAXPOS);
            }
        endgroup

        covergroup cg_B (ref bit clk);
            b1: coverpoint B {
                bins zero = {ZERO};
                bins maxpos = {MAXPOS};
                bins maxneg = {MAXNEG};
                bins range = default;
            }
            b2: coverpoint B {
                bins data0_max = (0 => MAXPOS);
                bins data_max_min = (MAXPOS => MAXNEG);
                bins data_min_max = (MAXNEG => MAXPOS);
            }
        endgroup

        function new(ref bit clk);
            cg_A = new(clk);
            cg_B = new(clk);
        endfunction
    endclass
endpackage