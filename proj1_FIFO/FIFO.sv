////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO (FIFO_if intrf);
 
localparam max_fifo_addr = $clog2(intrf.FIFO_DEPTH);

reg [intrf.FIFO_WIDTH-1:0] mem [intrf.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge intrf.clk or negedge intrf.rst_n) begin
	if (!intrf.rst_n) begin
		wr_ptr <= 0;
		intrf.overflow <= 0; //<<<<<<
		intrf.wr_ack <= 0; //<<<<<<
	end
	else if (intrf.wr_en && count < intrf.FIFO_DEPTH) begin
		mem[wr_ptr] <= intrf.data_in;
		intrf.wr_ack <= 1;
		wr_ptr <= (wr_ptr == intrf.FIFO_DEPTH-1)? 0: wr_ptr + 1; //<<<<<<
		intrf.overflow <= 0;
	end
	else begin 
		intrf.wr_ack <= 0; 
		if (intrf.full && intrf.wr_en)
			intrf.overflow <= 1;
		else
			intrf.overflow <= 0;
	end
end

always @(posedge intrf.clk or negedge intrf.rst_n) begin
	if (!intrf.rst_n) begin
		rd_ptr <= 0;
		intrf.underflow <= 0; //<<<<<<
	end
	else if (intrf.rd_en && count != 0) begin
		intrf.data_out <= mem[rd_ptr];
		rd_ptr = (rd_ptr == intrf.FIFO_DEPTH-1)? 0: rd_ptr + 1; //<<<<<<
		intrf.underflow <= 0;
	end
	else
		if(intrf.rd_en && count == 0)
			intrf.underflow <= 1; //<<<<<<
		else
			intrf.underflow <= 0; //<<<<<<
end

always @(posedge intrf.clk or negedge intrf.rst_n) begin
	if (!intrf.rst_n) begin
		count <= 0;
	end
	else begin
		if	(({intrf.wr_en, intrf.rd_en} == 2'b10) && !intrf.full) 
			count <= count + 1;
		else if ( ({intrf.wr_en, intrf.rd_en} == 2'b01) && !intrf.empty)
			count <= count - 1;

		else if ( ({intrf.wr_en, intrf.rd_en} == 2'b11) && intrf.empty)  //<<<<<<
			count <= count + 1;
		else if ( ({intrf.wr_en, intrf.rd_en} == 2'b11) && intrf.full)  //<<<<<<
			count <= count - 1;
	end
end

assign intrf.full = (count == intrf.FIFO_DEPTH)? 1 : 0;
assign intrf.empty = (count == 0)? 1 : 0;
assign intrf.almostfull = (count == intrf.FIFO_DEPTH-1)? 1 : 0; 
assign intrf.almostempty = (count == 1)? 1 : 0;


























	always_comb begin
	 	if (!intrf.rst_n)
			a_rst: assert final (rd_ptr == 0 && wr_ptr == 0 && count == 0);

	end

	property full_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count == intrf.FIFO_DEPTH) |-> (intrf.full);
	endproperty

	property full_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count != intrf.FIFO_DEPTH) |-> (!intrf.full);
	endproperty

	property wr_ack_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		(intrf.wr_en && !intrf.full) |-> ##1 (intrf.wr_ack); 
	endproperty
	
	property wr_ack_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		!(intrf.wr_en && !intrf.full) |-> ##1 (!intrf.wr_ack); 
	endproperty

	property overflow_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		(intrf.wr_en && intrf.full) |-> ##1 (intrf.overflow); 
	endproperty
	
	property overflow_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		!(intrf.wr_en && intrf.full) |-> ##1 (!intrf.overflow); 
	endproperty

	property empty_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count == 0) |-> (intrf.empty);
	endproperty

	property empty_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count != 0) |-> (!intrf.empty);
	endproperty

	property almostempty_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count == 1) |-> (intrf.almostempty);
	endproperty

	property almostempty_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count != 1) |-> (!intrf.almostempty);
	endproperty

	property underflow_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		(intrf.rd_en && intrf.empty) |-> ##1 (intrf.underflow); 
	endproperty
	
	property underflow_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n) 
		!(intrf.rd_en && intrf.empty) |-> ##1 (!intrf.underflow); 
	endproperty

	property almostfull_p1;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count == intrf.FIFO_DEPTH-1) |-> (intrf.almostfull);
	endproperty

	property almostfull_p2;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count != intrf.FIFO_DEPTH-1) |-> (!intrf.almostfull);
	endproperty

	property wr_p_wrap;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(intrf.wr_en && !intrf.full && wr_ptr == intrf.FIFO_DEPTH-1) |-> ##1 (wr_ptr ==0);
	endproperty

	property rd_p_wrap;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(intrf.rd_en && !intrf.empty && rd_ptr == intrf.FIFO_DEPTH-1) |-> ##1 (rd_ptr ==0);
	endproperty

	property count_wrap;
		@(posedge intrf.clk)
		($past(count) == intrf.FIFO_DEPTH && intrf.rst_n == 0) |-> (count ==0);
	endproperty

	property wr_threshold;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(wr_ptr < intrf.FIFO_DEPTH);
	endproperty

	property rd_threshold;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(rd_ptr < intrf.FIFO_DEPTH);
	endproperty

	property count_threshold;
		@(posedge intrf.clk) disable iff(!intrf.rst_n)
		(count < intrf.FIFO_DEPTH+1);
	endproperty
	
	`ifdef SIM
		full_a1: 	  assert property(full_p1);
		full_a2: 	  assert property(full_p2);
		wr_ack_a1: 	  assert property(wr_ack_p1);
		wr_ack_a2: 	  assert property(wr_ack_p2);
		overflow_a1:  assert property(overflow_p1);
		overflow_a2:  assert property(overflow_p2);
		empty_a1: 	  assert property(empty_p1);
		empty_a2: 	  assert property(empty_p2);
		underflow_a1: assert property(underflow_p1);
		underflow_a2: assert property(underflow_p2);
		almostempty_a1: assert property(almostempty_p1);
		almostempty_a2: assert property(almostempty_p2);
		almostfull_a1: assert property(almostfull_p1);
		almostfull_a2: assert property(almostfull_p2);
		wr_p_wrap_a: assert property(wr_p_wrap);
		rd_p_wrap_a: assert property(rd_p_wrap);
		count_wrap_a: assert property(count_wrap);
		wr_p_threshold_a: assert property(wr_threshold);
		rd_p_threshold_a: assert property(rd_threshold);
		count_threshold_a: assert property(count_threshold);
	`endif

		full_c1: 	  cover property(full_p1);
		full_c2: 	  cover property(full_p2);
		wr_ack_c1: 	  cover property(wr_ack_p1);
		wr_ack_c2: 	  cover property(wr_ack_p2);
		overflow_c1:  cover property(overflow_p1);
		overflow_c2:  cover property(overflow_p2);
		empty_c1: 	  cover property(empty_p1);
		empty_c2: 	  cover property(empty_p2);
		underflow_c1: cover property(underflow_p1);
		underflow_c2: cover property(underflow_p2);
		almostempty_c1: cover property(almostempty_p1);
		almostempty_c2: cover property(almostempty_p2);
		almostfull_c1: cover property(almostfull_p1);
		almostfull_c2: cover property(almostfull_p2);
		wr_p_wrap_c: cover property(wr_p_wrap);
		rd_p_wrap_c: cover property(rd_p_wrap);
		count_wrap_c: cover property(count_wrap);
		wr_p_threshold_c: cover property(wr_threshold);
		rd_p_threshold_c: cover property(rd_threshold);
		count_threshold_c: cover property(count_threshold);
endmodule


