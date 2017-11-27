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
				data <= 16'h690a;
			end
			4'h2: begin
				data <= 16'h6b80;
			end
			4'h3: begin
				data <= 16'hdb20;
			end
			4'h4: begin
				data <= 16'h0800;
			end
			4'h5: begin
				data <= 16'h9b40;
			end
			default: begin
				data <= 16'h0800;
			end
		endcase
	end
endmodule
