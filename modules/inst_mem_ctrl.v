`timescale 1ns / 1ps
`include "define.v"
// A version for demonstration 
module inst_mem_ctrl(
	input [`RegAddr]addr,
	output reg [`RegValue]data
);
	always @(*) begin
		case (addr[`RegAddr])
			3'h0: begin
				data <= 16'b0110100100000000;
			end
			3'h1: begin
				data <= 16'b0110101000000001;
			end
			3'h2: begin
				data <= 16'b0110110000001010;
			end
			3'h3: begin
				data <= 16'b1110000101001101;
			end
			3'h4: begin
				data <= 16'b0111100101000000;
			end
			3'h5: begin
				data <= 16'b0111101001100000;
			end
			3'h6: begin
				data <= 16'b0100110011111111;
			end
			3'h7: begin
				data <= 16'b0010110011111001;
			end
			3'h8: begin
				data <= 16'b0000100000000000;
			end
			default: begin
				data <= 16'b0000100000000000;
			end
		endcase
	end
endmodule
