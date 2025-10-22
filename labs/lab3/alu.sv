import test_pkg::*;

module alu_seq(operand1, operand2, clk, rst, opcode, out);
input byte operand1, operand2;
input clk, rst;
input opcode_e opcode;
output byte out;

always @(posedge clk) begin
	if (rst)
		out <= 0;
	else 
		case (opcode)
			ADD: out <= operand1 + operand2;
			SUB: out <= operand1 - operand2;
			MULT:out <= operand1 * operand2; 
			DIV: out <= operand1 / operand2;
			default: out <= 0;
		endcase
end
endmodule