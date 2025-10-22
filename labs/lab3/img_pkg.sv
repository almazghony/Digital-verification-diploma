package img;
    parameter HEIGHT = 10;
    parameter WIDTH = 10;
    parameter PERCENT_WHITE = 20;

    typedef enum {BLACK, WHITE}color_e;
    
    class screen;
        rand color_e pixles[HEIGHT][WIDTH];

        constraint c1 {
            foreach(pixles[i, j])
                pixles[i][j] dist {WHITE := PERCENT_WHITE, BLACK := (100 - PERCENT_WHITE)};
        }
        function void print_screen();
            foreach(pixles[i]) begin
                foreach(pixles[, j])
                    $write("%0d", pixles[i][j]);
                $write("\n");
            end
        endfunction

    endclass

endpackage