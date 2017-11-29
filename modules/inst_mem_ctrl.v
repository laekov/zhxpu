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
			4'h3: data <= 16'h6bbf;
			4'h4: data <= 16'h3360;
			4'h5: data <= 16'hdb60;
			4'h6: data <= 16'hdb40;
			4'h9: data <= 16'h10f9;
			default: data <= 16'h0800;
		endcase
	end
endmodule
