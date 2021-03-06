`timescale 1ns / 1ps
`include "define.v"
// A version for demonstration 
module inst_mem_ctrl(
	input [`RegValue]addr,
	output reg [`RegValue]data
);
	always @(*) begin
		case (addr[3:0])
			4'h1: begin
				data <= 16'b0110100100000001;
			end
			4'h2: begin
				data <= 16'b0110101000000010;
			end
			4'h3: begin
				data <= 16'b0110110010001010;
			end
			4'h4: begin
				data <= 16'b1110000101001101;
			end
			4'h5: begin
				data <= 16'b0111100101000000;
			end
			4'h6: begin
				data <= 16'b0111101001100000;
			end
			4'h7: begin
				data <= 16'b0100110011111111;
			end
			4'h8: begin
				data <= 16'b0010110011111100;
			end
			4'h9: begin
				data <= 16'b0000100000000000;
			end
			default: begin
				data <= 16'b0000100000000000;
			end
		endcase
	end
endmodule
