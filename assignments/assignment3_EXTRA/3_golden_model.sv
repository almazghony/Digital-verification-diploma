module FSM_010_golden (
    input  logic clk,
    input  logic rst,
    input  logic x,
    output logic y,
    output logic [9:0]users_count
);

    parameter idle = 0;
    parameter store = 1;
    parameter zero = 2;
    parameter one = 3;
    logic [2:0] cs, ns;

    //state memory
    always @(posedge clk, posedge rst) begin
        if(rst)
            cs <= idle;
        else
            cs <= ns;
    end

    //next state logic
    always @(*) begin
        case (cs)
            idle: begin
                if(x)
                    ns <= idle;
                else
                    ns <= zero;
            end
            zero: begin
                if(x)
                    ns <= one;
                else
                    cs <= zero;
            end
            one: begin
                if(x)
                    ns <= idle;
                else
                    ns <= store;
            end
            store: begin
                if(x)
                    ns <= idle;
                else
                    ns <= zero;
            end
        endcase
    end

    //output logic
    always @(posedge clk, posedge rst) begin
        if(rst)
            users_count <= 0;
        else if(cs == store)
            users_count++;
    end
    

    assign y = (cs == store)? 1 : 0; 

endmodule