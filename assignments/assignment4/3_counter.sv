////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (counter_if.DUT intrf);

always @(posedge intrf.clk, negedge intrf.rst_n) begin
    if (!intrf.rst_n)
        intrf.count_out <= 0;
    else if (!intrf.load_n)
        intrf.count_out <= intrf.data_load;
    else if (intrf.ce) begin
        if (intrf.up_down)
            intrf.count_out <= intrf.count_out + 1;
        else 
            intrf.count_out <= intrf.count_out - 1;
    end
end

assign intrf.max_count = (intrf.count_out == {intrf.WIDTH{1'b1}})? 1:0;
assign intrf.zero = (intrf.count_out == 0)? 1:0;

endmodule