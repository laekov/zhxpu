`timescale 1ns / 1ps
`include "define.v"
// A version for demonstration 
module inst_mem_ctrl(
	input [`RegValue]addr,
	output reg [`RegValue]data
);
	always @(*) begin
		case (addr[3:0])
			4'h1: data <= 16'h690a;
			4'h2: data <= 16'h6a0c;
			4'h3: data <= 16'h6b90;
			4'h4: data <= 16'h3360;
			4'h5: data <= 16'hdb20;
			4'h6: data <= 16'hdb44;
			4'h7: data <= 16'h9b80;
			4'h8: data <= 16'h9ba4;
			4'h9: data <= 16'h10f7;
			default: data <= 16'h0800;
		endcase
	end
endmodule
