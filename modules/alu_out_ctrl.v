`timescale 1ns / 1ps

module alu_out_ctrl(
	input res[15:0],
	input flag[15:0],
	input memwr_ctrl,
	input memrd_ctrl,
	input mem_addr[17:0],
	output reg mem_read,
	output reg mem_addrl[17:0],
	output reg mem_datal[17:0],
	output reg res[15:0],
	output reg flag
);
	always @(*) begin
		if (mem_wr) begin
			mem_read <= 1'b0;
		end else if (mem_rd) begin
			mem_read <= 1'b1;
		end
	end
endmodule

